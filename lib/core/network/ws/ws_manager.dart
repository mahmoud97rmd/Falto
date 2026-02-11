import '../../log/logger_service.dart';

class WsManager {
  bool _connected = false;

  Future<void> connect(String url) async {
    LoggerService.log('Connecting to WS: $url');
    _connected = true;
  }

  Future<void> disconnect() async {
    LoggerService.log('WS disconnected');
    _connected = false;
  }

  bool get isConnected => _connected;
}
