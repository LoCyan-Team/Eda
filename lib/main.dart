import 'package:eda/gui/home.dart';
import 'package:eda/utils/multicast.dart';
import 'package:eda/utils/port_forward.dart';
import 'package:flutter/material.dart';

void main() async {
  final portForward = PortForward();
  final multicast = Multicast();
  final server = await portForward.create('localhost', 25565);
  await multicast.createTask(server.port);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eda',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomeUI(),
      },
    );
  }
}
