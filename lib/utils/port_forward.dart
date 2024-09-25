import 'dart:io';

class PortForward {
  Future<ServerSocket> create(String remoteHost, int remotePort) async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
    print('Listening on port: ${server.port}');

    server.listen((client) async {
      final remoteSocket = await Socket.connect(remoteHost, remotePort);
      client.listen(
        (data) {
          // print("Received local host packet data: $data");
          // print("Received local host packet length: ${data.length}");
          remoteSocket.add(data);
        },
        onDone: () {
          remoteSocket.close();
        },
      );
      remoteSocket.listen(
        (data) {
          // print("Received remote host packet data: $data");
          // print("Received remote host packet length: ${data.length}");
          client.add(data);
        },
        onDone: () {
          client.close();
        },
      );
    });
    print('Listener for $remoteHost:$remotePort created');
    return server;
  }
}
