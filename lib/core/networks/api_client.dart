import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constant/api_constants.dart';
import '../errors/app_exceptions.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(method: 'GET', path: path, query: query);

  Future<dynamic> post(String path, {dynamic body}) =>
      _send(method: 'POST', path: path, body: body);

  Future<dynamic> put(String path, {dynamic body}) =>
      _send(method: 'PUT', path: path, body: body);

  Future<dynamic> delete(String path) =>
      _send(method: 'DELETE', path: path);

  Future<dynamic> patch(String path, {dynamic body}) =>
      _send(method: 'PATCH', path: path, body: body);

  Future<dynamic> _send({
    required String method,
    required String path,
    Map<String, dynamic>? query,
    dynamic body,
    Map<String, String>? customHeaders,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseApiUrl}$path')
        .replace(queryParameters: query?.map((k, v) => MapEntry(k, v.toString())));

    final request = http.Request(method, uri);

    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    if (customHeaders != null) {
      request.headers.addAll(customHeaders);
    }

    try {
      final streamedResponse = await _client.send(request).timeout(
        ApiConstants.timeoutDuration,
        onTimeout: () => throw TimeoutException('Tiempo de espera agotado'),
      );

      final response = await http.Response.fromStream(streamedResponse);
      return _decodeResponse(response);
    } on SocketException {
      throw const NetworkException('Error de conexión con el servidor');
    } on TimeoutException {
      throw const NetworkException('Tiempo de espera agotado');
    } on http.ClientException {
      throw const NetworkException('Error de comunicación HTTP');
    }
  }

  dynamic _decodeResponse(http.Response response) {
    if (response.body.isEmpty) {
      return null;
    }

    dynamic responseBody;
    try {
      responseBody = jsonDecode(response.body);
    } on FormatException {
      throw const ParsingException('Formato de respuesta no válido');
    }

    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      return responseBody;
    }

    if (statusCode == 400) {
      final msg = responseBody is Map ? (responseBody['message'] ?? 'Datos no válidos') : 'Datos no válidos';
      throw ValidationException(msg.toString());
    } else if (statusCode == 401) {
      throw const UnauthorizedException('Credenciales incorrectas');
    } else if (statusCode == 403) {
      throw const ForbiddenException('Acceso denegado');
    } else if (statusCode == 404) {
      final msg = responseBody is Map ? (responseBody['message'] ?? 'Recurso no encontrado') : 'Recurso no encontrado';
      throw NotFoundException(msg.toString());
    } else {
      final msg = responseBody is Map ? (responseBody['message'] ?? 'Error en el servidor') : 'Error en el servidor';
      throw ServerException(
        message: msg.toString(),
        statusCode: statusCode,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
