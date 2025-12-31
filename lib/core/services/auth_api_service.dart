import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import 'storage_service.dart';

class AuthApiService {
  late final Dio _dio;

  AuthApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectionTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Interceptor para agregar token a las peticiones
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Manejar errores de autenticación
        if (error.response?.statusCode == 401) {
          // Token expirado o inválido
          await StorageService.clearAll();
        }
        return handler.next(error);
      },
    ));
  }

  // Registro
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? gender,
    String? ageRange,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.registerEndpoint,
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          if (gender != null) 'gender': gender,
          if (ageRange != null) 'ageRange': ageRange,
        },
      );

      final data = response.data as Map<String, dynamic>;

      // Guardar token y usuario
      if (data['accessToken'] != null) {
        await StorageService.saveAccessToken(data['accessToken']);
      }

      if (data['user'] != null) {
        final user = User.fromJson(data['user']);
        await StorageService.saveUserInfo(
          userId: user.id,
          email: user.email,
          firstName: user.firstName,
        );
      }

      return {
        'success': true,
        'user': User.fromJson(data['user']),
        'message': data['message'],
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;

      // Guardar token y usuario
      if (data['accessToken'] != null) {
        await StorageService.saveAccessToken(data['accessToken']);
      }

      if (data['user'] != null) {
        final user = User.fromJson(data['user']);
        await StorageService.saveUserInfo(
          userId: user.id,
          email: user.email,
          firstName: user.firstName,
        );
      }

      return {
        'success': true,
        'user': User.fromJson(data['user']),
        'message': data['message'],
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      await _dio.post(ApiConfig.logoutEndpoint);
      await StorageService.clearAll();

      return {
        'success': true,
        'message': 'Sesión cerrada exitosamente',
      };
    } on DioException catch (e) {
      await StorageService.clearAll();
      return _handleDioError(e);
    }
  }

  // Obtener perfil
  Future<User> getProfile() async {
    try {
      final response = await _dio.get(ApiConfig.profileEndpoint);
      final data = response.data as Map<String, dynamic>;
      return User.fromJson(data['user']);
    } on DioException catch (e) {
      throw _handleDioError(e)['error'] ?? 'Error al obtener perfil';
    }
  }

  // Actualizar perfil
  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? gender,
    String? ageRange,
  }) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateProfileEndpoint,
        data: {
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (gender != null) 'gender': gender,
          if (ageRange != null) 'ageRange': ageRange,
        },
      );

      final data = response.data as Map<String, dynamic>;
      return User.fromJson(data['user']);
    } on DioException catch (e) {
      throw _handleDioError(e)['error'] ?? 'Error al actualizar perfil';
    }
  }

  // Cambiar contraseña
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.put(
        ApiConfig.changePasswordEndpoint,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
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
