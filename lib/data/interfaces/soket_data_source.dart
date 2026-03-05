

import 'package:socket_io_client/socket_io_client.dart' as io;

abstract class SocketDataSource {
  /// Initialize the socket instance with optional token.

  io.Socket initSocket({
    String? token,
    String? path,
    Map<String, void Function(String event, dynamic map)>? events,
  });

  /// Connect to the socket server.
  void connect();

  /// Disconnect from the socket server.
  void disconnect();

  /// Check whether the socket is connected.
  bool get isConnected;

  /// Set bearer token for authenticated communication.
  void setToken(String token);

  /// Remove bearer token.
  void deleteToken();

  /// Emit an event with data to the socket server.
  void emit(String event, dynamic data);

  /// Listen to an event from the socket server.
  void on(String event, void Function(dynamic data) callback);
  void onError(void Function(dynamic error) callback);

  /// Stop listening to a specific event.
  void off(String event);

  void ping(dynamic data);
  void pong(void Function(dynamic data) callback);
}
