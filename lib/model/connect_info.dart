import 'dart:async';
import 'dart:io';

class ConnectInfo {
  ConnectInfo({
    required this.server,
    required this.code,
    required this.task,
  });
  final ServerSocket server;
  final String code;
  final Timer task;
}
