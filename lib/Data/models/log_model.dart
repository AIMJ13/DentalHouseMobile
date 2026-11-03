class LogModel {
  final String id;
  final DateTime timestamp;
  final String userName;
  final String? userRole;
  final String module;
  final String action;
  final String description;
  final String ipAddress;
  final bool isSuccess;

  LogModel({
    required this.id,
    required this.timestamp,
    required this.userName,
    this.userRole,
    required this.module,
    required this.action,
    required this.description,
    required this.ipAddress,
    required this.isSuccess,
  });

  String get code {
    if (id.isEmpty) return '#LOG-001';
    final clean = id.replaceAll('-', '').trim();
    if (clean.length > 4) {
      return '#LOG-${clean.substring(clean.length - 4).toUpperCase()}';
    }
    return '#LOG-${clean.toUpperCase()}';
  }

  String get formattedDate {
    final year = timestamp.year.toString();
    final month = timestamp.month.toString().padLeft(2, '0');
    final day = timestamp.day.toString().padLeft(2, '0');
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  String get status => isSuccess ? 'Éxito' : 'Fallo';

  String get initial {
    if (userName.isEmpty || userName.toLowerCase() == 'sistema') return 'S';
    return userName.substring(0, 1).toUpperCase();
  }

  factory LogModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      final rawDate = json['timestamp'] ?? json['createdAt'];
      parsedDate = rawDate != null ? DateTime.parse(rawDate.toString()).toLocal() : DateTime.now();
    } catch (_) {
      parsedDate = DateTime.now();
    }

    final rawSuccess = json['isSuccess'];
    bool success = true;
    if (rawSuccess is bool) {
      success = rawSuccess;
    } else if (json['statusCode'] != null) {
      final code = int.tryParse(json['statusCode'].toString()) ?? 200;
      success = code < 400;
    }

    return LogModel(
      id: (json['logId'] ?? json['id'] ?? '').toString(),
      timestamp: parsedDate,
      userName: (json['userName'] ?? json['userId'] ?? 'Sistema').toString(),
      userRole: json['userRole']?.toString(),
      module: (json['module'] ?? 'General').toString(),
      action: (json['action'] ?? 'Auditoría').toString(),
      description: (json['description'] ?? 'Registro de auditoría del sistema').toString(),
      ipAddress: (json['ipAddress'] ?? json['clientIp'] ?? '127.0.0.1').toString(),
      isSuccess: success,
    );
  }
}

class LogPaginationModel {
  final int pageNumber;
  final int pageSize;
  final int totalRecords;
  final int totalPages;
  final List<LogModel> items;

  LogPaginationModel({
    required this.pageNumber,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
    required this.items,
  });

  factory LogPaginationModel.fromJson(dynamic json) {
    final rawList = json is List ? json : (json is Map<String, dynamic> ? (json['data'] ?? json['items'] ?? []) : []);
    final List<LogModel> items = [];
    if (rawList is List) {
      for (var item in rawList) {
        if (item is Map<String, dynamic>) {
          items.add(LogModel.fromJson(item));
        }
      }
    }

    if (json is Map<String, dynamic>) {
      final pageNumber = int.tryParse((json['pageNumber'] ?? json['page'] ?? 1).toString()) ?? 1;
      final pageSize = int.tryParse((json['pageSize'] ?? 10).toString()) ?? 10;
      final totalRecords = int.tryParse((json['totalRecords'] ?? json['total'] ?? items.length).toString()) ?? items.length;
      final totalPages = int.tryParse((json['totalPages'] ?? 1).toString()) ?? 1;

      return LogPaginationModel(
        pageNumber: pageNumber,
        pageSize: pageSize,
        totalRecords: totalRecords,
        totalPages: totalPages > 0 ? totalPages : 1,
        items: items,
      );
    }

    return LogPaginationModel(
      pageNumber: 1,
      pageSize: items.isNotEmpty ? items.length : 10,
      totalRecords: items.length,
      totalPages: 1,
      items: items,
    );
  }
}
