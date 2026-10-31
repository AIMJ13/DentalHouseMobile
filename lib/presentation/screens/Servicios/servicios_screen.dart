import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../data/models/service_model.dart';
import '../../../services/service_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/dental_logo.dart';
import '../../widgets/user_badge.dart';
import 'servicio_modal.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  final TextEditingController _searchController = TextEditingController();

  final ServiceService _serviceService = sl<ServiceService>();

  List<ServiceModel> _servicios = [];

  String _filtroSeleccionado = 'Todos';

  final List<String> _filtros = ['Todos', 'Activos', 'Inactivos'];

  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarServicios();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarServicios() async {
    if (!mounted) return;

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final servicios = await _serviceService.getServices();

      if (!mounted) return;

      setState(() {
        _servicios = servicios;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
        _error =
            'No se pudieron cargar los servicios. Revisá tu conexión e intentá nuevamente.';
      });
    }
  }

  List<ServiceModel> _obtenerServiciosFiltrados() {
    final query = _searchController.text.toLowerCase().trim();

    return _servicios.where((servicio) {
      final nombre = servicio.serviceName.toLowerCase();
      final id = servicio.serviceId.toString();

      final coincideBusqueda =
          query.isEmpty || nombre.contains(query) || id.contains(query);

      if (!coincideBusqueda) return false;

      if (_filtroSeleccionado == 'Activos' && !servicio.state) {
        return false;
      }

      if (_filtroSeleccionado == 'Inactivos' && servicio.state) {
        return false;
      }

      return true;
    }).toList();
  }

  int get _totalServicios => _servicios.length;

  int get _totalActivos =>
      _servicios.where((servicio) => servicio.state).length;

  int get _totalInactivos =>
      _servicios.where((servicio) => !servicio.state).length;

  String _normalizarCosto(String costo) {
    return costo.replaceFirst(RegExp(r'^C\$\s*'), '').trim();
  }

  Future<void> _guardarServicio({
    required String? id,
    required String nombre,
    required String costo,
    required bool activo,
    required bool estadoAnterior,
  }) async {
    final costoApi = _normalizarCosto(costo);

    if (id != null) {
      final serviceId = int.parse(id);

      await _serviceService.updateService(
        id: serviceId,
        serviceName: nombre,
        cost: costoApi,
        state: estadoAnterior,
      );

      if (activo != estadoAnterior) {
        await _serviceService.setState(serviceId, activo);
      }
    } else {
      await _serviceService.createService(
        serviceName: nombre,
        cost: costoApi,
        state: activo,
      );
    }

    await _cargarServicios();
  }

  void _abrirModalServicio({
    String? id,
    String? nombre,
    String? costo,
    bool activo = true,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ServicioModal(
          id: id,
          nombre: nombre,
          costo: costo,
          activo: activo,
          onGuardar: (nuevoNombre, nuevoCosto, nuevoActivo) async {
            await _guardarServicio(
              id: id,
              nombre: nuevoNombre,
              costo: nuevoCosto,
              activo: nuevoActivo,
              estadoAnterior: activo,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String rol = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).currentRole;

    final bool esAdmin = rol == 'Administrador';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: const DentalLogo(),
        actions: const [UserBadge()],
      ),
      body: RefreshIndicator(
        onRefresh: _cargarServicios,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEncabezado(esAdmin),
              const SizedBox(height: 16),

              _buildBuscador(),

              const SizedBox(height: 12),

              _buildFiltros(),

              const SizedBox(height: 16),

              _buildMetricas(),

              const SizedBox(height: 16),

              _buildTituloCatalogo(),

              const SizedBox(height: 12),

              if (_cargando)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                _buildError()
              else if (_obtenerServiciosFiltrados().isEmpty)
                _buildSinResultados()
              else
                for (final servicio in _obtenerServiciosFiltrados())
                  _buildServicioCard(servicio: servicio, esAdmin: esAdmin),
            ],
          ),
        ),
      ),
      floatingActionButton: esAdmin
          ? FloatingActionButton(
              onPressed: _cargando ? null : () => _abrirModalServicio(),
              backgroundColor: Colors.blue[700],
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: rol == 'Recepcionista' ? 4 : 1,
      ),
    );
  }

  Widget _buildEncabezado(bool esAdmin) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.medical_services_outlined,
            color: Colors.blue[700],
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Catálogo de Servicios',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                esAdmin
                    ? 'Administra tarifas y tratamientos ofrecidos en la clínica.'
                    : 'Consulta de tarifas y tratamientos odontológicos.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBuscador() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (valor) {
          setState(() {});
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          hintText: 'Buscar servicio por nombre o código...',
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFiltros() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filtro in _filtros)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _filtroSeleccionado = filtro;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _filtroSeleccionado == filtro
                        ? Colors.blue[700]
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _filtroSeleccionado == filtro
                          ? Colors.blue[700]!
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    filtro,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _filtroSeleccionado == filtro
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetricas() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricaItem(Colors.amber[700]!, 'Total:', ' $_totalServicios'),
          _buildSeparadorVertical(),
          _buildMetricaItem(Colors.green[600]!, 'Activos:', ' $_totalActivos'),
          _buildSeparadorVertical(),
          _buildMetricaItem(
            Colors.red[600]!,
            'Inactivos:',
            ' $_totalInactivos',
          ),
        ],
      ),
    );
  }

  Widget _buildTituloCatalogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'CATÁLOGO DE SERVICIOS',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            letterSpacing: 0.5,
          ),
        ),
        Text(
          '${_obtenerServiciosFiltrados().length} mostrados',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 12),
      child: Column(
        children: [
          Icon(Icons.cloud_off_outlined, size: 45, color: Colors.red[300]),
          const SizedBox(height: 12),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _cargarServicios,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSinResultados() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off, size: 45, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              'No se encontraron servicios.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparadorVertical() {
    return Container(height: 14, width: 1, color: Colors.grey[300]);
  }

  Widget _buildMetricaItem(Color puntoColor, String etiqueta, String valor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: puntoColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(etiqueta, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildServicioCard({
    required ServiceModel servicio,
    required bool esAdmin,
  }) {
    final id = servicio.serviceId.toString();
    final nombre = servicio.serviceName;
    final costo = servicio.cost;
    final activo = servicio.state;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: esAdmin
          ? () => _abrirModalServicio(
              id: id,
              nombre: nombre,
              costo: costo,
              activo: activo,
            )
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'SRV-$id',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: activo ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: activo ? Colors.green[600] : Colors.red[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        activo ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: activo ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: activo ? Colors.blue[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: activo ? Colors.blue[100]! : Colors.red[100]!,
                    ),
                  ),
                  child: Icon(
                    Icons.medical_services_outlined,
                    color: activo ? Colors.blue[700] : Colors.red[400],
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Costo: C\$ $costo',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
                if (esAdmin)
                  Icon(Icons.edit_outlined, color: Colors.grey[400], size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
