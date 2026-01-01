import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import 'storage_service.dart';

class AuthApiService {
  late final Dio _dio;

  AuthApiService() {
    print('🔧 [AUTH_API] Inicializando AuthApiService...');
    print('📍 [AUTH_API] Base URL: ${ApiConfig.baseUrl}');

    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectionTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Interceptor para agregar token a las peticiones y logs
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          print('🔑 [AUTH_API] Token encontrado, agregando Authorization header');
        } else {
          print('⚠️  [AUTH_API] No hay token almacenado');
        }
        print('📤 [AUTH_API] ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ [AUTH_API] Respuesta: ${response.statusCode} ${response.statusMessage}');
        return handler.next(response);
      },
      onError: (error, handler) async {
        print('❌ [AUTH_API] Error: ${error.message}');
        print('❌ [AUTH_API] Tipo: ${error.type}');
        print('❌ [AUTH_API] Status: ${error.response?.statusCode}');

        // Manejar errores de autenticación
        if (error.response?.statusCode == 401) {
          print('🔓 [AUTH_API] Token expirado o inválido, limpiando storage...');
          // Token expirado o inválido
          await StorageService.clearAll();
        }
        return handler.next(error);
      },
    ));

    print('✅ [AUTH_API] AuthApiService inicializado correctamente');
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
    print('\n📝 [AUTH_API] === INICIANDO REGISTRO ===');
    print('👤 [AUTH_API] Email: $email');
    print('👤 [AUTH_API] Nombre: $firstName $lastName');
    print('👤 [AUTH_API] Género: $gender');
    print('👤 [AUTH_API] Rango de edad: $ageRange');
    print('🔒 [AUTH_API] Contraseña: ${'*' * password.length} (${password.length} caracteres)');

    try {
      print('⏳ [AUTH_API] Enviando petición a ${ApiConfig.baseUrl}${ApiConfig.registerEndpoint}...');

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
      print('✅ [AUTH_API] Registro exitoso!');
      print('📦 [AUTH_API] Respuesta del servidor: ${data['message']}');

      // Guardar token y usuario
      if (data['accessToken'] != null) {
        print('💾 [AUTH_API] Guardando access token...');
        await StorageService.saveAccessToken(data['accessToken']);
        print('✅ [AUTH_API] Token guardado: ${data['accessToken'].toString().substring(0, 20)}...');
      }

      if (data['user'] != null) {
        final user = User.fromJson(data['user']);
        print('👤 [AUTH_API] Usuario creado: ID=${user.id}, Email=${user.email}');
        await StorageService.saveUserInfo(
          userId: user.id,
          email: user.email,
          firstName: user.firstName,
        );
        print('✅ [AUTH_API] Info de usuario guardada en storage');
      }

      print('🎉 [AUTH_API] === REGISTRO COMPLETADO ===\n');

      return {
        'success': true,
        'user': User.fromJson(data['user']),
        'message': data['message'],
      };
    } on DioException catch (e) {
      print('❌ [AUTH_API] Error en registro: ${e.message}');
      final errorResult = _handleDioError(e);
      print('💥 [AUTH_API] Error procesado: ${errorResult['error']}');
      print('❌ [AUTH_API] === REGISTRO FALLÓ ===\n');
      return errorResult;
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    print('\n🔐 [AUTH_API] === INICIANDO LOGIN ===');
    print('👤 [AUTH_API] Email: $email');
    print('🔒 [AUTH_API] Contraseña: ${'*' * password.length} (${password.length} caracteres)');

    try {
      print('⏳ [AUTH_API] Enviando petición a ${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}...');

      final response = await _dio.post(
        ApiConfig.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      print('✅ [AUTH_API] Login exitoso!');
      print('📦 [AUTH_API] Respuesta del servidor: ${data['message']}');

      // Guardar token y usuario
      if (data['accessToken'] != null) {
        print('💾 [AUTH_API] Guardando access token...');
        await StorageService.saveAccessToken(data['accessToken']);
        print('✅ [AUTH_API] Token guardado: ${data['accessToken'].toString().substring(0, 20)}...');
      }

      if (data['user'] != null) {
        final user = User.fromJson(data['user']);
        print('👤 [AUTH_API] Usuario logueado: ID=${user.id}, Email=${user.email}, Nombre=${user.firstName}');
        await StorageService.saveUserInfo(
          userId: user.id,
          email: user.email,
          firstName: user.firstName,
        );
        print('✅ [AUTH_API] Info de usuario guardada en storage');
      }

      print('🎉 [AUTH_API] === LOGIN COMPLETADO ===\n');

      return {
        'success': true,
        'user': User.fromJson(data['user']),
        'message': data['message'],
      };
    } on DioException catch (e) {
      print('❌ [AUTH_API] Error en login: ${e.message}');
      final errorResult = _handleDioError(e);
      print('💥 [AUTH_API] Error procesado: ${errorResult['error']}');
      print('❌ [AUTH_API] === LOGIN FALLÓ ===\n');
      return errorResult;
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    print('\n🚪 [AUTH_API] === INICIANDO LOGOUT ===');

    try {
      print('⏳ [AUTH_API] Enviando petición de logout...');
      await _dio.post(ApiConfig.logoutEndpoint);

      print('🗑️  [AUTH_API] Limpiando todo el storage...');
      await StorageService.clearAll();
      print('✅ [AUTH_API] Storage limpiado correctamente');

      print('🎉 [AUTH_API] === LOGOUT COMPLETADO ===\n');

      return {
        'success': true,
        'message': 'Sesión cerrada exitosamente',
      };
    } on DioException catch (e) {
      print('❌ [AUTH_API] Error en logout: ${e.message}');
      print('🗑️  [AUTH_API] Limpiando storage de todas formas...');
      await StorageService.clearAll();
      final errorResult = _handleDioError(e);
      print('✅ [AUTH_API] Storage limpiado después del error');
      print('❌ [AUTH_API] === LOGOUT CON ERRORES ===\n');
      return errorResult;
    }
  }

  // Obtener perfil
  Future<User> getProfile() async {
    print('\n👤 [AUTH_API] === OBTENIENDO PERFIL ===');

    try {
      print('⏳ [AUTH_API] Enviando petición GET a ${ApiConfig.profileEndpoint}...');
      final response = await _dio.get(ApiConfig.profileEndpoint);
      final data = response.data as Map<String, dynamic>;

      final user = User.fromJson(data['user']);
      print('✅ [AUTH_API] Perfil obtenido: ID=${user.id}, Email=${user.email}');
      print('🎉 [AUTH_API] === PERFIL OBTENIDO ===\n');

      return user;
    } on DioException catch (e) {
      print('❌ [AUTH_API] Error obteniendo perfil: ${e.message}');
      print('💥 [AUTH_API] Error procesado: ${_handleDioError(e)['error']}');
      print('❌ [AUTH_API] === ERROR OBTENIENDO PERFIL ===\n');
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
    print('\n✏️  [AUTH_API] === ACTUALIZANDO PERFIL ===');
    if (firstName != null) print('👤 [AUTH_API] Nuevo nombre: $firstName');
    if (lastName != null) print('👤 [AUTH_API] Nuevo apellido: $lastName');
    if (gender != null) print('👤 [AUTH_API] Nuevo género: $gender');
    if (ageRange != null) print('👤 [AUTH_API] Nuevo rango de edad: $ageRange');

    try {
      print('⏳ [AUTH_API] Enviando petición PUT a ${ApiConfig.updateProfileEndpoint}...');
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
      final user = User.fromJson(data['user']);
      print('✅ [AUTH_API] Perfil actualizado: ${user.firstName} ${user.lastName}');
      print('🎉 [AUTH_API] === PERFIL ACTUALIZADO ===\n');

      return user;
    } on DioException catch (e) {
      print('❌ [AUTH_API] Error actualizando perfil: ${e.message}');
      print('💥 [AUTH_API] Error procesado: ${_handleDioError(e)['error']}');
      print('❌ [AUTH_API] === ERROR ACTUALIZANDO PERFIL ===\n');
      throw _handleDioError(e)['error'] ?? 'Error al actualizar perfil';
    }
  }

  // Cambiar contraseña
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    print('\n🔑 [AUTH_API] === CAMBIANDO CONTRASEÑA ===');
    print('🔒 [AUTH_API] Contraseña actual: ${'*' * currentPassword.length} (${currentPassword.length} caracteres)');
    print('🔒 [AUTH_API] Nueva contraseña: ${'*' * newPassword.length} (${newPassword.length} caracteres)');

    try {
      print('⏳ [AUTH_API] Enviando petición PUT a ${ApiConfig.changePasswordEndpoint}...');
      final response = await _dio.put(
        ApiConfig.changePasswordEndpoint,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      print('✅ [AUTH_API] Contraseña cambiada exitosamente');
      print('🎉 [AUTH_API] === CONTRASEÑA CAMBIADA ===\n');

      return {
        'success': true,
        'message': response.data['message'],
      };
    } on DioException catch (e) {
      print('❌ [AUTH_API] Error cambiando contraseña: ${e.message}');
      final errorResult = _handleDioError(e);
      print('💥 [AUTH_API] Error procesado: ${errorResult['error']}');
      print('❌ [AUTH_API] === ERROR CAMBIANDO CONTRASEÑA ===\n');
      return errorResult;
    }
  }

  // Manejo de errores Dio
  Map<String, dynamic> _handleDioError(DioException error) {
    print('\n🔍 [AUTH_API] === ANALIZANDO ERROR ===');
    String errorMessage = 'Error desconocido';

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Error de conexión. Verifica tu internet.';
      print('⏱️  [AUTH_API] Error: Timeout de conexión');
    } else if (error.type == DioExceptionType.badResponse) {
      print('📡 [AUTH_API] Error: Respuesta inválida del servidor');
      print('📊 [AUTH_API] Status Code: ${error.response?.statusCode}');
      print('📦 [AUTH_API] Response Data: ${error.response?.data}');

      if (error.response?.data is Map<String, dynamic>) {
        final data = error.response!.data as Map<String, dynamic>;
        errorMessage = data['error'] ?? data['message'] ?? errorMessage;
        print('💬 [AUTH_API] Mensaje del servidor: $errorMessage');
      } else {
        errorMessage = 'Error del servidor: ${error.response?.statusCode}';
      }
    } else if (error.type == DioExceptionType.connectionError) {
      errorMessage = 'Error de conexión. No se puede conectar al servidor.';
      print('🔌 [AUTH_API] Error: No se puede conectar al servidor');
      print('🌐 [AUTH_API] URL: ${ApiConfig.baseUrl}');
    }

    print('❌ [AUTH_API] Error final: $errorMessage');
    print('🔍 [AUTH_API] === ANÁLISIS COMPLETADO ===\n');

    return {
      'success': false,
      'error': errorMessage,
    };
  }
}
