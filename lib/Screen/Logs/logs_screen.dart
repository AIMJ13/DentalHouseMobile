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
  final int _currentIndex = 4;

  void _onBottomNavTapped(int index) {
    if (index == 0) Navigator.pushReplacementNamed(context, Routes.home);
    if (index == 1) Navigator.pushReplacementNamed(context, Routes.servicios);
    if (index == 2) Navigator.pushReplacementNamed(context, Routes.ventas);
    if (index == 3) Navigator.pushReplacementNamed(context, Routes.citas);
    if (index == 4) mostrarMenuMas(context);
  }

  List<Map<String, dynamic>> _obtenerLogsFiltrados() {
    final query = _searchController.text.toLowerCase().trim();
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey[400]),
                  hintText: 'Buscar en registro de actividad...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
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
