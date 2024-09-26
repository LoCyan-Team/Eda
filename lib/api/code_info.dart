import 'package:dio/dio.dart';

import 'base.dart';

Dio _instance = Dio();

Future<CodeInfoResult> requestCodeInfo(String code) async {
  _instance.options.validateStatus = (status) {
    return true;
  };
  Map<String, Object> params = {
    'code': code,
  };
  var rs = await _instance.get('$api/minecraft/game', queryParameters: params);

  return CodeInfoResult(
      status: rs.statusCode ?? -1,
      message: rs.data['message'],
      host: rs.data['data']['host'],
      port: rs.data['data']['port'],
      name: rs.data['data']['name']);
}

class CodeInfoResult {
  CodeInfoResult({
    required this.status,
    required this.message,
    this.host,
    this.port,
    this.name,
  });

  final int status;
  final String message;
  final String? host;
  final int? port;
  final String? name;
}
