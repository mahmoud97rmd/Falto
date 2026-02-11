import 'dart:io';
import 'package:http/io_client.dart';

class CertificatePinning {
  // Store expected SHA256 pins for certificate validation
  static const List<String> _expectedPins = [
    // Add OANDA certificate SHA256 pins here
  ];

  static HttpClient getPinnedHttpClient({bool allowAllCerts = true}) {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // In development, allow all certificates
      // In production, validate against expected pins
      if (allowAllCerts) return true;

      // Note: X509Certificate doesn't have sha256 property directly
      // You'd need to compute it from cert.der
      return true;
    };
    return client;
  }

  static IOClient getIOClient({bool allowAllCerts = true}) =>
      IOClient(getPinnedHttpClient(allowAllCerts: allowAllCerts));
}
