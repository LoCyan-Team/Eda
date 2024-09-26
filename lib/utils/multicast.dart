import 'dart:async';
import 'dart:io';

class Multicast {
  Future<Timer> createTask(int localPort, String motd) async {
    print('Local port: $localPort');
    final multicastAddress = InternetAddress('224.0.2.60');
    const port = 4445;
    final datagram = '[MOTD]$motd[/MOTD][AD]$localPort[/AD]'.codeUnits;

    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.joinMulticast(multicastAddress);

    return Timer.periodic(const Duration(milliseconds: 1500), (_) async {
      socket.send(datagram, multicastAddress, port);
      // print('Sent multicast packet');
    });
  }
}