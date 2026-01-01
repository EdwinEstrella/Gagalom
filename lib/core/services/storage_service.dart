import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Keys
  static const String _accessTokenKey = 'access_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  // Guardar token de acceso
  static Future<void> saveAccessToken(String token) async {
    print('💾 [STORAGE] Guardando access token...');
    print('🔑 [STORAGE] Token: ${token.substring(0, 20)}... (${token.length} caracteres)');
    await _storage.write(key: _accessTokenKey, value: token);
    print('✅ [STORAGE] Access token guardado exitosamente');
  }

  // Obtener token de acceso
  static Future<String?> getAccessToken() async {
    print('🔍 [STORAGE] Leyendo access token...');
    final token = await _storage.read(key: _accessTokenKey);
    if (token != null) {
      print('✅ [STORAGE] Token encontrado: ${token.substring(0, 20)}... (${token.length} caracteres)');
    } else {
      print('⚠️  [STORAGE] No hay token almacenado');
    }
    return token;
  }

  // Eliminar token de acceso
  static Future<void> removeAccessToken() async {
    print('🗑️  [STORAGE] Eliminando access token...');
    await _storage.delete(key: _accessTokenKey);
    print('✅ [STORAGE] Access token eliminado');
  }

  // Guardar información del usuario
  static Future<void> saveUserInfo({
    required String userId,
    required String email,
    String? firstName,
    String? lastName,
  }) async {
    print('\n💾 [STORAGE] === GUARDANDO INFO DE USUARIO ===');
    print('👤 [STORAGE] User ID: $userId');
    print('📧 [STORAGE] Email: $email');
    print('👤 [STORAGE] Nombre: $firstName $lastName');

    await Future.wait([
      _storage.write(key: _userIdKey, value: userId),
      _storage.write(key: _userEmailKey, value: email),
      if (firstName != null) _storage.write(key: _userNameKey, value: firstName),
    ]);

    print('✅ [STORAGE] Información de usuario guardada exitosamente');
    print('💾 [STORAGE] === INFO GUARDADA ===\n');
  }

  // Obtener ID del usuario
  static Future<String?> getUserId() async {
    print('🔍 [STORAGE] Leyendo User ID...');
    final userId = await _storage.read(key: _userIdKey);
    if (userId != null) {
      print('✅ [STORAGE] User ID encontrado: $userId');
    } else {
      print('⚠️  [STORAGE] User ID no encontrado');
    }
    return userId;
  }

  // Obtener email del usuario
  static Future<String?> getUserEmail() async {
    print('🔍 [STORAGE] Leyendo Email...');
    final email = await _storage.read(key: _userEmailKey);
    if (email != null) {
      print('✅ [STORAGE] Email encontrado: $email');
    } else {
      print('⚠️  [STORAGE] Email no encontrado');
    }
    return email;
  }

  // Obtener nombre del usuario
  static Future<String?> getUserName() async {
    print('🔍 [STORAGE] Leyendo Nombre...');
    final name = await _storage.read(key: _userNameKey);
    if (name != null) {
      print('✅ [STORAGE] Nombre encontrado: $name');
    } else {
      print('⚠️  [STORAGE] Nombre no encontrado');
    }
    return name;
  }

  // Verificar si el token está expirado
  static Future<bool> isTokenExpired() async {
    print('⏰ [STORAGE] Verificando expiración del token...');
    final token = await getAccessToken();
    if (token == null) {
      print('⚠️  [STORAGE] Token no existe, considerado como expirado');
      return true;
    }

    try {
      // Decodificar el JWT manualmente (formato: header.payload.signature)
      final parts = token.split('.');
      if (parts.length != 3) {
        print('❌ [STORAGE] Token con formato inválido, considerado expirado');
        return true;
      }

      // Decodificar el payload (parte central)
      final payload = _decodeBase64(parts[1]);

      // Obtener la fecha de expiración
      final exp = payload['exp'];
      if (exp == null) {
        print('⚠️  [STORAGE] Token sin fecha de expiración (exp), considerado expirado');
        return true;
      }

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();
      final isExpired = now.isAfter(expiryDate);

      print('📅 [STORAGE] Fecha de expiración: $expiryDate');
      print('📅 [STORAGE] Fecha actual: $now');

      if (isExpired) {
        print('⏰ [STORAGE] Token EXPIRADO');
      } else {
        final timeLeft = expiryDate.difference(now);
        print('✅ [STORAGE] Token VÁLODO (resta: ${timeLeft.inMinutes} minutos)');
      }

      return isExpired;
    } catch (e) {
      print('❌ [STORAGE] Error verificando expiración: $e');
      print('⚠️  [STORAGE] Token considerado como expirado debido al error');
      return true;
    }
  }

  // Decodificar base64 URL
  static Map<String, dynamic> _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    final decoded = utf8.decode(base64.decode(output));
    return Map<String, dynamic>.from(json.decode(decoded));
  }

  // Limpiar todos los datos (logout)
  static Future<void> clearAll() async {
    print('\n🗑️  [STORAGE] === LIMPIANDO TODO EL STORAGE ===');
    print('🔥 [STORAGE] Eliminando tokens y datos de usuario...');
    await _storage.deleteAll();
    print('✅ [STORAGE] Storage limpiado completamente');
    print('🗑️  [STORAGE] === LIMPIEZA COMPLETADA ===\n');
  }

  // Verificar si el usuario está autenticado
  static Future<bool> isAuthenticated() async {
    print('\n🔐 [STORAGE] === VERIFICANDO AUTENTICACIÓN ===');
    final token = await getAccessToken();
    if (token == null) {
      print('⚠️  [STORAGE] No hay token, usuario NO autenticado');
      print('🔐 [STORAGE] === VERIFICACIÓN COMPLETADA ===\n');
      return false;
    }

    print('⏳ [STORAGE] Token encontrado, verificando expiración...');
    final expired = await isTokenExpired();
    final isAuthenticated = !expired;

    if (isAuthenticated) {
      print('✅ [STORAGE] Usuario AUTENTICADO');
    } else {
      print('⚠️  [STORAGE] Token expirado, usuario NO autenticado');
    }

    print('🔐 [STORAGE] === VERIFICACIÓN COMPLETADA ===\n');
    return isAuthenticated;
  }
}
