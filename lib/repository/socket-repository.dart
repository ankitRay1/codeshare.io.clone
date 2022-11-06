import 'package:socket_io_client/socket_io_client.dart';

import '../clients/socket_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket;

  Socket get socketClient => _socketClient!;

  void joinRoom({required String documentId}) {
    _socketClient!.emit('join', documentId);
  }

  void typing({required Map<String, dynamic> typedData}) {
    _socketClient!.emit('typing', typedData);
  }

  void changeListener(Function(Map<String, dynamic>) func) {
    _socketClient!.on('changes', (data) => func(data));
  }

  void autoSave({required Map<String, dynamic> data}) {
    _socketClient!.emit('save', data);
  }
  void testSocket() {
    try {
      _socketClient!.onConnect((_) {
        print('connect');
        _socketClient!.emit('msg', 'test');
      });
      // _socketClient!.connect();
      // _socketClient!
      //     .on('connect', (_) => print('connect: ${_socketClient!.id}'));
    } catch (e) {
      print(e.toString());
    }

    // _socketClient?.socket!.on('event', (data) => print('I am on data $data'));
    // _socketClient?.socket!.ondisconnect();
    // _socketClient?.socket!
    //     .on('fromServer', (data) => print('I am fromServer $data'));
  }
}
