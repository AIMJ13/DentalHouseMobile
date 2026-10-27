import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/log_provider.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/dental_logo.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/user_badge.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _filtrosExpandidos = false;

  final List<String> _modulos = [
    'Todos los módulos',
    'Autenticación',
    'Pacientes',
    'Citas',
    'Doctores',
    'Facturación',
    'Usuarios',
    'Servicios',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LogProvider>().fetchLogs();
    });
  }

  void _limpiarFiltros() {
    _searchController.clear();
    context.read<LogProvider>().clearFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logProvider = context.watch<LogProvider>();
    final logs = logProvider.logs;
    final totalRegistros = logProvider.totalRecords;
    final errorMessage = logProvider.errorMessage;

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
            _buildEncabezado(),
            const SizedBox(height: 16),
            _buildPanelFiltros(logProvider),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HISTORIAL DE AUDITORÍA',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalRegistros registros',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (logProvider.viewStatus == ViewStatus.loading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: LoadingView(message: 'Cargando registros de auditoría...'),
              )
            else if (logProvider.viewStatus == ViewStatus.error && logs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ErrorView(
                  message: errorMessage ?? 'Error al cargar registros de auditoría',
                  onRetry: () => logProvider.fetchLogs(),
                ),
              )
            else if (logs.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Text(
                  'No se encontraron registros de eventos.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }

  Widget _buildEncabezado() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.history_outlined, color: Colors.blue[700], size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Auditoría del Sistema',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Historial de eventos y cambios registrados en la clínica.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPanelFiltros(LogProvider logProvider) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _filtrosExpandidos = !_filtrosExpandidos),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.tune, size: 18, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    const Text('Filtros y Búsqueda', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      _filtrosExpandidos ? 'Ocultar' : 'Mostrar filtros',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue[700]),
                    ),
                    Icon(
                      _filtrosExpandidos ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_filtrosExpandidos) ...[
            const SizedBox(height: 14),
            _buildInputText(
              _searchController,
              'Buscar por usuario o descripción...',
              Icons.search,
              (val) => logProvider.setSearchTerm(val),
            ),
            const SizedBox(height: 12),
            Text('ESTADO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600])),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  _buildEstadoPill('Todos', null, logProvider),
                  _buildEstadoPill('Éxito', Colors.green, logProvider),
                  _buildEstadoPill('Error', Colors.red, logProvider),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildCampoDropdown(
              'MÓDULO',
              logProvider.selectedModule,
              _modulos,
              (val) {
                if (val != null) logProvider.setModule(val);
              },
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _limpiarFiltros,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Limpiar', style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => logProvider.fetchLogs(resetPage: true),
                  icon: const Icon(Icons.filter_alt, size: 16, color: Colors.white),
                  label: const Text('Aplicar', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputText(TextEditingController controller, String hint, IconData icon, ValueChanged<String> onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 18, color: Colors.grey[500]),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCampoDropdown(String titulo, String valor, List<String> opciones, ValueChanged<String?> onChanged) {
    final String valorValido = opciones.contains(valor) ? valor : opciones.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600])),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: valorValido,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, size: 18),
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              onChanged: onChanged,
              items: [for (var opc in opciones) DropdownMenuItem(value: opc, child: Text(opc, overflow: TextOverflow.ellipsis))],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEstadoPill(String label, Color? dotColor, LogProvider logProvider) {
    final bool seleccionado = logProvider.selectedStatus == label;

    return Expanded(
      child: InkWell(
        onTap: () => logProvider.setStatus(label),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: seleccionado ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: seleccionado ? Border.all(color: Colors.grey[300]!) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (dotColor != null) ...[
                Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
                  color: seleccionado ? (dotColor ?? Colors.blue[700]) : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
