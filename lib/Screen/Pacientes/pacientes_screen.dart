import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/confirm_dialog.dart';
import '../../Widget/custom_button.dart';
import '../../Widget/dental_logo.dart';
import '../../Widget/menu_mas_modal.dart';
import '../../Widget/user_badge.dart';
import '../../routes.dart';
import 'paciente_modal.dart';

class PacientesScreen extends StatefulWidget {
  const PacientesScreen({super.key});

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onBottomNavTapped(BuildContext context, int index) {
    final String rol = perfilUsuarioActual['rol'] as String? ?? 'Administrador';

    if (rol == 'Doctor') {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, Routes.home);
        return;
      }
      if (index == 1) {
        Navigator.pushReplacementNamed(context, Routes.citas);
        return;
      }
      if (index == 2) {
        return;
      }
      if (index == 3) {
        mostrarMenuMas(context);
        return;
      }
      return;
    }

    if (rol == 'Recepcionista') {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, Routes.home);
        return;
      }
      if (index == 1) {
        Navigator.pushReplacementNamed(context, Routes.citas);
        return;
      }
      if (index == 2) {
        return;
      }
      if (index == 3) {
        Navigator.pushReplacementNamed(context, Routes.servicios);
        return;
      }
      if (index == 4) {
        mostrarMenuMas(context);
        return;
      }
      return;
    }

    if (index == 0) {
      Navigator.pushReplacementNamed(context, Routes.home);
      return;
    }
    if (index == 1) {
      Navigator.pushReplacementNamed(context, Routes.servicios);
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

  List<BottomNavigationBarItem> _obtenerItemsNavegacion(String rol) {
    if (rol == 'Doctor') {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Resumen'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Citas'),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Pacientes'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
      ];
    }
    if (rol == 'Recepcionista') {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Resumen'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Citas'),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Pacientes'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Servicios'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
      ];
    }
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Resumen'),
      BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Servicios'),
      BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Ventas'),
      BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Citas'),
      BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más'),
    ];
  }

  List<Map<String, dynamic>> _obtenerPacientesFiltrados() {
    final query = _searchController.text.toLowerCase().trim();
    List<Map<String, dynamic>> filtrados = [];
    for (var pac in listaPacientes) {
      final nombreCompleto = '${pac['nombre']} ${pac['apellido']}'.toLowerCase();
      final id = (pac['id'] as String).toLowerCase();
      final telefono = (pac['telefono'] as String).toLowerCase();
      final coincide = query.isEmpty ||
          nombreCompleto.contains(query) ||
          id.contains(query) ||
          telefono.contains(query);
      if (!coincide) continue;
      filtrados.add(pac);
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
    final String rol = perfilUsuarioActual['rol'] as String? ?? 'Administrador';

    int navIndex = 4;
    if (rol == 'Doctor' || rol == 'Recepcionista') {
      navIndex = 2;
    }

    int total = listaPacientes.length;
    int activos = 0;
    int inactivos = 0;
    for (var pac in listaPacientes) {
      if (pac['activo'] == true) {
        activos++;
      } else {
        inactivos++;
      }
    }

    final pacientesFiltrados = _obtenerPacientesFiltrados();

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
                  child: Icon(Icons.people_alt_outlined, color: Colors.blue[700], size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gestión de Pacientes',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Administra la información clínica y de contacto de los pacientes.',
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
                  hintText: 'Buscar paciente por nombre...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
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
                  _buildMetricaItem(Colors.amber[700]!, 'Total:', ' $total'),
                  _buildSeparadorVertical(),
                  _buildMetricaItem(Colors.green[600]!, 'Activos:', ' $activos'),
                  _buildSeparadorVertical(),
                  _buildMetricaItem(Colors.red[600]!, 'Inactivos:', ' $inactivos'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DIRECTORIO DE PACIENTES',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${pacientesFiltrados.length} mostrados',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (pacientesFiltrados.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'No se encontraron pacientes',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            if (pacientesFiltrados.isNotEmpty)
              for (var pac in pacientesFiltrados)
                _buildPacienteCard(pac),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirModalPaciente(),
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
          currentIndex: navIndex,
          onTap: (index) => _onBottomNavTapped(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: _obtenerItemsNavegacion(rol),
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

  Widget _buildBadgeId(String id) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        id,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green[700]),
      ),
    );
  }

  Widget _buildBadgeEstado(bool activo) {
    return Container(
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
    );
  }

  Widget _buildBadgesHeader(String id, bool activo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBadgeId(id),
        _buildBadgeEstado(activo),
      ],
    );
  }

  Widget _buildAvatarPaciente(bool activo, {double tamano = 44, double iconoTamano = 24}) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        color: activo ? Colors.blue[50] : Colors.red[50],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.person_outline,
          color: activo ? Colors.blue[600] : Colors.red[400],
          size: iconoTamano,
        ),
      ),
    );
  }

  Widget _buildPacienteCard(Map<String, dynamic> paciente) {
    final id = paciente['id'] as String;
    final nombre = paciente['nombre'] as String;
    final apellido = paciente['apellido'] as String;
    final telefono = paciente['telefono'] as String;
    final direccion = paciente['direccion'] as String;
    final fechaNacimiento = paciente['fechaNacimiento'] as String;
    final activo = paciente['activo'] as bool;

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
          _buildBadgesHeader(id, activo),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatarPaciente(activo),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$nombre $apellido',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.phone_outlined, size: 13, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '$telefono   •   $direccion',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Nacimiento: $fechaNacimiento',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                  onPressed: () => _abrirModalPaciente(paciente: paciente),
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: activo ? 'Desactivar' : 'Activar',
                  onPressed: () => _mostrarDialogoEstado(paciente),
                  color: activo ? Colors.red[500] : Colors.teal[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _abrirModalPaciente({Map<String, dynamic>? paciente}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return PacienteModal(
          id: paciente?['id'] as String?,
          nombre: paciente?['nombre'] as String?,
          apellido: paciente?['apellido'] as String?,
          telefono: paciente?['telefono'] as String?,
          direccion: paciente?['direccion'] as String?,
          fechaNacimiento: paciente?['fechaNacimiento'] as String?,
          activo: (paciente?['activo'] as bool?) ?? true,
          onGuardar: (nombre, apellido, telefono, direccion, fechaNacimiento, activo) {
            setState(() {
              if (paciente != null) {
                final id = paciente['id'];
                for (var pac in listaPacientes) {
                  if (pac['id'] == id) {
                    pac['nombre'] = nombre;
                    pac['apellido'] = apellido;
                    pac['telefono'] = telefono;
                    pac['direccion'] = direccion;
                    pac['fechaNacimiento'] = fechaNacimiento;
                    pac['activo'] = activo;
                    break;
                  }
                }
              } else {
                final nuevoId = 'PAC-00${listaPacientes.length + 1}';
                listaPacientes.insert(0, {
                  'id': nuevoId,
                  'nombre': nombre,
                  'apellido': apellido,
                  'telefono': telefono,
                  'direccion': direccion,
                  'fechaNacimiento': fechaNacimiento,
                  'activo': activo,
                });
              }
            });
          },
        );
      },
    );
  }

  void _cambiarEstadoPaciente(String id, bool nuevoEstado) {
    setState(() {
      for (var pac in listaPacientes) {
        if (pac['id'] == id) {
          pac['activo'] = nuevoEstado;
          break;
        }
      }
    });
  }

  void _mostrarDialogoEstado(Map<String, dynamic> paciente) {
    final id = paciente['id'] as String;
    final nombre = paciente['nombre'] as String;
    final apellido = paciente['apellido'] as String;
    final activo = paciente['activo'] as bool;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return ConfirmDialog(
          titulo: activo ? '¿Desactivar Paciente?' : '¿Activar Paciente?',
          subtitulo: activo
              ? '¿Estás seguro de que deseas desactivar al paciente "$nombre $apellido" ($id)?'
              : '¿Estás seguro de que deseas activar al paciente "$nombre $apellido" ($id)?',
          icono: activo ? Icons.warning_amber_rounded : Icons.check_circle_outline,
          colorIcono: activo ? Colors.red[600] : Colors.teal[700],
          colorFondoIcono: activo ? Colors.red[50] : Colors.teal[50],
          colorAdvertencia: activo ? Colors.red[800] : Colors.teal[800],
          colorFondoAdvertencia: activo ? Colors.red[50] : Colors.teal[50],
          colorBotonConfirmar: activo ? Colors.red[500] : Colors.teal[700],
          textoConfirmar: activo ? 'Sí, Desactivar' : 'Sí, Activar',
          advertencia: activo
              ? 'El paciente no estará disponible temporalmente para nuevas citas y atención clínica.'
              : 'El paciente estará disponible nuevamente para nuevas citas y atención clínica.',
          contenido: _buildPacientePreview(paciente),
          onConfirmar: () => _cambiarEstadoPaciente(id, !activo),
        );
      },
    );
  }

  Widget _buildPacientePreview(Map<String, dynamic> paciente) {
    final id = paciente['id'] as String;
    final nombre = paciente['nombre'] as String;
    final apellido = paciente['apellido'] as String;
    final telefono = paciente['telefono'] as String;
    final direccion = paciente['direccion'] as String;
    final activo = paciente['activo'] as bool;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBadgesHeader(id, activo),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildAvatarPaciente(activo, tamano: 38, iconoTamano: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$nombre $apellido',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '$telefono • $direccion',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
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
