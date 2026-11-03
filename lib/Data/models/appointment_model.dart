class AppointmentModel {
  final int id;
  final DateTime fecha;
  final String hora;
  final String motivo;
  final int pacienteId;
  final int doctorId;
  final String paciente;
  final String doctor;
  final String estado;

  const AppointmentModel({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.motivo,
    required this.pacienteId,
    required this.doctorId,
    required this.paciente,
    required this.doctor,
    required this.estado,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['appointmentId'] ?? 0,
      fecha: _leerFecha(json['date']?.toString() ?? ''),
      hora: json['time']?.toString() ?? '',
      motivo: json['reason']?.toString() ?? '',
      pacienteId: json['patientId'] ?? 0,
      doctorId: json['doctorId'] ?? 0,
      paciente: json['patientName']?.toString() ?? '',
      doctor: json['doctorName']?.toString() ?? '',
      estado: json['status']?.toString() ?? 'Programada',
    );
  }

  static DateTime _leerFecha(String raw) {
    if (raw.contains('-')) {
      final d = DateTime.tryParse(raw);
      if (d != null) return DateTime(d.year, d.month, d.day);
    }
    final partes = raw.split(' ').first.split('/');
    if (partes.length != 3) return DateTime(1970);
    final mes = int.tryParse(partes[0]) ?? 1;
    final dia = int.tryParse(partes[1]) ?? 1;
    final anio = int.tryParse(partes[2]) ?? 1970;
    return DateTime(anio, mes, dia);
  }

  String get codigo => 'CIT-${id.toString().padLeft(3, '0')}';

  String get fechaTexto =>
      '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

  String get horaTexto {
    final partes = hora.split(':');
    int h = int.tryParse(partes.first) ?? 0;
    final String min = partes.length > 1 ? partes[1] : '00';
    final String sufijo = h >= 12 ? 'PM' : 'AM';
    h = h % 12;
    if (h == 0) h = 12;
    return '${h.toString().padLeft(2, '0')}:$min $sufijo';
  }

  String get estadoTipo {
    switch (estado) {
      case 'Completada':
        return 'success';
      case 'Cancelada':
        return 'danger';
      case 'No asistió':
        return 'warning';
      default:
        return 'info';
    }
  }
}