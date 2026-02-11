import 'dart:async';
import 'package:web_socket_channel/io.dart';
import '../security/secure_storage_manager.dart';
import 'oanda/oanda_config.dart';

class OandaStreamClientLegacy {
  IOWebSocketChannel? _channel;
  String? _url;
  DateTime _lastReceivedTime = DateTime.now();
  bool _disposed = false;
  Timer? _heartbeatTimer;
  void Function(dynamic)? _onMessage;

  Future<void> init(String symbol, void Function(dynamic) onMessage) async {
    _onMessage = onMessage;
    final token = await SecureStorageManager.readOandaToken();
    final accountId = await SecureStorageManager.readOandaAccount();
    _url =
        "${OandaConfig.streamBaseUrl}/v3/accounts/$accountId/pricing/stream?instruments=$symbol";
  }

  void startStreaming() {
    _connect();
  }

  void _connect() {
    if (_url == null || _disposed) return;

    _channel = IOWebSocketChannel.connect(Uri.parse(_url!));

    _channel!.stream.listen((msg) {
      _lastReceivedTime = DateTime.now();
      _onMessage?.call(msg);
    }, onError: (e) {
      if (!_disposed) {
        Future.delayed(const Duration(seconds: 2), () => _connect());
      }
    }, onDone: () {
      if (!_disposed) {
        Future.delayed(const Duration(seconds: 2), () => _connect());
      }
    });

    _startHeartbeatMonitor();
  }

  void _startHeartbeatMonitor() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 10), (t) {
      if (DateTime.now().difference(_lastReceivedTime).inSeconds > 30) {
        _channel?.sink.close();
        _connect();
      }
    });
  }

  void dispose() {
    _disposed = true;
    _heartbeatTimer?.cancel();
    _channel?.sink.close();
  }
}
