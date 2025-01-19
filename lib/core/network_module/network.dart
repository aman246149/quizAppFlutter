import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dio_config.dart';

class Network {
  static final Network _instance = Network._internal();
  late final Dio dio;

  Network._internal() {
    dio = DioConfig().dio;
  }

  factory Network() => _instance;

  // GET Request
  Future<T?> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // POST Request
  Future<T?> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // PUT Request
  Future<T?> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // DELETE Request
  Future<T?> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // PATCH Request
  Future<T?> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // Upload File
  Future<T?> uploadFile<T>({
    required String endpoint,
    required String filePath,
    required String fileKey,
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        fileKey: await MultipartFile.fromFile(filePath),
        if (data != null) ...data,
      });

      final response = await dio.post(
        endpoint,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // Download File
  Future<bool> downloadFile({
    required String url,
    required String savePath,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  // Handle Response
  T? _handleResponse<T>(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data is Map<String, dynamic>) {
        return response.data as T;
      } else if (response.data is List) {
        return response.data as T;
      } else if (T == String) {
        return response.data.toString() as T;
      }
      return response.data;
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Unexpected status code: ${response.statusCode}',
      );
    }
  }

  // Handle Error
  void _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception('Connection timeout');
        case DioExceptionType.sendTimeout:
          throw Exception('Send timeout');
        case DioExceptionType.receiveTimeout:
          throw Exception('Receive timeout');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;
          throw Exception(_getErrorMessage(statusCode, responseData));
        case DioExceptionType.cancel:
          throw Exception('Request cancelled');
        default:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;
          throw Exception(_getErrorMessage(statusCode, responseData));
      }
    } else {
      throw Exception('Unexpected error occurred');
    }
  }

  // Get Error Message
  String _getErrorMessage(int? statusCode, dynamic responseData) {
    switch (statusCode) {
      case 400:
        return _parseErrorMessage(responseData) ?? 'Bad request';
      case 401:
        return _parseErrorMessage(responseData) ?? 'Unauthorized';
      case 403:
        return _parseErrorMessage(responseData) ?? 'Forbidden';
      case 404:
        return _parseErrorMessage(responseData) ?? 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Something went wrong';
    }
  }

  // Parse Error Message
  String? _parseErrorMessage(dynamic responseData) {
    if (responseData == null) return null;
    try {
      if (responseData is String) {
        return responseData;
      } else if (responseData is Map) {
        return responseData['message'] ?? responseData['error'];
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing error message: $e');
      }
      return null;
    }
  }
}
