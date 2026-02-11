import 'package:dio/dio.dart';
import '../security/secure_storage_manager.dart';
import 'oanda/oanda_config.dart';

class OandaRestClientLegacy {
  late final Dio _dio;
  String? _accountId;
  Function()? _tokenExpiredCallback;

  OandaRestClientLegacy() {
    _dio = Dio(BaseOptions(
      baseUrl: OandaConfig.baseUrl,
      connectTimeout: const Duration(milliseconds: OandaConfig.connectTimeout),
      receiveTimeout: const Duration(milliseconds: OandaConfig.receiveTimeout),
    ));
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SecureStorageManager.readOandaToken();
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          _tokenExpiredCallback?.call();
        }
        return handler.next(error);
      },
    ));
  }

  Future<void> init() async {
    _accountId = await SecureStorageManager.readOandaAccount();
  }

  Future<Map<String, dynamic>> fetchOpenPositions() async {
    final endpoint = "/v3/accounts/$_accountId/openPositions";
    final response = await _dio.get(endpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> closePosition(String instrument) async {
    final endpoint = "/v3/accounts/$_accountId/positions/$instrument/close";
    final response = await _dio.put(endpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> modifyPosition(
      String instrument, Map<String, dynamic> body) async {
    final endpoint = "/v3/accounts/$_accountId/positions/$instrument";
    final response = await _dio.put(endpoint, data: body);
    return response.data;
  }

  void setTokenExpiredCallback(Function()? callback) {
    _tokenExpiredCallback = callback;
  }
}
