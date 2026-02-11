import 'package:dio/dio.dart';

class RestRetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RestRetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final options = err.requestOptions;
      final retryCount = options.extra['retryCount'] ?? 0;

      if (retryCount < maxRetries) {
        options.extra['retryCount'] = retryCount + 1;
        await Future.delayed(retryDelay * (retryCount + 1));

        try {
          final dio = Dio();
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }

  static void apply(Dio dio) {
    dio.interceptors.add(RestRetryInterceptor());
  }
}
