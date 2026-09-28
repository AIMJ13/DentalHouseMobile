import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/dental_logo.dart';
import '../../routes.dart';

class RecepcionEspecialidadesScreen extends StatefulWidget {
  const RecepcionEspecialidadesScreen({super.key});

  @override
  State<RecepcionEspecialidadesScreen> createState() => _RecepcionEspecialidadesScreenState();
}

class _RecepcionEspecialidadesScreenState extends State<RecepcionEspecialidadesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroSeleccionado = 'Todos';
  final List<String> _filtros = ['Todos', 'Activas', 'Inactivas'];

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, Routes.recepcionCitas);
      return;
    }
    if (index == 1) {
      Navigator.pushReplacementNamed(context, Routes.recepcionPacientes);
      return;
    }
    if (index == 2) {
      return;
    }
    if (index == 3) {
      Navigator.pushReplacementNamed(context, Routes.recepcionDoctores);
      return;
    }
    if (index == 4) {
      Navigator.pushReplacementNamed(context, Routes.recepcionServicios);
      return;
    }
  }

  List<Map<String, dynamic>> _obtenerEspecialidadesFiltradas() {
    final query = _searchController.text.toLowerCase().trim();
    List<Map<String, dynamic>> filtradas = [];
    for (var esp in listaEspecialidades) {
      if (_filtroSeleccionado == 'Activas' && esp['activo'] != true) continue;
      if (_filtroSeleccionado == 'Inactivas' && esp['activo'] != false) continue;

      final nombre = (esp['nombre'] as String).toLowerCase();
      final id = (esp['id'] as String).toLowerCase();
      final coincide = query.isEmpty || nombre.contains(query) || id.contains(query);
      if (!coincide) continue;
      filtradas.add(esp);
    }
    return filtradas;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int total = listaEspecialidades.length;
    int activas = 0;
    int inactivas = 0;
    for (var esp in listaEspecialidades) {
      if (esp['activo'] == true) {
        activas++;
      } else {
        inactivas++;
      }
    }

    final especialidadesFiltradas = _obtenerEspecialidadesFiltradas();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
                  child: const Text('R', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 6),
                Text('Recepcionista', style: TextStyle(fontSize: 12, color: Colors.blue[800], fontWeight: FontWeight.bold)),
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
                        'Consulta de áreas odontológicas de la clínica.',
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
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  hintText: 'Buscar especialidad por nombre o código...',
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricaItem(Colors.amber[700]!, 'Total:', ' $total'),
                  _buildSeparadorVertical(),
                  _buildMetricaItem(Colors.green[600]!, 'Activas:', ' $activas'),
                  _buildSeparadorVertical(),
                  _buildMetricaItem(Colors.red[600]!, 'Inactivas:', ' $inactivas'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CATÁLOGO DE ESPECIALIDADES',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[700], letterSpacing: 0.5),
                ),
                Text(
                  '${especialidadesFiltradas.length} mostradas',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (var esp in especialidadesFiltradas)
              _buildEspecialidadCard(
                id: esp['id'] as String,
                nombre: esp['nombre'] as String,
                descripcion: (esp['descripcion'] as String?) ?? '',
                activo: esp['activo'] as bool,
              ),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: 2,
          onTap: _onBottomNavTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Pacientes'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'Especialidad'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Doctor'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Servicios'),
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
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildEspecialidadCard({
    required String id,
    required String nombre,
    required String descripcion,
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
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(6)),
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
                child: Center(
                  child: Icon(
                    Icons.medical_services,
                    color: activo ? Colors.blue[700] : Colors.red[400],
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
                      nombre,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    if (descripcion.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(descripcion, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}