const Map<String, dynamic> metricasRendimiento = {
  'ingresos': 'C\$ 874.00 mil',
  'ingresosMeta': 'Meta activa',
  'ventas': '53',
  'ventasSub': 'Operaciones',
  'servicios': '304',
  'serviciosSub': 'Atenciones',
  'promedio': 'C\$ 16.49 mil',
  'promedioSub': 'Ticket prom.',
};

const List<Map<String, dynamic>> doctoresTop = [
  {
    'nombre': 'María González',
    'monto': 'C\$ 60,000.00',
    'porcentaje': 0.85,
  },
];

const List<Map<String, dynamic>> serviciosTop = [
  {
    'nombre': 'Extracción Simple',
    'monto': 'C\$ 60,000.00',
    'porcentaje': 0.80,
  },
];

const List<Map<String, dynamic>> especialidadesTop = [
  {
    'nombre': 'Cirugía Bucal',
    'monto': 'C\$ 42,000.00',
    'porcentaje': 0.75,
  },
];

const List<Map<String, dynamic>> ingresosMensuales = [
  {
    'mes': 'Mayo (Actual)',
    'monto': 'C\$ 85,000.00',
    'porcentaje': 0.90,
  },
];

const List<Map<String, dynamic>> ultimasCitas = [
  {
    'paciente': 'Carlos Morales',
    'servicio': 'Limpieza Dental',
    'estado': 'Completada',
    'monto': 'C\$ 800.00',
  },
];

const Map<String, dynamic> metricasDoctores = {
  'total': '33',
  'activos': '9',
  'inactivos': '1',
  'especialidades': '3',
  'mostrados': '5 mostrados',
};

List<Map<String, dynamic>> listaDoctores = [
  {
    'id': 'DOC-001',
    'nombre': 'Dr. Fabio Reyes',
    'especialidad': 'Endodoncia',
    'telefono': '6745853',
    'activo': true,
  },
  {
    'id': 'DOC-004',
    'nombre': 'Dr. DoctorTest Prueba',
    'especialidad': 'Odontología',
    'telefono': '22223333',
    'activo': false,
  },
];

const Map<String, dynamic> metricasServicios = {
  'total': '6',
  'activos': '3',
  'inactivos': '3',
  'mostrados': '6 mostrados',
};

List<Map<String, dynamic>> listaServicios = [
  {
    'id': 'SRV-001',
    'nombre': 'Limpieza Dental',
    'costo': 'C\$ 400.00',
    'activo': true,
  },
  {
    'id': 'SRV-004',
    'nombre': 'Blanqueamiento',
    'costo': 'C\$ 100.00',
    'activo': false,
  },
];

const Map<String, dynamic> metricasEspecialidades = {
  'total': '3',
  'activas': '2',
  'inactivas': '1',
  'mostradas': '3 mostradas',
};

List<Map<String, dynamic>> listaEspecialidades = [
  {
    'id': 'ESP-001',
    'nombre': 'Endodoncia',
    'descripcion': 'Tratamiento de conductos y pulpa dental',
    'activo': true,
  },
  {
    'id': 'ESP-002',
    'nombre': 'Ortodoncia',
    'descripcion': 'Corrección de mordida y alineación dental',
    'activo': true,
  },
  {
    'id': 'ESP-003',
    'nombre': 'Periodoncia',
    'descripcion': 'Tratamiento de encías y soporte óseo',
    'activo': false,
  },
];