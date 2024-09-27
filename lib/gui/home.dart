import 'dart:io';

import 'package:eda/api/code_info.dart';
import 'package:eda/task.dart';
import 'package:eda/utils/port_forward.dart';
import 'package:flutter/material.dart';

import '../models/connect_info.dart';
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
        title: data.State.forwards.isEmpty
            ? const Text('Eda')
            : Text('Eda - ${data.State.forwards.length} 已连接'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  margin: const EdgeInsets.only(right: 20),
                  child: TextField(
                    onSubmitted: (code) async => _connect(context),
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '联机代码',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _connect(context),
                  child: const Text('连接'),
                ),
              ],
            ),
          ),
          const Divider(),
          Container(
            margin: const EdgeInsets.only(left: 10, top: 10),
            child: const Text(
              '已连接的游戏',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: data.State.forwards.isNotEmpty
                ? ListView.builder(
                    itemCount: data.State.forwards.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = data.State.forwards[index];
                      return Card(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                              ),
                              Text(
                                item.code,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text('正在关闭内建服务，请稍候。')));
                                      tasker.endMulticast(item.task);
                                      await item.server.close();
                                      data.State.forwards.remove(item);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('已断开。')));
                                      setState(() {});
                                    },
                                    child: const Text('断开'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : const Text('没有已连接的游戏'),
          ),
        ],
      ),
    );
  }

  _connect(BuildContext context) async {
    final code = _textEditingController.text;
    if (code.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请提供联机代码。')));
      return;
    }
    for (ConnectInfo info in data.State.forwards) {
      if (info.code == code) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('该联机已经启动过了，不能重复启动。')));
        return;
      }
    }
    CodeInfoResult? proxy;
    try {
      proxy = await requestCodeInfo(code);
    } catch (e, s) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('请求服务时发生错误：$e')));
      print(e);
      print(s);
    }
    if (proxy == null) {
      return;
    }
    if (proxy.status == 200) {
      final server = await forwarder.create(proxy.host!, proxy.port!);
      final task = await tasker.startMulticast(server, proxy.name!);
      final info = ConnectInfo(
          server: server, code: code, task: task, name: proxy.name!);
      data.State.forwards.add(info);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('联机已启动。')));
      setState(() {});
    } else {
      switch (proxy.status) {
        case 404:
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('请求的联机代码似乎无效，请检查！')));
        default:
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('发生错误: ${proxy.message}')));
      }
    }
  }
}
