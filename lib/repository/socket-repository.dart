import 'package:flutter/material.dart';
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

  void disConnect() {
    _socketClient!.disconnect();
    debugPrint('socket client disconnected!');
  }
}
