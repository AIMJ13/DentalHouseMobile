import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Data/models/sale_model.dart';
import '../../providers/sales_provider.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/dental_logo.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/user_badge.dart';
import 'venta_detalle_modal.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SalesProvider>().fetchSales();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFechaFiltro() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) {
      final dia = picked.day.toString().padLeft(2, '0');
      final mes = picked.month.toString().padLeft(2, '0');
      final anio = picked.year.toString();
      context.read<SalesProvider>().setFiltroFecha('$dia/$mes/$anio');
    }
  }

  void _filtrarHoy() {
    final now = DateTime.now();
    final dia = now.day.toString().padLeft(2, '0');
    final mes = now.month.toString().padLeft(2, '0');
    final anio = now.year.toString();
    context.read<SalesProvider>().setFiltroFecha('$dia/$mes/$anio');
  }

  void _limpiarFiltros() {
    _searchController.clear();
    context.read<SalesProvider>().clearFilters();
  }

  void _abrirDetalleVenta(SaleModel venta) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return VentaDetalleModal(sale: venta);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SalesProvider>();

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
      body: _buildBody(provider),
      bottomNavigationBar: const CustomBottomNav(
        currentIndex: 2,
      ),
    );
  }

  Widget _buildBody(SalesProvider provider) {
    if (provider.isLoading && provider.saleModels.isEmpty) {
      return const LoadingView(message: 'Cargando ventas...');
    }

    if (provider.errorMessage != null && provider.saleModels.isEmpty) {
      return ErrorView(
        message: provider.errorMessage!,
        onRetry: () => provider.fetchSales(),
      );
    }

    final filtradas = provider.filteredSales;

    return RefreshIndicator(
      onRefresh: () => provider.fetchSales(),
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
                onChanged: (val) => provider.setSearchQuery(val),
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
                              provider.filtroFecha ?? 'dd/mm/aaaa',
                              style: TextStyle(
                                fontSize: 13,
                                color: provider.filtroFecha != null ? Colors.black87 : Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (provider.filtroFecha != null)
                            InkWell(
                              onTap: () => provider.setFiltroFecha(null),
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
                    _buildMetricaItem(Colors.amber[700]!, 'Total:', ' ${provider.totalSales}'),
                    _buildSeparadorVertical(),
                    _buildMetricaItem(Colors.green[600]!, 'Hoy:', ' ${provider.hoyCount}'),
                    _buildSeparadorVertical(),
                    _buildMetricaItem(Colors.blue[600]!, 'General:', ' C\$${provider.totalRevenue.toStringAsFixed(0)}'),
                    _buildSeparadorVertical(),
                    _buildMetricaItem(Colors.purple[400]!, 'Prom:', ' C\$${provider.averageSale.toStringAsFixed(2)}'),
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

  Widget _buildVentaCard(SaleModel venta) {
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
                    venta.code,
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
                      venta.formattedDate,
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
                              venta.patientName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            venta.formattedTotal,
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
                              venta.doctorName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (venta.appointmentCode != null && venta.appointmentCode!.isNotEmpty) ...[
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
                                'Cita: ${venta.appointmentCode}',
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
