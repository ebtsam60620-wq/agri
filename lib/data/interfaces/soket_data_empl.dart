import 'dart:developer';
import 'package:agri/core/configs/endpoints.dart';
import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/interfaces/soket_data_source.dart';
import 'package:agri/data/models/pending_emit.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@LazySingleton(as: SocketDataSource, order: -1)
class SocketIoImpl extends SocketDataSource {
  late io.Socket _socket;
  String? _token;
  final _pendingEmits = <PendingEmit>[];
  @postConstruct
  void init() {
    _token = di.get<UserLocalDataSource>().returnAuthToken()?.token;
  }

  @override
  bool get isConnected => _socket.connected;

  bool isManualDisconnect = false;

  Map<String, void Function(String event, dynamic map)> _eventsMap = {};

  @override
  io.Socket initSocket({
    String? token,
    String? path,
    Map<String, void Function(String event, dynamic map)>? events,
  }) {
    _token = token ?? _token;
    // if (_token == null) throw Exception("Token not set for socket connection");
    if (events != null && events.isNotEmpty) {
      _eventsMap = Map.from(events);
    }
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
        isManualDisconnect = false;
        log('Socket connected ✅');
        // Flush pending emits
        for (final e in _pendingEmits) {
          _socket.emit(e.event, e.data);
        }
        _pendingEmits.clear();
      })
      ..onDisconnect((_) {
        if (!isManualDisconnect) {
          isManualDisconnect = false;
          Future.delayed(Durations.short4, () => _socket.connect());
        } else {
          log('Socket disconnected ❌');
        }
      })
      ..onConnectError((data) => log('Socket connection error: $data'))
      ..onError((data) => log('Socket error: $data'))
      ..onReconnect((_) => log('Socket reconnected 🔁'))
      ..onReconnectError((data) => log('Socket reconnection error: $data'))
      ..onReconnectFailed((_) => log('Socket reconnection failed 🚫'))
      ..on('error', (l) {
        log('Socket error event: $l');
      });
    _eventsMap.forEach((event, callback) {
      _socket.on(event, (data) {
        log('OnAny event $event data $data');
        callback(event, data);
      });
    });
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
      isManualDisconnect = true;
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
      log('Socket not connected. Queuing emit $event');
      _pendingEmits.add(PendingEmit(event, data));
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
