import 'dart:io';
import 'package:crypto/crypto.dart';

class CertificateHelper {
  static String getSha256(X509Certificate cert) {
    final bytes = cert.der;
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
