import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user.dart';
import '../../../core/services/auth_api_service.dart';
import '../../../core/services/storage_service.dart';

part 'auth_state.dart';

// Provider del servicio de API
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService();
});

// Provider del estado de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApiService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _initAuth();
  }

  // Inicializar autenticación al iniciar la app
  Future<void> _initAuth() async {
    final isAuthenticated = await StorageService.isAuthenticated();

    if (isAuthenticated) {
      try {
        final user = await _authService.getProfile();
        state = AuthState(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } catch (e) {
        // Si hay error, limpiar y dejar no autenticado
        await StorageService.clearAll();
        state = const AuthState(isAuthenticated: false, isLoading: false);
      }
    } else {
      state = const AuthState(isAuthenticated: false, isLoading: false);
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
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        ageRange: ageRange,
      );

      if (result['success'] == true) {
        state = AuthState(
          user: result['user'] as User,
          isAuthenticated: true,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['error'] as String?,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        state = AuthState(
          user: result['user'] as User,
          isAuthenticated: true,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['error'] as String?,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();
      state = const AuthState(
        isAuthenticated: false,
        isLoading: false,
      );
    } catch (e) {
      // Incluso si hay error, limpiar estado local
      await StorageService.clearAll();
      state = const AuthState(
        isAuthenticated: false,
        isLoading: false,
      );
    }
  }

  // Actualizar perfil
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? gender,
    String? ageRange,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedUser = await _authService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        ageRange: ageRange,
      );

      state = AuthState(
        user: updatedUser,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Cambiar contraseña
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      state = state.copyWith(isLoading: false);

      if (result['success'] == true) {
        return true;
      } else {
        state = state.copyWith(error: result['error'] as String?);
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Limpiar error
  void clearError() {
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
