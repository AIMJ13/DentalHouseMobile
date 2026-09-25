

const List<Map<String, String>> rendimientoDoctor = [
  {
    'etiqueta': 'Citas Totales',
    'valor': '6',
    'sufijo': 'prog.',
    'sub': 'Meta activa',
    'subTipo': 'neutral',
  },
  {
    'etiqueta': 'Finalizadas',
    'valor': '2',
    'sub': 'Atendidas',
    'subTipo': 'neutral',
  },
  {
    'etiqueta': 'En Espera',
    'valor': '3',
    'sub': 'Por atender',
    'subTipo': 'warning',
  },
  {
    'etiqueta': 'En Sillón Dental',
    'valor': '1',
    'sub': 'activo',
    'subTipo': 'success',
  },
];

const List<Map<String, String>> pacientesRecientesDoctor = [
  {
    'nombre': 'Juan Pérez',
    'detalle': 'Limpieza Dental',
    'tiempo': 'Hoy',
    'estado': 'Completado',
    'estadoTipo': 'success',
  },
  {
    'nombre': 'María Torres',
    'detalle': 'Ortodoncia',
    'tiempo': 'Ayer',
    'estado': 'En seguimiento',
    'estadoTipo': 'info',
  },
  {
    'nombre': 'Carlos Mora',
    'detalle': 'Endodoncia',
    'tiempo': 'Hace 2 días',
    'estado': 'Requiere cita',
    'estadoTipo': 'warning',
  },
];

const List<Map<String, String>> citasHoyDoctor = [
  {
    'nombre': 'Carlos Mora',
    'detalle': 'Endodoncia · Sesión 2',
    'hora': '11:30 AM',
    'subDetalle': 'Sillón 1',
    'estado': 'En Proceso',
    'estadoTipo': 'warning',
  },
  {
    'nombre': 'María Torres',
    'detalle': 'Revisión de Ortodoncia',
    'hora': '10:30 AM',
    'subDetalle': 'Programada',
    'estado': 'Confirmada',
    'estadoTipo': 'info',
  },
  {
    'nombre': 'Juan Pérez',
    'detalle': 'Limpieza Dental General',
    'hora': '09:00 AM',
    'subDetalle': 'Finalizada',
    'estado': 'Completada',
    'estadoTipo': 'success',
  },
];