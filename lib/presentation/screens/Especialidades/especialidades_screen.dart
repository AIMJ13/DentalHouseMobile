import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/specialty_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/specialty_provider.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/dental_logo.dart';
import '../../widgets/user_badge.dart';
import 'especialidad_modal.dart';

class EspecialidadesScreen extends StatefulWidget {
  const EspecialidadesScreen({super.key});

  @override
  State<EspecialidadesScreen> createState() => _EspecialidadesScreenState();
}

class _EspecialidadesScreenState extends State<EspecialidadesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filtros = ['Todos', 'Activas', 'Inactivas'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SpecialtyProvider>().fetchSpecialties();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _guardarEspecialidad({
    required int? id,
    required String nombre,
    required bool activo,
    required bool estadoAnterior,
  }) async {
    final provider = context.read<SpecialtyProvider>();

    if (id != null) {
      await provider.updateSpecialty(
        id: id,
        specialtyName: nombre,
        state: activo,
        previousState: estadoAnterior,
      );
    } else {
      await provider.createSpecialty(
        specialtyName: nombre,
        state: activo,
      );
    }
  }

  void _abrirModalEspecialidad({SpecialtyModel? especialidad}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return EspecialidadModal(
          id: especialidad?.specialtyId,
          nombre: especialidad?.specialtyName,
          activo: especialidad?.state ?? true,
          onGuardar: (nuevoNombre, nuevoActivo) async {
            await _guardarEspecialidad(
              id: especialidad?.specialtyId,
              nombre: nuevoNombre,
              activo: nuevoActivo,
              estadoAnterior: especialidad?.state ?? true,
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
    final specialtyProvider = context.watch<SpecialtyProvider>();
    final especialidades = specialtyProvider.specialties;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: const DentalLogo(),
        actions: const [
          UserBadge(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: specialtyProvider.fetchSpecialties,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEncabezado(esAdmin),
              const SizedBox(height: 16),
              _buildBuscador(specialtyProvider),
              const SizedBox(height: 12),
              _buildFiltros(specialtyProvider),
              const SizedBox(height: 16),
              _buildMetricas(specialtyProvider),
              const SizedBox(height: 16),
              _buildTituloCatalogo(especialidades.length),
              const SizedBox(height: 12),
              if (specialtyProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (specialtyProvider.errorMessage != null)
                _buildError(specialtyProvider.errorMessage!, specialtyProvider)
              else if (especialidades.isEmpty)
                _buildSinResultados()
              else
                for (final esp in especialidades)
                  _buildEspecialidadCard(
                    especialidad: esp,
                    esAdmin: esAdmin,
                  ),
            ],
          ),
        ),
      ),
      floatingActionButton: esAdmin
          ? FloatingActionButton(
              onPressed: specialtyProvider.isLoading
                  ? null
                  : () => _abrirModalEspecialidad(),
              backgroundColor: Colors.blue[700],
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: rol == 'Recepcionista' ? 2 : 4,
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
          child: Icon(Icons.bookmark_outline, color: Colors.blue[700], size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Especialidades Clínicas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 2),
              Text(
                esAdmin
                    ? 'Gestión de áreas odontológicas especializadas.'
                    : 'Consulta de áreas odontológicas de la clínica.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBuscador(SpecialtyProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: provider.setSearchTerm,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          hintText: 'Buscar especialidad por nombre o código...',
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    provider.setSearchTerm('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFiltros(SpecialtyProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filtro in _filtros)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () => provider.setFilter(filtro),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: provider.selectedFilter == filtro ? Colors.blue[700] : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: provider.selectedFilter == filtro ? Colors.blue[700]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    filtro,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: provider.selectedFilter == filtro ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetricas(SpecialtyProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMetricaItem(Colors.amber[700]!, 'Total:', ' ${provider.totalSpecialties}'),
          _buildSeparadorVertical(),
          _buildMetricaItem(Colors.green[600]!, 'Activas:', ' ${provider.totalActive}'),
          _buildSeparadorVertical(),
          _buildMetricaItem(Colors.red[600]!, 'Inactivas:', ' ${provider.totalInactive}'),
        ],
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

  Widget _buildTituloCatalogo(int totalMostradas) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'CATÁLOGO DE ESPECIALIDADES',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            letterSpacing: 0.5,
          ),
        ),
        Text(
          '$totalMostradas mostradas',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildEspecialidadCard({
    required SpecialtyModel especialidad,
    required bool esAdmin,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: esAdmin
          ? () => _abrirModalEspecialidad(especialidad: especialidad)
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    especialidad.code,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue[700]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: especialidad.state ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: especialidad.state ? Colors.green[600] : Colors.red[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        especialidad.state ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: especialidad.state ? Colors.green[700] : Colors.red[700],
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
                    color: especialidad.state ? Colors.blue[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: especialidad.state ? Colors.blue[100]! : Colors.red[100]!),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.medical_services,
                      color: especialidad.state ? Colors.blue[700] : Colors.red[400],
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        especialidad.specialtyName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                if (esAdmin)
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 20,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String mensaje, SpecialtyProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 36),
          const SizedBox(height: 8),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.red[800]),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: provider.fetchSpecialties,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSinResultados() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No se encontraron especialidades',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Text(
            'Probá ajustando el término de búsqueda o el filtro.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
