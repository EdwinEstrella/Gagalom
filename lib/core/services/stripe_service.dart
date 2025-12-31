import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'storage_service.dart';

class StripeService {
  late final Dio _dio;

  StripeService() {
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

  // Crear Payment Intent
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    String currency = 'usd',
    List<Map<String, dynamic>>? items,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.createPaymentIntentEndpoint,
        data: {
          'amount': (amount * 100).round(), // Convertir a centavos
          'currency': currency,
          if (items != null) 'items': items,
        },
      );

      return {
        'success': true,
        'clientSecret': response.data['clientSecret'],
        'paymentIntentId': response.data['paymentIntentId'],
        'amount': response.data['amount'],
        'currency': response.data['currency'],
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Confirmar pago
  Future<Map<String, dynamic>> confirmPayment({
    required String paymentIntentId,
    required List<Map<String, dynamic>> items,
    Map<String, dynamic>? shippingAddress,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.confirmPaymentEndpoint,
        data: {
          'paymentIntentId': paymentIntentId,
          'items': items,
          if (shippingAddress != null) 'shippingAddress': shippingAddress,
        },
      );

      return {
        'success': true,
        'orderId': response.data['orderId'],
        'status': response.data['status'],
        'totalAmount': response.data['totalAmount'],
        'message': response.data['message'],
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Obtener órdenes del usuario
  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await _dio.get(ApiConfig.getOrdersEndpoint);
      final data = response.data as Map<String, dynamic>;

      return List<Map<String, dynamic>>.from(
        data['orders'].map((order) => order as Map<String, dynamic>)
      );
    } on DioException catch (e) {
      throw _handleDioError(e)['error'] ?? 'Error al obtener órdenes';
    }
  }

  // Obtener detalles de una orden
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    try {
      final response = await _dio.get(
        ApiConfig.getOrderDetailsEndpoint(orderId)
      );
      final data = response.data as Map<String, dynamic>;

      return data['order'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e)['error'] ?? 'Error al obtener detalles de orden';
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
