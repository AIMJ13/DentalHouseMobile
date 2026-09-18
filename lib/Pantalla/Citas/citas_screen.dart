import 'package:flutter/material.dart';
import '../Editar Cita/editar_cita_screen.dart';

class Cita {
  final String codigo;
  final String paciente;
  final String motivo;
  final String doctor;
  final String fechaHora;
  final String estado;

  Cita({
    required this.codigo,
    required this.paciente,
    required this.motivo,
    required this.doctor,
    required this.fechaHora,
    required this.estado,
  });
}

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  final List<Cita> _citas = [
    Cita(
      codigo: 'CIT-001',
      paciente: 'Miurell Raquel',
      motivo: 'Consulta general',
      doctor: 'Dra. Olinda Pérez',
      fechaHora: '06/06/2025 • 09:30 AM',
      estado: 'No asistió',
    ),
    Cita(
      codigo: 'CIT-002',
      paciente: 'Lester Palacio',
      motivo: 'Limpieza dental',
      doctor: 'Dr. Fabio Reyes',
      fechaHora: '01/06/2026 • 08:00 AM',
      estado: 'Cancelada',
    ),
    Cita(
      codigo: 'CIT-003',
      paciente: 'Roman Rosales',
      motivo: 'Ortodoncia',
      doctor: 'Dra. María González',
      fechaHora: '06/06/2025 • 10:00 AM',
      estado: 'Programada',
    ),
  ];

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'Programada':
        return Colors.blue;
      case 'Completada':
        return Colors.green;
      case 'Cancelada':
        return Colors.red;
      case 'No asistió':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DentalHouse'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agenda de Citas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Administra todas las citas registradas entre pacientes y doctores.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildBadge('Total', _citas.length.toString(), Colors.black87),
                _buildBadge(
                  'Programadas',
                  _citas.where((c) => c.estado == 'Programada').length.toString(),
                  Colors.blue,
                ),
                _buildBadge(
                  'Completadas',
                  _citas.where((c) => c.estado == 'Completada').length.toString(),
                  Colors.green,
                ),
                _buildBadge(
                  'Canceladas',
                  _citas.where((c) => c.estado == 'Cancelada').length.toString(),
                  Colors.red,
                ),
                _buildBadge(
                  'No asistió',
                  _citas.where((c) => c.estado == 'No asistió').length.toString(),
                  Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por paciente o motivo...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: 'Todos',
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Todos',
                        child: Text(
                          'Todos los doctores',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: 'Todos',
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Todos',
                        child: Text(
                          'Todos los estados',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'CITAS REGISTRADAS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _citas.length,
                itemBuilder: (context, index) {
                  final cita = _citas[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cita.codigo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _colorEstado(cita.estado)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  cita.estado,
                                  style: TextStyle(
                                    color: _colorEstado(cita.estado),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'PACIENTE',
                            style: TextStyle(fontSize: 10, color: Colors.black45),
                          ),
                          Text(
                            cita.paciente,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            cita.motivo,
                            style: const TextStyle(color: Colors.black54, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'DOCTOR: ${cita.doctor}',
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          Text(
                            cita.fechaHora,
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                                                            Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => EditarCitaDialog(cita: cita),
                                    );
                                  },
                                  child: const Text('Editar'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cita.estado == 'Cancelada'
                                        ? Colors.blue
                                        : Colors.red,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    cita.estado == 'Cancelada'
                                        ? 'Reagendar'
                                        : 'Cancelar',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBadge(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}