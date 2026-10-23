abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException({String message = 'Error en el servidor', int? statusCode})
      : super(message, statusCode: statusCode);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'No autorizado. Inicie sesión nuevamente.'])
      : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Acceso denegado'])
      : super(statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Recurso no encontrado'])
      : super(statusCode: 404);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Error de conexión. Verifique su acceso a internet.']);
}

class ParsingException extends AppException {
  const ParsingException([super.message = 'Error al procesar la respuesta del servidor']);
}

class ValidationException extends AppException {
  const ValidationException(super.message) : super(statusCode: 400);
}
