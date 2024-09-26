import 'package:eda/api/code_info.dart';
import 'package:eda/task.dart';
import 'package:eda/utils/port_forward.dart';
import 'package:flutter/material.dart';

import '../model/connect_info.dart';
import '../state.dart' as data;

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  final forwarder = PortForward();
  final tasker = Task();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eda'),
      ),
      body: Column(
        children: [
          const Text('请输入联机代码'),
          TextField(
            controller: _textEditingController,
          ),
          TextButton(
            onPressed: () async {
              final code = _textEditingController.text;
              for (ConnectInfo info in data.State.forwards) {
                if (info.code == code) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('该联机已经启动过了，不能重复启动。')));
                  return;
                }
              }
              final proxy = await requestCodeInfo(code);
              if (proxy.status == 200) {
                final server = await forwarder.create(proxy.host!, proxy.port!);
                final task = await tasker.startMulticast(server, proxy.name!);
                final info = ConnectInfo(
                  server: server,
                  code: code,
                  task: task,
                );
                data.State.forwards.add(info);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('联机已启动。')));
              } else {
                switch (proxy.status) {
                  case 404:
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('请求的联机代码似乎无效，请检查！')));
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('发生错误: ${proxy.message}')));
                }
              }
            },
            child: const Text('连接'),
          ),
        ],
      ),
    );
  }
}
