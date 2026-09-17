import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/confirm_dialog.dart';
import '../../Widget/custom_button.dart';
import '../../Widget/dental_logo.dart';
import '../../Widget/menu_mas_modal.dart';
import '../../routes.dart';
import 'servicio_modal.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroSeleccionado = 'Todos';
  final List<String> _filtros = ['Todos', 'Activos', 'Inactivos', 'Categoría'];
  final int _currentIndex = 1;

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, Routes.home);
      return;
    }
    if (index == 1) {
      return;
    }
    if (index == 2) {
      Navigator.pushReplacementNamed(context, Routes.ventas);
      return;
    }
    if (index == 3) {
      Navigator.pushReplacementNamed(context, Routes.citas);
      return;
    }
    if (index == 4) {
      mostrarMenuMas(context);
      return;
    }
  }

  List<Map<String, dynamic>> _obtenerServiciosFiltrados() {
    final query = _searchController.text.toLowerCase().trim();
    List<Map<String, dynamic>> filtrados = [];
    for (var srv in listaServicios) {
      final nombre = (srv['nombre'] as String).toLowerCase();
      final id = (srv['id'] as String).toLowerCase();
      final coincide = query.isEmpty || nombre.contains(query) || id.contains(query);
      if (!coincide) continue;
      if (_filtroSeleccionado == 'Activos' && srv['activo'] != true) continue;
      if (_filtroSeleccionado == 'Inactivos' && srv['activo'] != false) continue;
      filtrados.add(srv);
    }
    return filtrados;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: const DentalLogo(),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.blue[700],
                  child: const Text(
                    'A',
                    style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Administrador',
                  style: TextStyle(fontSize: 12, color: Colors.blue[800], fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.medical_services_outlined, color: Colors.blue[700], size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gestión de Servicios',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Administra los servicios clínicos disponibles para ventas, citas y atención odontológica.',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
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
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var filtro in _filtros)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _filtroSeleccionado = filtro;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: _filtroSeleccionado == filtro ? Colors.blue[700] : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _filtroSeleccionado == filtro ? Colors.blue[700]! : Colors.grey[300]!,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                filtro,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _filtroSeleccionado == filtro ? Colors.white : Colors.grey[700],
                                ),
                              ),
                              if (filtro == 'Categoría') ...[
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 16,
                                  color: _filtroSeleccionado == filtro ? Colors.white : Colors.grey[700],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricaItem(Colors.amber[700]!, 'Total:', ' ${metricasServicios['total']}'),
                  _buildSeparadorVertical(),
                  _buildMetricaItem(Colors.green[600]!, 'Activos:', ' ${metricasServicios['activos']}'),
                  _buildSeparadorVertical(),
                  _buildMetricaItem(Colors.red[600]!, 'Inactivos:', ' ${metricasServicios['inactivos']}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
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
            ),
            const SizedBox(height: 12),
            for (var srv in _obtenerServiciosFiltrados())
              _buildServicioCard(
                id: srv['id'] as String,
                nombre: srv['nombre'] as String,
                costo: srv['costo'] as String,
                activo: srv['activo'] as bool,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirModalServicio(),
        backgroundColor: Colors.blue[700],
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Resumen'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Servicios'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Ventas'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Citas'),
            BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparadorVertical() {
    return Container(
      height: 14,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildMetricaItem(Color puntoColor, String etiqueta, String valor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: puntoColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          etiqueta,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
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
    required String id,
    required String nombre,
    required String costo,
    required bool activo,
  }) {
    return Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  id,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue[700]),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                  border: Border.all(color: activo ? Colors.blue[100]! : Colors.red[100]!),
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
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Costo: $costo',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Editar',
                  onPressed: () => _abrirModalServicio(id: id, nombre: nombre, costo: costo, activo: activo),
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: activo ? 'Desactivar' : 'Activar',
                  onPressed: () => _mostrarDialogoEstado(id: id, nombre: nombre, costo: costo, activo: activo),
                  color: activo ? Colors.red[500] : Colors.teal[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
          onGuardar: (nuevoNombre, nuevoCosto, nuevoActivo) {
            setState(() {
              if (id != null) {
                for (var srv in listaServicios) {
                  if (srv['id'] == id) {
                    srv['nombre'] = nuevoNombre;
                    srv['costo'] = nuevoCosto;
                    srv['activo'] = nuevoActivo;
                    break;
                  }
                }
              } else {
                final nuevoId = 'SRV-00${listaServicios.length + 1}';
                listaServicios.insert(0, {
                  'id': nuevoId,
                  'nombre': nuevoNombre,
                  'costo': nuevoCosto,
                  'activo': nuevoActivo,
                });
              }
            });
          },
        );
      },
    );
  }

  void _cambiarEstadoServicio(String id, bool nuevoEstado) {
    setState(() {
      for (var srv in listaServicios) {
        if (srv['id'] == id) {
          srv['activo'] = nuevoEstado;
          break;
        }
      }
    });
  }

  void _mostrarDialogoEstado({
    required String id,
    required String nombre,
    required String costo,
    required bool activo,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ConfirmDialog(
          titulo: activo ? '¿Desactivar Servicio?' : '¿Activar Servicio?',
          subtitulo: 'Confirmar cambio de estado del servicio',
          icono: activo ? Icons.warning_amber_rounded : Icons.check_circle_outline,
          colorIcono: activo ? Colors.red[600] : Colors.teal[700],
          colorFondoIcono: activo ? Colors.red[50] : Colors.teal[50],
          colorAdvertencia: activo ? Colors.red[800] : Colors.teal[800],
          colorFondoAdvertencia: activo ? Colors.red[50] : Colors.teal[50],
          colorBotonConfirmar: activo ? Colors.red[500] : Colors.teal[700],
          textoConfirmar: activo ? 'Sí, Desactivar' : 'Sí, Activar',
          advertencia: activo
              ? 'El servicio no estará disponible temporalmente para nuevas citas y facturación clínica.'
              : 'El servicio estará disponible nuevamente para nuevas citas y facturación clínica.',
          contenido: _buildServicePreview(
            id: id,
            nombre: nombre,
            costo: costo,
            activo: activo,
          ),
          onConfirmar: () => _cambiarEstadoServicio(id, !activo),
        );
      },
    );
  }

  Widget _buildServicePreview({
    required String id,
    required String nombre,
    required String costo,
    required bool activo,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: activo ? Colors.blue[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.medical_services_outlined,
              size: 18,
              color: activo ? Colors.blue[700] : Colors.red[400],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                ),
                Text(
                  'Código: $id  •  Costo: $costo',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
