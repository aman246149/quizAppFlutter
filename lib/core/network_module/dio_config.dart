import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../services/localdb.dart';
import 'endpoint.dart';

class DioConfig {
  static final DioConfig _instance = DioConfig._internal();
  late final Dio dio;
  final LocalDb _localDb = LocalDb();

  // Private constructor
  DioConfig._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: _getBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    _configureInterceptors();
  }

  // Singleton instance getter
  factory DioConfig() => _instance;

  String _getBaseUrl() {
    if (kReleaseMode) {
      return Endpoint.baseUrl;
    } else {
      return Endpoint.baseUrl;
    }
  }

  void _configureInterceptors() {
    // Auth Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await _localDb.getData('token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            return handler.next(options);
          } catch (e) {
            return handler.next(options);
          }
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Handle token expiration
            try {
              await _handleTokenExpiration();
              // Retry the request
              return handler.resolve(await _retry(error.requestOptions));
            } catch (e) {
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );

    // Logging Interceptor (only in debug mode)
    if (!kReleaseMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (object) {
            debugPrint('DIO LOG: $object');
          },
        ),
      );
    }

    // Retry Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (_shouldRetry(error)) {
            try {
              return handler.resolve(await _retry(error.requestOptions));
            } catch (e) {
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.response?.statusCode == 503); // Service Unavailable
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<void> _handleTokenExpiration() async {
    // Implement refresh token logic here
    try {
      final refreshToken = await _localDb.getData('refreshToken');
      if (refreshToken != null) {
        // Make refresh token API call
        // Update tokens in LocalDb
      } else {
        // Handle refresh token not found
        throw Exception('Refresh token not found');
      }
    } catch (e) {
      // Clear tokens and throw error
      await _localDb.removeData('token');
      await _localDb.removeData('refreshToken');
      throw Exception('Token refresh failed');
    }
  }

  // Method to update base URL (useful for switching environments)
  void updateBaseUrl(String newBaseUrl) {
    dio.options.baseUrl = newBaseUrl;
  }

  // Method to update default headers
  void updateDefaultHeaders(Map<String, dynamic> headers) {
    dio.options.headers.addAll(headers);
  }

  // Method to clear all tokens (useful for logout)
  Future<void> clearTokens() async {
    await _localDb.removeData('token');
    await _localDb.removeData('refreshToken');
    dio.options.headers.remove('Authorization');
  }
}
