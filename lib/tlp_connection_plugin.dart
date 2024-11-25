library tlp_connection_plugin;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as mat;
import 'package:tlp_connection_plugin/ui/tlp_conn_bottom_sheet.dart';
import 'package:web_socket_client/web_socket_client.dart';

/// A TLP Connection SDK for Flutter.
sealed class Connector {
  /// The current version of the TLP Connection SDK.
  static String get version => '0.0.1';

  /// Connects to the TLP Connection SDK.
  /// [connectionString] is the connection string ("ip:port" for WebSocket).
  /// [connectionType] specifies the type of connection.
  void connect(String connectionString, ConnectionType connectionType);

  /// Disconnects from the TLP Connection SDK.
  void disconnect();

  /// Sends a message to the TLP Connection SDK.
  /// [message] is the message to send.
  /// [messageType] specifies the type of the message.
  void sendMessage(String message, MessageType messageType);

  /// Retrieves the current connection status as a one-time value.
  ConnectionStatus get currentStatus;
}

class TlpConnectionPlugin implements Connector {
  late WebSocket _socket;

  final StreamController<ConnectionStatus> _connectionStatusController = StreamController<ConnectionStatus>.broadcast();
  final StreamController<dynamic> _receivedMessageController = StreamController<dynamic>.broadcast();

  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;
  final ConnectionType _connectionType = ConnectionType.websocket;

  /// Stream for real-time connection status updates.
  Stream<ConnectionStatus> get connectionStatusStream => _connectionStatusController.stream;

  /// Stream for receiving messages in real-time.
  Stream<dynamic> get receivedMessageStream => _receivedMessageController.stream;

  @override
  ConnectionStatus get currentStatus => _currentStatus;

  @override
  void connect(String connectionString, ConnectionType connectionType) {
    if (connectionType != ConnectionType.websocket) {
      _log("Currently, only WebSocket connections are supported.");
      _updateConnectionStatus(ConnectionStatus.disconnected);
      return;
    }

    try {
      var backoff = LinearBackoff(
        initial: const Duration(seconds: 1),
        increment: const Duration(seconds: 3),
        maximum: const Duration(seconds: 5),
      );
      const timeout = Duration(seconds: 30);
      _socket = WebSocket(Uri.parse('ws://$connectionString'), timeout: timeout, backoff: backoff);
      _log("Connecting via ${_connectionType.name}...");
      _socket.connection.listen(
        _handleConnectionState,
        onError: (error) {
          _log("Connection error: $error");
          _updateConnectionStatus(ConnectionStatus.disconnected);
        },
        onDone: () {
          _log("Connection closed.");
          _updateConnectionStatus(ConnectionStatus.disconnected);
        },
      );
    } catch (e, stackTrace) {
      _log("Connection error: $e\n$stackTrace");
      _updateConnectionStatus(ConnectionStatus.disconnected);
    }
  }

  @override
  void disconnect() {
    try {
      _socket.close();
      _updateConnectionStatus(ConnectionStatus.disconnected);
    } catch (e) {
      _log("Error during disconnection: $e");
    }
  }

  @override
  void sendMessage(dynamic message, MessageType messageType) {
    if (_currentStatus != ConnectionStatus.connected) {
      _log("Cannot send message: Not connected.");
      return;
    }
    try {
      _socket.send("x1Zf0o115HelloTestKey");
      _socket.send(message);
      _log("Message sent: $message");
      _listenForMessages();
    } catch (e) {
      _log("Error sending message: $e");
    }
  }

  void _handleConnectionState(ConnectionState state) {
    if (state is Connecting) {
      _updateConnectionStatus(ConnectionStatus.connecting);
    } else if (state is Connected) {
      // for debuggging, send handshake immediately after connection
      _updateConnectionStatus(ConnectionStatus.connected);
    } else if (state is Reconnecting) {
      _updateConnectionStatus(ConnectionStatus.reconnecting);
    } else if (state is Reconnected) {
      _updateConnectionStatus(ConnectionStatus.connected);
    } else if (state is Disconnecting) {
      _updateConnectionStatus(ConnectionStatus.disconnecting);
    } else if (state is Disconnected) {
      _updateConnectionStatus(ConnectionStatus.disconnected);
    }
  }

  void _listenForMessages() {
    if (_currentStatus != ConnectionStatus.connected) {
      _log("Cannot listen for messages: Not connected.");
      return;
    }

    _socket.messages.listen(
      (message) {
        if (message.toString().contains('Hello from server!')) {
          return;
        } else {
          BigInt? answer = BigInt.tryParse(message);
          if (answer != null) {
            _receivedMessageController.add(answer.toInt());
            // call notification
          }
          _receivedMessageController.add(message);

          _log("Message received: $message");
        }
      },
      onError: (e) {
        _log("Error receiving message: $e");
      },
    );
  }

  void _updateConnectionStatus(ConnectionStatus status) {
    _currentStatus = status;
    _connectionStatusController.add(status);
    _log("Connection status updated: $status");
  }

  void dispose() {
    _connectionStatusController.close();
    _receivedMessageController.close();
  }

  void _log(String message) {
    if (kDebugMode) {
      print("[TlpConnectionPlugin] $message");
    }
  }

// start (reefactor later)
  /// opens a bottom sheet and connects to the TLP Connection SDK
  /// [context] is the BuildContext of the widget that calls this function
  /// [connectionString] is the connection string to connect to
  /// [connectionType] is the type of connection to use
  /// [onConnectionStatusChanged] is a callback function that is called when the connection status changes
  start(mat.BuildContext context, String connectionString, ConnectionType connectionType,
      void Function(ConnectionStatus) onConnectionStatusChanged) async {
    if (connectionType != ConnectionType.websocket) {
      _log("Currently, only WebSocket connections are supported.");
      // for now
      disconnect();
      return;
    }
    connect(connectionString, connectionType);
    return mat.showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => TlpBottomSheet(tlpConnectionPlugin: this),
    );
  }
}

enum ConnectionStatus {
  connecting,
  connected,
  disconnected,
  reconnecting,
  disconnecting,
}

enum ConnectionType {
  websocket,
  http,
  lightning,
}

enum MessageType {
  tlp,
  handshake,
}
