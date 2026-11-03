import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/sales_provider.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/dental_logo.dart';
import '../../widgets/user_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SalesProvider>().fetchSales();
      }
    });
  }

  String _currency(double value) {
    return 'C\$ ${value.toStringAsFixed(2)}';
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    final text = value.toString();

    final parsed = DateTime.tryParse(text);
    if (parsed != null) return parsed;

    final parts = text.split(' ').first.split('/');

    if (parts.length != 3) return null;

    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (month == null || day == null || year == null) {
      return null;
    }

    return DateTime(year, month, day);
  }

  String _formatDate(dynamic value) {
    final date = _parseDate(value);

    if (date == null) return 'Fecha no disponible';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Widget _buildMetricaCard({
    required String titulo,
    required String valor,
    required String subtitulo,
    bool esBadge = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
            const SizedBox(height: 6),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            esBadge
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      subtitulo,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    subtitulo,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuadroDestacado({
    required String titulo,
    required String nombre,
    required String valor,
    required String subtitulo,
    required IconData icono,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    icono,
                    size: 14,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              nombre,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              valor,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                subtitulo,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUltimasVentas(List<Map<String, dynamic>> sales) {
    final ventasOrdenadas = List<Map<String, dynamic>>.from(sales);

    ventasOrdenadas.sort((a, b) {
      final fechaA = _parseDate(a['saleDate']);
      final fechaB = _parseDate(b['saleDate']);

      if (fechaA == null) return 1;
      if (fechaB == null) return -1;

      return fechaB.compareTo(fechaA);
    });

    final ultimasVentas = ventasOrdenadas.take(5).toList();

    if (ultimasVentas.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 36,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'No hay ventas registradas',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: ultimasVentas.map((venta) {
        final paciente =
            venta['patientName']?.toString() ?? 'Paciente sin nombre';

        final doctor =
            venta['doctorName']?.toString() ?? 'Doctor sin nombre';

        final monto = venta['totalAmount'] is num
            ? (venta['totalAmount'] as num).toDouble()
            : double.tryParse(
                  venta['totalAmount']?.toString() ?? '',
                ) ??
                0;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: Colors.blue[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paciente,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      doctor,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatDate(venta['saleDate']),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _currency(monto),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final salesProvider = context.watch<SalesProvider>();

    final nombreUsuario =
        auth.userName.isNotEmpty ? auth.userName : 'Usuario';

    final cargando = salesProvider.isLoading;
    final hayError = salesProvider.errorMessage != null;
    final ventas = salesProvider.sales;

    final doctor = salesProvider.topDoctor;
    final servicio = salesProvider.topService;

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Panel Principal',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Hoy',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Bienvenido de nuevo, $nombreUsuario. '
              'Aquí puedes visualizar los indicadores clave.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),

            if (hayError) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[700],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        salesProvider.errorMessage ??
                            'No se pudieron cargar las ventas.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<SalesProvider>().fetchSales();
                      },
                      icon: const Icon(Icons.refresh),
                      color: Colors.red[700],
                      tooltip: 'Reintentar',
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rendimiento',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Indicadores clave de la clínica',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.green[200]!,
                          ),
                        ),
                        child: Text(
                          cargando ? 'Cargando...' : 'Actualizado',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildMetricaCard(
                        titulo: 'Ingresos Totales',
                        valor: cargando
                            ? 'Cargando...'
                            : _currency(salesProvider.totalRevenue),
                        subtitulo: 'Ingresos registrados',
                        esBadge: true,
                      ),
                      const SizedBox(width: 12),
                      _buildMetricaCard(
                        titulo: 'Total Ventas',
                        valor: cargando
                            ? '...'
                            : '${salesProvider.totalSales}',
                        subtitulo: 'Operaciones registradas',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMetricaCard(
                        titulo: 'Servicios Registrados',
                        valor: cargando
                            ? '...'
                            : '${salesProvider.totalServicesSold}',
                        subtitulo: 'Registros de servicios',
                      ),
                      const SizedBox(width: 12),
                      _buildMetricaCard(
                        titulo: 'Promedio / Venta',
                        valor: cargando
                            ? 'Cargando...'
                            : _currency(salesProvider.averageSale),
                        subtitulo: 'Promedio por operación',
                        esBadge: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estadísticas y Destacados',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Resumen de doctores, servicios e ingresos',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.blue[200]!,
                          ),
                        ),
                        child: Text(
                          'Métricas',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildCuadroDestacado(
                        titulo: 'Doctor Destacado',
                        nombre: cargando
                            ? 'Cargando...'
                            : doctor?['name']?.toString() ?? 'Sin datos',
                        valor: cargando
                            ? '...'
                            : _currency(
                                (doctor?['amount'] as num?)?.toDouble() ?? 0,
                              ),
                        subtitulo: doctor == null
                            ? 'Sin información'
                            : '${((doctor['percentage'] as num?)?.toDouble() ?? 0).toStringAsFixed(1)}% de ingresos',
                        icono: Icons.person_outline,
                      ),
                      const SizedBox(width: 12),
                      _buildCuadroDestacado(
                        titulo: 'Servicio Top',
                        nombre: cargando
                            ? 'Cargando...'
                            : servicio?['name']?.toString() ?? 'Sin datos',
                        valor: cargando
                            ? '...'
                            : _currency(
                                (servicio?['amount'] as num?)?.toDouble() ?? 0,
                              ),
                        subtitulo: servicio == null
                            ? 'Sin información'
                            : '${servicio['quantity'] ?? 0} unidades vendidas',
                        icono: Icons.medical_services_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildCuadroDestacado(
                        titulo: 'Ingreso Mensual',
                        nombre: 'Mes actual',
                        valor: cargando
                            ? 'Cargando...'
                            : _currency(salesProvider.monthlyRevenue),
                        subtitulo: 'Ingresos del mes',
                        icono: Icons.calendar_today_outlined,
                      ),
                      const SizedBox(width: 12),
                      _buildCuadroDestacado(
                        titulo: 'Ventas Registradas',
                        nombre: 'Historial de ventas',
                        valor: cargando
                            ? '...'
                            : '${salesProvider.totalSales} ventas',
                        subtitulo: 'Total de operaciones',
                        icono: Icons.receipt_long_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
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
                      const Text(
                        'ÚLTIMAS VENTAS',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Actividad reciente',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (cargando)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    _buildUltimasVentas(ventas),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}
