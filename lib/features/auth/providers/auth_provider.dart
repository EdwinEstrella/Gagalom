import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user.dart';
import '../../../core/services/auth_api_service.dart';
import '../../../core/services/storage_service.dart';

part 'auth_state.dart';

// Provider del servicio de API
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  print('🏗️  [AUTH_PROVIDER] Creando instancia de AuthApiService');
  return AuthApiService();
});

// Provider del estado de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApiService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    print('🎬 [AUTH_PROVIDER] Inicializando AuthNotifier');
    _initAuth();
  }

  // Inicializar autenticación al iniciar la app
  Future<void> _initAuth() async {
    print('\n🔄 [AUTH_PROVIDER] === INICIANDO AUTENTICACIÓN ===');

    final isAuthenticated = await StorageService.isAuthenticated();
    print('🔑 [AUTH_PROVIDER] Token existe en storage: $isAuthenticated');

    if (isAuthenticated) {
      try {
        print('⏳ [AUTH_PROVIDER] Token encontrado, obteniendo perfil...');
        final user = await _authService.getProfile();
        print('✅ [AUTH_PROVIDER] Perfil obtenido: ${user.firstName} ${user.lastName} (${user.email})');
        print('👤 [AUTH_PROVIDER] ID de usuario: ${user.id}');

        state = AuthState(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        print('🎉 [AUTH_PROVIDER] === USUARIO AUTENTICADO ===\n');
      } catch (e) {
        print('❌ [AUTH_PROVIDER] Error obteniendo perfil: $e');
        print('🗑️  [AUTH_PROVIDER] Limpiando storage...');
        // Si hay error, limpiar y dejar no autenticado
        await StorageService.clearAll();
        state = const AuthState(isAuthenticated: false, isLoading: false);
        print('⚠️  [AUTH_PROVIDER] === USUARIO NO AUTENTICADO (ERROR) ===\n');
      }
    } else {
      print('⚠️  [AUTH_PROVIDER] No hay token, usuario no autenticado');
      state = const AuthState(isAuthenticated: false, isLoading: false);
      print('⚠️  [AUTH_PROVIDER] === USUARIO NO AUTENTICADO ===\n');
    }
  }

  // Registro
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? gender,
    String? ageRange,
  }) async {
    print('\n📝 [AUTH_PROVIDER] === SOLICITANDO REGISTRO ===');
    print('🔄 [AUTH_PROVIDER] Cambiando estado a isLoading=true');
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('⏳ [AUTH_PROVIDER] Llamando a AuthApiService.register...');
      final result = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        ageRange: ageRange,
      );

      if (result['success'] == true) {
        final user = result['user'] as User;
        print('✅ [AUTH_PROVIDER] Registro exitoso!');
        print('👤 [AUTH_PROVIDER] Usuario: ${user.firstName} ${user.lastName} (ID: ${user.id})');

        state = AuthState(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        print('🎉 [AUTH_PROVIDER] === REGISTRO COMPLETADO ===\n');
        return true;
      } else {
        print('❌ [AUTH_PROVIDER] Registro fallido');
        print('💥 [AUTH_PROVIDER] Error: ${result['error']}');

        state = state.copyWith(
          isLoading: false,
          error: result['error'] as String?,
        );
        print('❌ [AUTH_PROVIDER] === REGISTRO FALLÓ ===\n');
        return false;
      }
    } catch (e) {
      print('💥 [AUTH_PROVIDER] Excepción en registro: $e');

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      print('❌ [AUTH_PROVIDER] === ERROR EN REGISTRO ===\n');
      return false;
    }
  }

  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    print('\n🔐 [AUTH_PROVIDER] === SOLICITANDO LOGIN ===');
    print('🔄 [AUTH_PROVIDER] Cambiando estado a isLoading=true');
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('⏳ [AUTH_PROVIDER] Llamando a AuthApiService.login...');
      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        final user = result['user'] as User;
        print('✅ [AUTH_PROVIDER] Login exitoso!');
        print('👤 [AUTH_PROVIDER] Usuario: ${user.firstName} ${user.lastName} (ID: ${user.id})');

        state = AuthState(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        print('🎉 [AUTH_PROVIDER] === LOGIN COMPLETADO ===\n');
        return true;
      } else {
        print('❌ [AUTH_PROVIDER] Login fallido');
        print('💥 [AUTH_PROVIDER] Error: ${result['error']}');

        state = state.copyWith(
          isLoading: false,
          error: result['error'] as String?,
        );
        print('❌ [AUTH_PROVIDER] === LOGIN FALLÓ ===\n');
        return false;
      }
    } catch (e) {
      print('💥 [AUTH_PROVIDER] Excepción en login: $e');

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      print('❌ [AUTH_PROVIDER] === ERROR EN LOGIN ===\n');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    print('\n🚪 [AUTH_PROVIDER] === SOLICITANDO LOGOUT ===');
    print('🔄 [AUTH_PROVIDER] Cambiando estado a isLoading=true');
    state = state.copyWith(isLoading: true);

    try {
      print('⏳ [AUTH_PROVIDER] Llamando a AuthApiService.logout...');
      await _authService.logout();
      print('✅ [AUTH_PROVIDER] Logout exitoso');

      state = const AuthState(
        isAuthenticated: false,
        isLoading: false,
      );
      print('🎉 [AUTH_PROVIDER] === LOGOUT COMPLETADO ===\n');
    } catch (e) {
      print('❌ [AUTH_PROVIDER] Error en logout: $e');
      print('🗑️  [AUTH_PROVIDER] Limpiando estado local de todas formas...');

      // Incluso si hay error, limpiar estado local
      await StorageService.clearAll();
      state = const AuthState(
        isAuthenticated: false,
        isLoading: false,
      );
      print('⚠️  [AUTH_PROVIDER] === LOGOUT CON ERRORES ===\n');
    }
  }

  // Actualizar perfil
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? gender,
    String? ageRange,
  }) async {
    print('\n✏️  [AUTH_PROVIDER] === ACTUALIZANDO PERFIL ===');
    print('🔄 [AUTH_PROVIDER] Cambiando estado a isLoading=true');
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('⏳ [AUTH_PROVIDER] Llamando a AuthApiService.updateProfile...');
      final updatedUser = await _authService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        ageRange: ageRange,
      );

      print('✅ [AUTH_PROVIDER] Perfil actualizado: ${updatedUser.firstName} ${updatedUser.lastName}');
      state = AuthState(
        user: updatedUser,
        isAuthenticated: true,
        isLoading: false,
      );
      print('🎉 [AUTH_PROVIDER] === PERFIL ACTUALIZADO ===\n');
      return true;
    } catch (e) {
      print('❌ [AUTH_PROVIDER] Error actualizando perfil: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      print('❌ [AUTH_PROVIDER] === ERROR ACTUALIZANDO PERFIL ===\n');
      return false;
    }
  }

  // Cambiar contraseña
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    print('\n🔑 [AUTH_PROVIDER] === CAMBIANDO CONTRASEÑA ===');
    print('🔄 [AUTH_PROVIDER] Cambiando estado a isLoading=true');
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('⏳ [AUTH_PROVIDER] Llamando a AuthApiService.changePassword...');
      final result = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      state = state.copyWith(isLoading: false);

      if (result['success'] == true) {
        print('✅ [AUTH_PROVIDER] Contraseña cambiada exitosamente');
        print('🎉 [AUTH_PROVIDER] === CONTRASEÑA CAMBIADA ===\n');
        return true;
      } else {
        print('❌ [AUTH_PROVIDER] Error cambiando contraseña: ${result['error']}');
        state = state.copyWith(error: result['error'] as String?);
        print('❌ [AUTH_PROVIDER] === ERROR CAMBIANDO CONTRASEÑA ===\n');
        return false;
      }
    } catch (e) {
      print('💥 [AUTH_PROVIDER] Excepción cambiando contraseña: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      print('❌ [AUTH_PROVIDER] === ERROR CAMBIANDO CONTRASEÑA ===\n');
      return false;
    }
  }

  // Limpiar error
  void clearError() {
    print('🧹 [AUTH_PROVIDER] Limpiando error del estado');
    state = state.copyWith(error: null);
  }
}

// Provider del AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authApiServiceProvider);
  return AuthNotifier(authService);
});

// Provider para verificar si está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

// Provider para obtener el usuario actual
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

// Provider para obtener el error actual
final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});

// Provider para verificar si está cargando
final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});
