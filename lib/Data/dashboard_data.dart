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

const Map<String, dynamic> metricasLogs = {
  'total': '142',
  'exito': '118',
  'avisos': '18',
  'error': '6',
  'mostrados': '5 mostrados',
};

List<Map<String, dynamic>> listaLogs = [
  {
    'id': 'LOG-104',
    'tipo': 'Información',
    'fecha': '23/06/2026 - 11:43 AM',
    'iniciales': 'LP',
    'usuario': 'Recepcionista Mizael',
    'modulo': 'Citas',
    'descripcion': 'Creación de nueva cita médica para paciente Lester Palacio (CIT-006) con Dr. Morales.',
    'estado': 'Éxito',
    'ip': '192.168.1.12',
    'accion': 'Creación',
    'esAlerta': false,
  },
  {
    'id': 'LOG-103',
    'tipo': 'Modificación',
    'fecha': '23/06/2026 - 10:15 AM',
    'iniciales': 'AD',
    'usuario': 'Administrador',
    'modulo': 'Servicios',
    'descripcion': 'Modificación de tarifa para el servicio "Limpieza Dental" (SRV-001) de C\$350 a C\$400.',
    'estado': 'Éxito',
    'ip': '192.168.1.10',
    'accion': 'Modificación',
    'esAlerta': false,
  },
  {
    'id': 'LOG-102',
    'tipo': 'Advertencia',
    'fecha': '23/06/2026 - 09:28 AM',
    'iniciales': 'SYS',
    'usuario': 'Sistema (Seguridad)',
    'modulo': 'Seguridad',
    'descripcion': 'Intento de inicio de sesión fallido con usuario admin_root desde la IP 192.168.1.45.',
    'estado': 'Error',
    'ip': '192.168.1.45',
    'accion': 'Advertencia',
    'esAlerta': true,
  },
  {
    'id': 'LOG-101',
    'tipo': 'Auditoría',
    'fecha': '22/06/2026 - 05:50 PM',
    'iniciales': 'FR',
    'usuario': 'Dr. Fabio Reyes (Doctor)',
    'modulo': 'Doctores',
    'descripcion': 'Desactivación de registro de doctor Dr. DoctorTest Prueba (DOC-004) en catálogo clínico.',
    'estado': 'Éxito',
    'ip': '192.168.1.15',
    'accion': 'Auditoría',
    'esAlerta': false,
  },
  {
    'id': 'LOG-100',
    'tipo': 'Información',
    'fecha': '22/06/2026 - 04:12 PM',
    'iniciales': 'AT',
    'usuario': 'Sistema (Automático)',
    'modulo': 'Ventas',
    'descripcion': 'Registro de venta VTA-052 por C\$25.00 emitida con éxito para Cobro de Consulta General.',
    'estado': 'Éxito',
    'ip': '127.0.0.1',
    'accion': 'Creación',
    'esAlerta': false,
  },
];

Map<String, dynamic> perfilUsuarioActual = {
  'id': 'USR-001',
  'nombre': 'Administrador',
  'usuario': 'admin',
  'rol': 'Administrador',
  'email': 'admin@dentalhouse.com',
  'telefono': '+505 8888-1111',
  'avatarLetra': 'A',
  'citasHoy': 4,
  'totalAtenciones': 128,
};

List<Map<String, dynamic>> listaUsuarios = [
  {
    'id': 'USR-001',
    'nombre': 'Administrador',
    'usuario': 'admin',
    'password': 'admin123',
    'rol': 'Administrador',
    'email': 'admin@dentalhouse.com',
    'telefono': '+505 8888-1111',
    'activo': true,
  },
  {
    'id': 'USR-002',
    'nombre': 'Dr. Fabio Reyes',
    'usuario': 'freyes',
    'password': 'doc123',
    'rol': 'Doctor',
    'email': 'f.reyes@dentalhouse.com',
    'telefono': '+505 6745-8532',
    'activo': true,
  },
  {
    'id': 'USR-003',
    'nombre': 'Recepcionista Mizael',
    'usuario': 'mizael.recepcion',
    'password': 'recep123',
    'rol': 'Recepcionista',
    'email': 'm.recepcion@dentalhouse.com',
    'telefono': '+505 8765-4321',
    'activo': true,
  },
  {
    'id': 'USR-004',
    'nombre': 'Dra. María González',
    'usuario': 'mgonzalez',
    'password': 'doc123',
    'rol': 'Doctor',
    'email': 'm.gonzalez@dentalhouse.com',
    'telefono': '+505 8432-1122',
    'activo': false,
  },
  {
    'id': 'USR-005',
    'nombre': 'Asistente Laura',
    'usuario': 'laura.asistente',
    'password': 'recep123',
    'rol': 'Recepcionista',
    'email': 'l.asistente@dentalhouse.com',
    'telefono': '+505 8123-4567',
    'activo': false,
  },
];