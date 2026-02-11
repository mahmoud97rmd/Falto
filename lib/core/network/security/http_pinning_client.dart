import 'dart:io';
import 'package:http/io_client.dart';
import '../../settings/mode_storage.dart';
import '../../settings/server_mode.dart';

class HttpPinningClient {
  static Future<IOClient> create() async {
    final mode = await ModeStorage.load();

    final httpClient = HttpClient()
      ..badCertificateCallback = (cert, host, port) {
        // Note: Certificate pinning requires computing SHA256 of the certificate
        // For now, allowing all certificates in sandbox mode
        return mode != ServerMode.live;
      };

    return IOClient(httpClient);
  }
}
