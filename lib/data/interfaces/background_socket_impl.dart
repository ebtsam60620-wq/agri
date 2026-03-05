import 'dart:developer';
import 'package:agri/core/configs/endpoints.dart';
import 'package:agri/data/interfaces/soket_data_source.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

class BackgroundSocketImpl extends SocketDataSource {
  late io.Socket _socket;
  String? _token;
  final _pendingEmits = []; //<PendingEmit>

  @override
  bool get isConnected => _socket.connected;

  @override
  io.Socket initSocket({
    String? token,
    String? path,
    Map<String, void Function(String event, dynamic map)>? events,
  }) {
    _token = token ?? _token;

    _socket = io.io(
      '${EndPoints.socketBaseURL}$path',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          })
          .build(),
    );

    _socket
      ..onConnect((_) {
        log('Background Socket connected ✅');
        // Flush pending emits
        for (final e in _pendingEmits) {
          _socket.emit(e.event, e.data);
        }
        _pendingEmits.clear();
      })
      ..onDisconnect((_) {
        log('Background Socket disconnected ❌');
      })
      ..onConnectError(
        (data) => log('Background Socket connection error: $data'),
      )
      ..onError((data) => log('Background Socket error: $data'))
      ..onReconnect((_) => log('Background Socket reconnected 🔁'))
      ..onReconnectError(
        (data) => log('Background Socket reconnection error: $data'),
      )
      ..onReconnectFailed(
        (_) => log('Background Socket reconnection failed 🚫'),
      )
      ..on('error', (l) {
        log('Background Socket error event: $l');
      });

    if (events != null) {
      events.forEach((event, callback) {
        _socket.on(event, (data) => callback(event, data));
      });
    }

    return _socket;
  }

  @override
  void connect() {
    if (!_socket.connected) {
      _socket.connect();
    }
  }

  @override
  void disconnect() {
    if (_socket.connected) {
      _socket.disconnect();
    }
  }

  @override
  void setToken(String token) {
    _token = token;
    _socket.io.options?['extraHeaders'] = {
      'Authorization': 'Bearer $_token',
      'Accept': 'application/json',
    };
    if (_socket.connected) {
      _socket.disconnect();
      _socket.connect();
    }
  }

  @override
  void deleteToken() {
    _token = null;
    _socket.io.options?.remove('extraHeaders');
  }

  @override
  void emit(String event, dynamic data) {
    if (isConnected) {
      _socket.emit(event, data);
    } else {
      log('Background Socket not connected. Queuing emit $event');
      _pendingEmits.add((event, data)); //PendingEmit
      connect();
    }
  }

  @override
  void on(String event, void Function(dynamic data) callback) {
    _socket.on(event, callback);
  }

  @override
  void off(String event) {
    _socket.off(event);
  }

  @override
  void ping(data) => emit('location.ping', data);

  @override
  void pong(void Function(dynamic data) callback) {
    on('pong', callback);
  }

  @override
  void onError(void Function(dynamic error) callback) {
    on('error', callback);
  }
}
