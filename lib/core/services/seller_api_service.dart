import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'storage_service.dart';

class SellerApiService {
  late final Dio _dio;

  SellerApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectionTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  // Crear solicitud de vendedor
  Future<Map<String, dynamic>> createSellerRequest({
    required String businessName,
    String? businessDescription,
    String? businessType,
    String? taxId,
    required String phone,
    required String address,
    required String city,
  }) async {
    try {
      final response = await _dio.post(
        '/api/seller/request',
        data: {
          'businessName': businessName,
          if (businessDescription != null) 'businessDescription': businessDescription,
          if (businessType != null) 'businessType': businessType,
          if (taxId != null) 'taxId': taxId,
          'phone': phone,
          'address': address,
          'city': city,
        },
      );

      return {
        'success': true,
        'message': response.data['message'],
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Obtener mi solicitud de vendedor
  Future<Map<String, dynamic>?> getMySellerRequest() async {
    try {
      final response = await _dio.get('/api/seller/my-request');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // No hay solicitud
      }
      throw _handleDioError(e)['error'] ?? 'Error al obtener solicitud';
    }
  }

  // Obtener estadísticas de vendedor
  Future<Map<String, dynamic>> getSellerStats() async {
    try {
      final response = await _dio.get('/api/seller/stats');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e)['error'] ?? 'Error al obtener estadísticas';
    }
  }

  // Manejo de errores Dio
  Map<String, dynamic> _handleDioError(DioException error) {
    String errorMessage = 'Error desconocido';

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Error de conexión. Verifica tu internet.';
    } else if (error.type == DioExceptionType.badResponse) {
      if (error.response?.data is Map<String, dynamic>) {
        final data = error.response!.data as Map<String, dynamic>;
        errorMessage = data['error'] ?? data['message'] ?? errorMessage;
      } else {
        errorMessage = 'Error del servidor: ${error.response?.statusCode}';
      }
    } else if (error.type == DioExceptionType.connectionError) {
      errorMessage = 'Error de conexión. No se puede conectar al servidor.';
    }

    return {
      'success': false,
      'error': errorMessage,
    };
  }
}
