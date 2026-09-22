import 'package:flutter/material.dart';
import '../../Data/dashboard_data.dart';
import '../../Widget/dental_logo.dart';
import '../../Widget/menu_mas_modal.dart';
import '../../routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      setState(() {
        _currentIndex = 0;
      });
      return;
    }
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
            Text(titulo, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            const SizedBox(height: 6),
            Text(valor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            esBadge
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      subtitulo,
                      style: TextStyle(fontSize: 10, color: Colors.green[700], fontWeight: FontWeight.w600),
                    ),
                  )
                : Text(subtitulo, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  Widget _buildBarraItem({
    required String label,
    required String valor,
    required double porcentaje,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text(valor, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue[700])),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: porcentaje,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionEstadistica({
    required String titulo,
    required String etiqueta,
    required List<Widget> children,
  }) {
    return Container(
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
              Text(titulo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text(etiqueta, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.blue[700],
                  child: const Text(
                    'A',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Administrador',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              'Bienvenido de nuevo, Administrador. Aquí puedes visualizar los indicadores clave.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
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
                          const Text('Rendimiento', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          Text('Indicadores clave de la clínica', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Text(
                          '• Publicado',
                          style: TextStyle(fontSize: 11, color: Colors.green[700], fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildMetricaCard(
                        titulo: 'Ingresos Totales',
                        valor: metricasRendimiento['ingresos'],
                        subtitulo: metricasRendimiento['ingresosMeta'],
                        esBadge: true,
                      ),
                      const SizedBox(width: 12),
                      _buildMetricaCard(
                        titulo: 'Total Ventas',
                        valor: metricasRendimiento['ventas'],
                        subtitulo: metricasRendimiento['ventasSub'],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMetricaCard(
                        titulo: 'Servicios Vendidos',
                        valor: metricasRendimiento['servicios'],
                        subtitulo: metricasRendimiento['serviciosSub'],
                      ),
                      const SizedBox(width: 12),
                      _buildMetricaCard(
                        titulo: 'Promedio / Venta',
                        valor: metricasRendimiento['promedio'],
                        subtitulo: metricasRendimiento['promedioSub'],
                        esBadge: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildSeccionEstadistica(
              titulo: 'INGRESOS POR DOCTOR',
              etiqueta: 'Córdobas (C\$)',
              children: [
                for (var doc in doctoresTop)
                  _buildBarraItem(
                    label: doc['nombre'],
                    valor: doc['monto'],
                    porcentaje: doc['porcentaje'],
                  ),
              ],
            ),
            _buildSeccionEstadistica(
              titulo: 'SERVICIOS MÁS VENDIDOS',
              etiqueta: 'Cant. unidades',
              children: [
                for (var serv in serviciosTop)
                  _buildBarraItem(
                    label: serv['nombre'],
                    valor: serv['monto'],
                    porcentaje: serv['porcentaje'],
                  ),
              ],
            ),
            _buildSeccionEstadistica(
              titulo: 'ESPECIALIDADES MÁS RENTABLES',
              etiqueta: 'Facturación (C\$)',
              children: [
                for (var esp in especialidadesTop)
                  _buildBarraItem(
                    label: esp['nombre'],
                    valor: esp['monto'],
                    porcentaje: esp['porcentaje'],
                  ),
              ],
            ),
            _buildSeccionEstadistica(
              titulo: 'INGRESOS MENSUALES',
              etiqueta: 'Año actual (C\$)',
              children: [
                for (var mes in ingresosMensuales)
                  _buildBarraItem(
                    label: mes['mes'],
                    valor: mes['monto'],
                    porcentaje: mes['porcentaje'],
                  ),
              ],
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
                        'ÚLTIMAS CITAS ATENDIDAS',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text('Actividad reciente', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                  const SizedBox(height: 12),
                  for (var cita in ultimasCitas)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    cita['paciente'],
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      cita['estado'],
                                      style: TextStyle(fontSize: 10, color: Colors.green[700], fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cita['servicio'],
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Text(
                            cita['monto'],
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue[700]),
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
      ),
    );
  }
}
