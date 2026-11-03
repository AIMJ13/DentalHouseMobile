import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/doctor_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/log_provider.dart' show ViewStatus;
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/dental_logo.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
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
    final doctores = doctorProvider.doctors;
    final isLoading = doctorProvider.isLoading && doctorProvider.totalCount == 0;
    final isError = doctorProvider.viewStatus == ViewStatus.error && doctorProvider.totalCount == 0;

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
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _filtroSeleccionado = filtro;
                            });
                            context.read<DoctorProvider>().setFilter(filtro);
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    'DIRECTORIO DE MÉDICOS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '${doctores.length} mostrados',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: LoadingView(message: 'Cargando directorio de doctores...'),
                )
              else if (isError)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: ErrorView(
                    message: doctorProvider.errorMessage ?? 'Ocurrió un error al cargar doctores',
                    onRetry: doctorProvider.fetchDoctors,
                  ),
                )
              else if (doctores.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.person_off_outlined, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'No se encontraron doctores',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              else
                for (var doc in doctores)
                  _buildDoctorCard(doc, esAdmin),
            ],
          ),
        ),
      ),
      floatingActionButton: esAdmin
          ? FloatingActionButton(
              onPressed: () => _abrirModalDoctor(),
              backgroundColor: Colors.blue[700],
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: (rol == 'Recepcionista') ? 3 : 4,
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

  Widget _buildDoctorCard(DoctorModel doc, bool esAdmin) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: esAdmin
          ? () => _abrirModalDoctor(doctor: doc)
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
                    color: doc.isActive ? Colors.teal[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    doc.code,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: doc.isActive ? Colors.teal[700] : Colors.grey[700],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: doc.isActive ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: doc.isActive ? Colors.green[600] : Colors.red[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        doc.isActive ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: doc.isActive ? Colors.green[700] : Colors.red[700],
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
                    color: doc.isActive ? Colors.blue[50] : Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: doc.isActive ? Colors.blue[700] : Colors.red[700],
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.titleFullName,
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
                              doc.specialtyDisplay,
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
                            doc.phone ?? '',
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
        return DoctorModal(
          doctor: doctor,
          onGuardar: (nombre, apellido, telefono, especialidadId, activo) async {
            final provider = context.read<DoctorProvider>();
            bool exito;
            if (doctor != null) {
              exito = await provider.updateDoctor(
                id: doctor.id,
                firstName: nombre,
                lastName: apellido,
                phone: telefono,
                specialtyId: especialidadId,
                state: activo,
              );
            } else {
              exito = await provider.createDoctor(
                firstName: nombre,
                lastName: apellido,
                phone: telefono,
                specialtyId: especialidadId,
                state: activo,
              );
            }

            if (!mounted) return;
            if (exito) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    doctor != null
                        ? 'Doctor actualizado exitosamente'
                        : 'Doctor registrado exitosamente',
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
