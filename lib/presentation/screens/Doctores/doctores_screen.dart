import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/dashboard_data.dart';
import '../../../data/models/doctor_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/doctor_provider.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/dental_logo.dart';
import '../../widgets/user_badge.dart';
import 'doctor_modal.dart';

class DoctoresScreen extends StatefulWidget {
  const DoctoresScreen({super.key});

  @override
  State<DoctoresScreen> createState() => _DoctoresScreenState();
}

class _DoctoresScreenState extends State<DoctoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroSeleccionado = 'Todos';
  final List<String> _filtros = ['Todos', 'Activos', 'Inactivos'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProvider>().fetchDoctors();
    });
  }

  List<Map<String, dynamic>> _obtenerDoctoresFiltrados() {
    final query = _searchController.text.toLowerCase().trim();
    List<Map<String, dynamic>> filtrados = [];
    for (var doc in listaDoctores) {
      final nombre = (doc['nombre'] as String).toLowerCase();
      final id = (doc['id'] as String).toLowerCase();
      final especialidad = (doc['especialidad'] as String).toLowerCase();
      final telefono = (doc['telefono'] as String).toLowerCase();
      final coincide = query.isEmpty ||
          nombre.contains(query) ||
          id.contains(query) ||
          especialidad.contains(query) ||
          telefono.contains(query);
      if (!coincide) continue;
      if (_filtroSeleccionado == 'Activos' && doc['activo'] != true) continue;
      if (_filtroSeleccionado == 'Inactivos' && doc['activo'] != false) continue;
      filtrados.add(doc);
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
    final doctorProvider = context.watch<DoctorProvider>();
    final authProvider = context.watch<AuthProvider>();
    final rol = authProvider.currentRole;
    final bool esAdmin = rol == 'Administrador';

    final total = doctorProvider.totalCount;
    final activos = doctorProvider.activeCount;
    final inactivos = doctorProvider.inactiveCount;
    final doctoresFiltrados = _obtenerDoctoresFiltrados();

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
        onRefresh: doctorProvider.fetchDoctors,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                    child: Icon(Icons.person_outline, color: Colors.blue[700], size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gestión de Doctores',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          esAdmin
                              ? 'Administra el personal médico registrado en la clínica.'
                              : 'Consulta del personal médico disponible en la clínica.',
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
                    context.read<DoctorProvider>().setSearchTerm(val);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    hintText: 'Buscar doctor por nombre, ID o teléfono...',
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
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _filtroSeleccionado = filtro;
                            });
                            context.read<DoctorProvider>().setFilter(filtro);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: _filtroSeleccionado == filtro ? Colors.blue[700] : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _filtroSeleccionado == filtro ? Colors.blue[700]! : Colors.grey[300]!,
                              ),
                            ),
                            child: Text(
                              filtro,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _filtroSeleccionado == filtro ? Colors.white : Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTarjetaMetrica(
                      titulo: 'Total Doctores',
                      valor: total.toString(),
                      icono: Icons.people_outline,
                      colorIcono: Colors.blue[700]!,
                      colorFondo: Colors.blue[50]!,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTarjetaMetrica(
                      titulo: 'Activos',
                      valor: activos.toString(),
                      icono: Icons.check_circle_outline,
                      colorIcono: Colors.green[700]!,
                      colorFondo: Colors.green[50]!,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTarjetaMetrica(
                      titulo: 'Inactivos',
                      valor: inactivos.toString(),
                      icono: Icons.cancel_outlined,
                      colorIcono: Colors.red[700]!,
                      colorFondo: Colors.red[50]!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lista de Doctores (${doctoresFiltrados.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (esAdmin)
                    TextButton.icon(
                      onPressed: () => _abrirModalDoctor(),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Nuevo Doctor'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              for (var doc in doctoresFiltrados) _buildTarjetaDoctor(doc, esAdmin),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }

  Widget _buildTarjetaMetrica({
    required String titulo,
    required String valor,
    required IconData icono,
    required Color colorIcono,
    required Color colorFondo,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorFondo,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icono, color: colorIcono, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaDoctor(Map<String, dynamic> doc, bool esAdmin) {
    final id = doc['id'] as String;
    final nombre = doc['nombre'] as String;
    final especialidad = doc['especialidad'] as String;
    final telefono = doc['telefono'] as String;
    final activo = doc['activo'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    id,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: activo ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
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
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: activo ? Colors.blue[50] : Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: activo ? Colors.blue[700] : Colors.red[700],
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              especialidad,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.phone_outlined,
                            size: 13,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            telefono,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _abrirModalDoctor({DoctorModel? doctor}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return DoctorModal(doctor: doctor);
      },
    );
  }
}
