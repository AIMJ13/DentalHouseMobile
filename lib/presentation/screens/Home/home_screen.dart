
import 'package:flutter/material.dart';

import '../../../data/dashboard_data.dart';
import '../../../core/di/service_locator.dart';
import '../../../services/sales_service.dart';
import '../../widgets/dental_logo.dart';
import '../../widgets/menu_mas_modal.dart';
import '../../widgets/user_badge.dart';
import '../../../routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0;

  bool _cargandoVentas = true;
  String? _errorVentas;

  double _ingresos = 0;
  int _totalVentas = 0;
  int _serviciosVendidos = 0;
  double _promedioVenta = 0;

  @override
  void initState() {
    super.initState();
    _cargarVentas();
  }

  Future<void> _cargarVentas() async {
    try {
      final sales = await sl<SalesService>().getAllSales();

      double ingresos = 0;
      int servicios = 0;

      for (final venta in sales) {
        ingresos +=
            (num.tryParse('${venta['totalAmount']}') ?? 0).toDouble();

        final detalles = venta['details'];

        if (detalles is List) {
          for (final detalle in detalles) {
            if (detalle is Map) {
              servicios +=
                  (num.tryParse('${detalle['quantity']}') ?? 0).toInt();
            }
          }
        }
      }

      if (!mounted) return;

      setState(() {
        _ingresos = ingresos;
        _totalVentas = sales.length;
        _serviciosVendidos = servicios;
        _promedioVenta =
            sales.isEmpty ? 0 : ingresos / sales.length;

        _cargandoVentas = false;
        _errorVentas = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargandoVentas = false;
        _errorVentas = 'No se pudieron cargar las ventas.';
      });
    }
  }

 String _formatearMoneda(double valor) {
  return 'C\$ ${valor.toStringAsFixed(2)}';
}

  void _onBottomNavTapped(int index) {
    final String rol =
        perfilUsuarioActual['rol'] as String? ?? 'Administrador';

    if (rol == 'Doctor') {
      if (index == 0) {
        Navigator.pushNamed(context, Routes.doctorHome);
        return;
      }
      if (index == 1) {
        Navigator.pushNamed(context, Routes.citas);
        return;
      }
      if (index == 2) {
        Navigator.pushNamed(context, Routes.pacientes);
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
        Navigator.pushNamed(context, Routes.citas);
        return;
      }
      if (index == 1) {
        Navigator.pushNamed(context, Routes.pacientes);
        return;
      }
      if (index == 2) {
        Navigator.pushNamed(context, Routes.especialidades);
        return;
      }
      if (index == 3) {
        Navigator.pushNamed(context, Routes.doctores);
        return;
      }
      if (index == 4) {
        Navigator.pushNamed(context, Routes.servicios);
        return;
      }
      return;
    }

    if (index == 0) return;

    if (index == 1) {
      Navigator.pushNamed(context, Routes.servicios);
      return;
    }

    if (index == 2) {
      Navigator.pushNamed(context, Routes.ventas);
      return;
    }

    if (index == 3) {
      Navigator.pushNamed(context, Routes.citas);
      return;
    }

    if (index == 4) {
      mostrarMenuMas(context);
    }
  }

  List<BottomNavigationBarItem> _obtenerItemsNavegacion(String rol) {
    if (rol == 'Doctor') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          label: 'Más',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Citas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Pacientes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: 'Más',
        ),
      ];
    }

    if (rol == 'Recepcionista') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Citas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Pacientes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline),
          label: 'Especialidades',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Doctores',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Servicios',
        ),
      ];
    }

    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart_outlined),
        label: 'Resumen',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        label: 'Servicios',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long_outlined),
        label: 'Ventas',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month_outlined),
        label: 'Citas',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.more_horiz),
        label: 'Más',
      ),
    ];
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
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : Text(
                    subtitulo,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                    overflow: TextOverflow.ellipsis,
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
              overflow: TextOverflow.ellipsis,
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

  @override
  Widget build(BuildContext context) {
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
                  'Panel principal',
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
              'Bienvenido de nuevo, ${perfilUsuarioActual['nombre'] ?? 'Usuario'}. Aquí puedes visualizar los indicadores clave.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Indicadores de rendimiento
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
                          color: _errorVentas == null
                              ? Colors.green[50]
                              : Colors.orange[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _errorVentas == null
                                ? Colors.green[200]!
                                : Colors.orange[200]!,
                          ),
                        ),
                        child: Text(
                          _cargandoVentas
                              ? 'Cargando'
                              : _errorVentas != null
                                  ? 'Sin conexión'
                                  : 'API conectada',
                          style: TextStyle(
                            fontSize: 11,
                            color: _errorVentas == null
                                ? Colors.green[700]
                                : Colors.orange[700],
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
                        titulo: 'Ingresos totales',
                        valor: _cargandoVentas
                            ? 'Cargando...'
                            : _errorVentas != null
                                ? 'No disponible'
                                : _formatearMoneda(_ingresos),
                        subtitulo: _cargandoVentas
                            ? 'Consultando API'
                            : _errorVentas != null
                                ? 'Error de conexión'
                                : 'Ingresos registrados',
                        esBadge: true,
                      ),
                      const SizedBox(width: 12),
                      _buildMetricaCard(
                        titulo: 'Total ventas',
                        valor: _cargandoVentas
                            ? '...'
                            : _errorVentas != null
                                ? '--'
                                : '$_totalVentas',
                        subtitulo: _cargandoVentas
                            ? 'Consultando API'
                            : _errorVentas != null
                                ? 'No disponible'
                                : 'Ventas registradas',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMetricaCard(
                        titulo: 'Servicios vendidos',
                        valor: _cargandoVentas
                            ? '...'
                            : _errorVentas != null
                                ? '--'
                                : '$_serviciosVendidos',
                        subtitulo: _cargandoVentas
                            ? 'Consultando API'
                            : _errorVentas != null
                                ? 'No disponible'
                                : 'Unidades registradas',
                      ),
                      const SizedBox(width: 12),
                      _buildMetricaCard(
                        titulo: 'Promedio / venta',
                        valor: _cargandoVentas
                            ? 'Cargando...'
                            : _errorVentas != null
                                ? 'No disponible'
                                : _formatearMoneda(_promedioVenta),
                        subtitulo: _cargandoVentas
                            ? 'Consultando API'
                            : _errorVentas != null
                                ? 'No disponible'
                                : 'Promedio registrado',
                        esBadge: true,
                      ),
                    ],
                  ),
                  if (_errorVentas != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorVentas!,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 12,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _cargandoVentas = true;
                            _errorVentas = null;
                          });
                          _cargarVentas();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Estadísticas y destacados.
            // Estos apartados siguen usando los datos locales existentes.
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Estadísticas y destacados',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Resumen de especialidades, doctores y servicios',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue[200]!),
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
                        titulo: 'Doctor destacado',
                        nombre: doctoresTop.isNotEmpty
                            ? doctoresTop[0]['nombre'] as String
                            : 'Sin datos',
                        valor: doctoresTop.isNotEmpty
                            ? doctoresTop[0]['monto'] as String
                            : 'C\$ 0.00',
                        subtitulo: doctoresTop.isNotEmpty
                            ? '${((doctoresTop[0]['porcentaje'] as num? ?? 0.85) * 100).round()}% participación'
                            : '0%',
                        icono: Icons.person_outline,
                      ),
                      const SizedBox(width: 12),
                      _buildCuadroDestacado(
                        titulo: 'Servicio destacado',
                        nombre: serviciosTop.isNotEmpty
                            ? serviciosTop[0]['nombre'] as String
                            : 'Sin datos',
                        valor: serviciosTop.isNotEmpty
                            ? serviciosTop[0]['monto'] as String
                            : 'C\$ 0.00',
                        subtitulo: serviciosTop.isNotEmpty
                            ? '${((serviciosTop[0]['porcentaje'] as num? ?? 0.80) * 100).round()}% demanda'
                            : '0%',
                        icono: Icons.medical_services_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildCuadroDestacado(
                        titulo: 'Especialidad principal',
                        nombre: especialidadesTop.isNotEmpty
                            ? especialidadesTop[0]['nombre'] as String
                            : 'Sin datos',
                        valor: especialidadesTop.isNotEmpty
                            ? especialidadesTop[0]['monto'] as String
                            : 'C\$ 0.00',
                        subtitulo: especialidadesTop.isNotEmpty
                            ? '${((especialidadesTop[0]['porcentaje'] as num? ?? 0.75) * 100).round()}% facturación'
                            : '0%',
                        icono: Icons.bookmark_outline,
                      ),
                      const SizedBox(width: 12),
                      _buildCuadroDestacado(
                        titulo: 'Ingreso mensual',
                        nombre: ingresosMensuales.isNotEmpty
                            ? ingresosMensuales[0]['mes'] as String
                            : 'Sin datos',
                        valor: ingresosMensuales.isNotEmpty
                            ? ingresosMensuales[0]['monto'] as String
                            : 'C\$ 0.00',
                        subtitulo: ingresosMensuales.isNotEmpty
                            ? '${((ingresosMensuales[0]['porcentaje'] as num? ?? 0.90) * 100).round()}% meta'
                            : '0%',
                        icono: Icons.calendar_today_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Últimas citas: datos locales hasta integrar el endpoint de citas.
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
                      const Expanded(
                        child: Text(
                          'Últimas citas atendidas',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
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
                  for (final cita in ultimasCitas)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      cita['paciente'] as String,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green[50],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        cita['estado'] as String,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cita['servicio'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            cita['monto'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
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
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: _obtenerItemsNavegacion(
            perfilUsuarioActual['rol'] as String? ?? 'Administrador',
          ),
        ),
      ),
    );
  }
}
