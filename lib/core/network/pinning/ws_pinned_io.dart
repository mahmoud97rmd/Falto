import 'dart:io';
import 'package:web_socket_channel/io.dart';
import '../../settings/server_mode.dart';
import '../../settings/mode_storage.dart';
import 'pin_store.dart';

class WsPinnedFactory {
  static Future<IOWebSocketChannel> connectWithPinning(
      Uri uri, Map<String, dynamic> headers) async {
    final mode = await ModeStorage.load();

    final client = HttpClient()
      ..badCertificateCallback = (cert, host, port) {
        // Note: Certificate pinning requires computing SHA256 of the certificate
        // For now, allowing all certificates in sandbox mode
        return mode != ServerMode.live;
      };

    return IOWebSocketChannel.connect(
      uri,
      customClient: client,
      headers: headers,
    );
  }
}
