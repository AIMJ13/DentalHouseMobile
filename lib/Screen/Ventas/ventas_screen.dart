import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/custom_bottom_nav.dart';
import '../../Widget/dental_logo.dart';
import '../../Widget/user_badge.dart';
import 'venta_detalle_modal.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _filtroFecha;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _obtenerVentasFiltradas() {
    final query = _searchController.text.toLowerCase().trim();

    return listaVentas.where((venta) {
      final paciente = (venta['paciente'] as String? ?? '').toLowerCase();
      final doctor = (venta['doctor'] as String? ?? '').toLowerCase();
      final cita = (venta['cita'] as String? ?? '').toLowerCase();
      final codigo = (venta['codigo'] as String? ?? venta['id'] as String? ?? '').toLowerCase();

      final coincideBusqueda = query.isEmpty ||
          paciente.contains(query) ||
          doctor.contains(query) ||
          cita.contains(query) ||
          codigo.contains(query);

      if (!coincideBusqueda) return false;

      if (_filtroFecha != null && _filtroFecha!.isNotEmpty) {
        if ((venta['fecha'] as String? ?? '') != _filtroFecha) return false;
      }

      return true;
    }).toList();
  }

  Map<String, String> _calcularMetricas() {
    final int total = listaVentas.length;

    final now = DateTime.now();
    final dia = now.day.toString().padLeft(2, '0');
    final mes = now.month.toString().padLeft(2, '0');
    final anio = now.year.toString();
    final hoyStr = '$dia/$mes/$anio';

    int hoyCount = 0;
    double sumaGeneral = 0.0;

    for (var v in listaVentas) {
      if ((v['fecha'] as String? ?? '') == hoyStr) {
        hoyCount++;
      }
      final double valor = (v['totalNumero'] as num?)?.toDouble() ?? 0.0;
      sumaGeneral += valor;
    }

    final double promedio = total > 0 ? (sumaGeneral / total) : 0.0;

    return {
      'total': '$total',
      'hoy': '$hoyCount',
      'general': 'C\$${sumaGeneral.toStringAsFixed(0)}',
      'promedio': 'C\$${promedio.toStringAsFixed(2)}',
    };
  }

  Future<void> _seleccionarFechaFiltro() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      final dia = picked.day.toString().padLeft(2, '0');
      final mes = picked.month.toString().padLeft(2, '0');
      final anio = picked.year.toString();
      setState(() => _filtroFecha = '$dia/$mes/$anio');
    }
  }

  void _filtrarHoy() {
    final now = DateTime.now();
    final dia = now.day.toString().padLeft(2, '0');
    final mes = now.month.toString().padLeft(2, '0');
    final anio = now.year.toString();
    setState(() => _filtroFecha = '$dia/$mes/$anio');
  }

  void _limpiarFiltros() {
    setState(() {
      _searchController.clear();
      _filtroFecha = null;
    });
  }

  void _abrirDetalleVenta(Map<String, dynamic> venta) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return VentaDetalleModal(venta: venta);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtradas = _obtenerVentasFiltradas();
    final metricas = _calcularMetricas();

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
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.blue[700],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registro de Ventas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Consulta de ventas registradas a partir de las citas y servicios.',
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
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  hintText: 'Buscar venta por paciente, doctor...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _seleccionarFechaFiltro,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 15,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _filtroFecha ?? 'dd/mm/aaaa',
                              style: TextStyle(
                                fontSize: 13,
                                color: _filtroFecha != null ? Colors.black87 : Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_filtroFecha != null)
                            InkWell(
                              onTap: () => setState(() => _filtroFecha = null),
                              child: const Icon(Icons.close, size: 14, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _filtrarHoy,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'Hoy',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _limpiarFiltros,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'Limpiar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildMetricaItem(Colors.amber[700]!, 'Total:', ' ${metricas['total']}'),
                    _buildSeparadorVertical(),
                    _buildMetricaItem(Colors.green[600]!, 'Hoy:', ' ${metricas['hoy']}'),
                    _buildSeparadorVertical(),
                    _buildMetricaItem(Colors.blue[600]!, 'General:', ' ${metricas['general']}'),
                    _buildSeparadorVertical(),
                    _buildMetricaItem(Colors.purple[400]!, 'Prom:', ' ${metricas['promedio']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HISTORIAL DE VENTAS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${filtradas.length} registradas',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (filtradas.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.receipt_outlined, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    const Text(
                      'No se encontraron ventas',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Intenta ajustar los filtros de búsqueda o fecha.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              for (var venta in filtradas)
                _buildVentaCard(venta),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(
        currentIndex: 2,
      ),
    );
  }

  Widget _buildSeparadorVertical() {
    return Container(
      height: 14,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
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

  Widget _buildVentaCard(Map<String, dynamic> venta) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _abrirDetalleVenta(venta),
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
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    venta['codigo'] ?? venta['id'] ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      venta['fecha'] ?? '',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.blue[700],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              venta['paciente'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            venta['total'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              venta['doctor'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (venta['cita'] != null && venta['cita'].toString().isNotEmpty) ...[
                            Text(
                              ' • ',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: Colors.teal[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Cita: ${venta['cita']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[700],
                                ),
                              ),
                            ),
                          ],
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
}
