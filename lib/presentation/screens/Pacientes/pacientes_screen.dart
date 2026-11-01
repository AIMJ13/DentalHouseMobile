import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/patient_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/log_provider.dart' show ViewStatus;
import '../../providers/patient_provider.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/dental_logo.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/user_badge.dart';
import 'paciente_modal.dart';

class PacientesScreen extends StatefulWidget {
  const PacientesScreen({super.key});

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PatientProvider>().fetchPatients();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = context.watch<PatientProvider>();
    final rol = context.watch<AuthProvider>().currentRole;

    final total = patientProvider.totalCount;
    final activos = patientProvider.activeCount;
    final inactivos = patientProvider.inactiveCount;
    final pacientes = patientProvider.patients;
    final isLoading = patientProvider.isLoading && patientProvider.totalCount == 0;
    final isError = patientProvider.viewStatus == ViewStatus.error && patientProvider.totalCount == 0;

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
        onRefresh: patientProvider.fetchPatients,
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
                    patientProvider.setSearchTerm(val);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    hintText: 'Buscar paciente por nombre...',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                              patientProvider.clearSearch();
                            },
                          )
                        : null,
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
                    '${pacientes.length} mostrados',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: LoadingView(message: 'Cargando pacientes desde el servidor...'),
                )
              else if (isError)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: ErrorView(
                    message: patientProvider.errorMessage ?? 'Error al conectar con la API de pacientes',
                    onRetry: () => patientProvider.fetchPatients(),
                  ),
                )
              else if (pacientes.isEmpty)
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
                )
              else
                for (var pac in pacientes)
                  _buildPacienteCard(pac),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirModalPaciente(),
        backgroundColor: Colors.blue[700],
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: (rol == 'Recepcionista')
            ? 1
            : (rol == 'Doctor')
                ? 2
                : 4,
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

  Widget _buildBadgesHeader(String id, bool activo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBadgeId(id),
        StatusBadge(
          text: activo ? 'Activo' : 'Inactivo',
          type: activo ? StatusType.success : StatusType.danger,
        ),
      ],
    );
  }

  Widget _buildAvatarPaciente(bool activo) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: activo ? Colors.blue[50] : Colors.red[50],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.person_outline,
          color: activo ? Colors.blue[600] : Colors.red[400],
          size: 24,
        ),
      ),
    );
  }

  Widget _buildPacienteCard(PatientModel paciente) {
    final id = paciente.code;
    final nombreCompleto = paciente.fullName;
    final telefono = paciente.phone.isNotEmpty ? paciente.phone : 'Sin teléfono';
    final direccion = paciente.address.isNotEmpty ? paciente.address : 'Sin dirección';
    final fechaNacimiento = paciente.formattedBirthDate;
    final activo = paciente.isActive;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _abrirModalPaciente(paciente: paciente),
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
                        nombreCompleto,
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
          ],
        ),
      ),
    );
  }

  void _abrirModalPaciente({PatientModel? paciente}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return PacienteModal(
          paciente: paciente,
          onGuardar: (nombre, apellido, telefono, direccion, fechaNacimiento, activo) async {
            final provider = context.read<PatientProvider>();
            bool exito;
            if (paciente != null) {
              exito = await provider.updatePatient(
                id: paciente.id,
                firstName: nombre,
                lastName: apellido,
                phone: telefono,
                address: direccion,
                birthDate: fechaNacimiento,
                state: activo,
                
              );
            } else {
              exito = await provider.createPatient(
                firstName: nombre,
                lastName: apellido,
                phone: telefono,
                address: direccion,
                birthDate: fechaNacimiento,
                state: activo,
              );
            }

            if (!mounted) return;
            if (exito) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    paciente != null
                        ? 'Paciente actualizado exitosamente'
                        : 'Paciente registrado exitosamente',
                  ),
                  backgroundColor: Colors.green[700],
                ),
              );
            } else if (provider.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.errorMessage!),
                  backgroundColor: Colors.red[700],
                ),
              );
            }
          },
        );
      },
    );
  }
}
