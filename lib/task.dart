import 'dart:async';
import 'dart:io';

import 'package:eda/utils/multicast.dart';

class Task {
  final multicast = Multicast();

  Future<Timer> startMulticast(ServerSocket forward, String name) async {
    String motd = 'LoCyanFrp - $name';
    return await multicast.createTask(forward.port, motd);
  }
  void endMulticast(Timer timer) {
    timer.cancel();
  }
}