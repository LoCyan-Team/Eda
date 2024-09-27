import 'dart:async';
import 'dart:io';

class ConnectInfo {
  ConnectInfo({
    required this.server,
    required this.code,
    required this.task,
    required this.name,
  });
  final ServerSocket server;
  final String code;
  final Timer task;
  final String name;
}
