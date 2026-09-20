import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/dental_logo.dart';
import '../../Widget/menu_mas_modal.dart';
import '../../routes.dart';
import 'log_detalle_modal.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();

  String _estadoFiltro = 'Todos';
  String _moduloFiltro = 'Todos los módulos';
  String _accionFiltro = 'Todas las acciones';
  bool _filtrosExpandidos = false;
  final int _currentIndex = 4;

  final List<String> _modulos = ['Todos los módulos', 'Citas', 'Servicios', 'Seguridad', 'Doctores', 'Ventas'];
  final List<String> _acciones = ['Todas las acciones', 'Información', 'Modificación', 'Advertencia', 'Auditoría'];

  void _onBottomNavTapped(int index) {
    if (index == 0) Navigator.pushReplacementNamed(context, Routes.home);
    if (index == 1) Navigator.pushReplacementNamed(context, Routes.servicios);
    if (index == 2) Navigator.pushReplacementNamed(context, Routes.ventas);
    if (index == 3) Navigator.pushReplacementNamed(context, Routes.citas);
    if (index == 4) mostrarMenuMas(context);
  }

  void _limpiarFiltros() {
    setState(() {
      _searchController.clear();
      _usuarioController.clear();
      _estadoFiltro = 'Todos';
      _moduloFiltro = 'Todos los módulos';
      _accionFiltro = 'Todas las acciones';
    });
  }

  List<Map<String, dynamic>> _obtenerLogsFiltrados() {
    final query = _searchController.text.toLowerCase().trim();
    final usuarioQuery = _usuarioController.text.toLowerCase().trim();
    List<Map<String, dynamic>> filtrados = [];

    for (var log in listaLogs) {
      final desc = (log['descripcion'] as String).toLowerCase();
      final usr = (log['usuario'] as String).toLowerCase();
      final id = (log['id'] as String).toLowerCase();
      final ip = (log['ip'] as String).toLowerCase();
      final tipo = (log['tipo'] as String).toLowerCase();

      final coincide = query.isEmpty ||
          desc.contains(query) ||
          usr.contains(query) ||
          id.contains(query) ||
          ip.contains(query) ||
          tipo.contains(query);

      if (!coincide) continue;
      if (usuarioQuery.isNotEmpty && !usr.contains(usuarioQuery)) continue;
      if (_estadoFiltro == 'Éxito' && log['estado'] != 'Éxito') continue;
      if (_estadoFiltro == 'Error' && log['estado'] != 'Error') continue;
      if (_moduloFiltro != 'Todos los módulos' && log['modulo'] != _moduloFiltro) continue;
      if (_accionFiltro != 'Todas las acciones' && log['tipo'] != _accionFiltro) continue;

      filtrados.add(log);
    }
    return filtrados;
  }

  void _abrirModalDetalle(Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (dialogContext) => LogDetalleModal(log: log),
    );
  }

  MaterialColor _colorEtiqueta(String valor) {
    if (valor == 'Modificación') return Colors.amber;
    if (valor == 'Advertencia' || valor == 'Seguridad' || valor == 'SYS') return Colors.red;
    if (valor == 'Auditoría' || valor == 'Doctores') return Colors.purple;
    if (valor == 'Ventas' || valor == 'AT' || valor == 'Información') return Colors.teal;
    return Colors.blue;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _usuarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logsFiltrados = _obtenerLogsFiltrados();

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
            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                CircleAvatar(radius: 10, backgroundColor: Colors.blue[700], child: const Text('A', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                const SizedBox(width: 6),
                Text('Administrador', style: TextStyle(fontSize: 12, color: Colors.blue[800], fontWeight: FontWeight.bold)),
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
            _buildEncabezado(),
            const SizedBox(height: 16),
            _buildPanelFiltros(),
            const SizedBox(height: 16),
            _buildBarraMetricas(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('HISTORIAL DE EVENTOS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
                  child: Text('${logsFiltrados.length} mostrados', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue[700])),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (var log in logsFiltrados) _buildLogCard(log),
            const SizedBox(height: 12),
            _buildPaginacion(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildEncabezado() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.terminal, color: Colors.blue[700], size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Registro de Actividad', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 2),
              Text('Historial de eventos, auditoría de accesos y cambios en la clínica.', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPanelFiltros() {
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
                    Text(_filtrosExpandidos ? 'Ocultar' : 'Mostrar filtros', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue[700])),
                    Icon(_filtrosExpandidos ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.blue[700], size: 20),
                  ],
                ),
              ],
            ),
          ),
          if (_filtrosExpandidos) ...[
            const SizedBox(height: 14),
            _buildInputText(_searchController, 'Buscar por descripción, usuario, IP o acción...', Icons.search),
            const SizedBox(height: 12),
            Text('ESTADO (ISSUCCESS)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600])),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  _buildEstadoPill('Todos', null),
                  _buildEstadoPill('Éxito', Colors.green[600]),
                  _buildEstadoPill('Error', Colors.red[600]),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildCampoFecha('DESDE (FECHA)', '06/22/2026')),
                const SizedBox(width: 10),
                Expanded(child: _buildCampoFecha('HASTA (FECHA)', '06/23/2026')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildCampoDropdown('MÓDULO', _moduloFiltro, _modulos, (val) {
                  if (val != null) setState(() => _moduloFiltro = val);
                })),
                const SizedBox(width: 10),
                Expanded(child: _buildCampoDropdown('TIPO DE ACCIÓN', _accionFiltro, _acciones, (val) {
                  if (val != null) setState(() => _accionFiltro = val);
                })),
              ],
            ),
            const SizedBox(height: 12),
            Text('USUARIO (USERNAME)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600])),
            const SizedBox(height: 6),
            _buildInputText(_usuarioController, 'Ej. admin, Dr. Morales...', Icons.person_outline),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _limpiarFiltros,
                  style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey[300]!), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: Text('Limpiar', style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.filter_alt, size: 16, color: Colors.white),
                  label: const Text('Aplicar Filtros', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputText(TextEditingController controller, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[300]!)),
      child: TextField(
        controller: controller,
        onChanged: (_) => setState(() {}),
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

  Widget _buildBarraMetricas() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMetrica(Colors.amber[700]!, 'Total:', '${metricasLogs['total']}'),
          _buildMetrica(Colors.green[600]!, 'Éxito:', '${metricasLogs['exito']}'),
          _buildMetrica(Colors.orange[800]!, 'Avisos:', '${metricasLogs['avisos']}'),
          _buildMetrica(Colors.red[600]!, 'Error:', '${metricasLogs['error']}'),
        ],
      ),
    );
  }

  Widget _buildMetrica(Color punto, String etiqueta, String valor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: punto, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(etiqueta, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        const SizedBox(width: 2),
        Text(valor, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildChip(String texto, Color fondo, Color textoColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(6)),
      child: Text(texto, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textoColor)),
    );
  }

  Widget _buildLogCard(Map<String, dynamic> log) {
    final tipo = log['tipo'] as String;
    final modulo = log['modulo'] as String;
    final pTipo = _colorEtiqueta(tipo);
    final pMod = _colorEtiqueta(modulo);
    final pAva = _colorEtiqueta(log['iniciales'] as String);
    final bool esAlerta = log['esAlerta'] == true;

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
            children: [
              _buildChip(log['id'] as String, Colors.grey[100]!, Colors.grey[800]!),
              const SizedBox(width: 8),
              _buildChip(tipo, pTipo[50]!, pTipo == Colors.amber ? Colors.amber[800]! : pTipo[700]!),
              const Spacer(),
              Text(log['fecha'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: pAva[50],
                child: Text(log['iniciales'] as String, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: pAva[700])),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(log['usuario'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87), overflow: TextOverflow.ellipsis),
              ),
              _buildChip('Módulo: $modulo', pMod[50]!, pMod[700]!),
            ],
          ),
          const SizedBox(height: 10),
          if (esAlerta)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red[100]!)),
              child: Text(log['descripcion'] as String, style: TextStyle(fontSize: 12, color: Colors.red[700], height: 1.3)),
            )
          else
            Text(log['descripcion'] as String, style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.3)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => _abrirModalDetalle(log),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility_outlined, size: 14, color: Colors.blue[700]),
                    const SizedBox(width: 4),
                    Text('Ver Detalle', style: TextStyle(fontSize: 11, color: Colors.blue[700], fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoPill(String label, Color? dotColor) {
    final bool seleccionado = _estadoFiltro == label;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _estadoFiltro = label),
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

  Widget _buildCampoFecha(String titulo, String fecha) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600])),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(fecha, style: const TextStyle(fontSize: 12, color: Colors.black87)),
              Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[500]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCampoDropdown(String titulo, String valor, List<String> opciones, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600])),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: valor,
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

  Widget _buildPaginacion() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Por pág: ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey[300]!)),
                    child: const Text('10', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Text('Página 1 de 15 (142 registros)', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey[300]!), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: Text('< Anterior', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.blue[700]!), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: Text('Siguiente >', style: TextStyle(fontSize: 12, color: Colors.blue[700], fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Theme(
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
    );
  }
}
