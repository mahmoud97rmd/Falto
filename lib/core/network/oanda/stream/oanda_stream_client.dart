import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../oanda_config.dart';
import '../../../security/secure_storage_manager.dart';

class OandaStreamClient {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  Future<void> connect(String symbol, void Function(dynamic) onData,
      {void Function()? onDone, void Function(dynamic)? onError}) async {
    final token = await SecureStorageManager.readOandaToken();
    final accountId = await SecureStorageManager.readOandaAccount();
    final url =
        "${OandaConfig.streamBaseUrl}/accounts/$accountId/pricing/stream?instruments=$symbol";
    _channel = WebSocketChannel.connect(
      Uri.parse(url),
      // Note: WebSocketChannel.connect doesn't support headers directly
      // Consider using IOWebSocketChannel for header support
    );

    _subscription = _channel!.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
    );
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
  }
}
