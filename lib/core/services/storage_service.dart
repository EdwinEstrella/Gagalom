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
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // Obtener token de acceso
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Eliminar token de acceso
  static Future<void> removeAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  // Guardar información del usuario
  static Future<void> saveUserInfo({
    required String userId,
    required String email,
    String? firstName,
    String? lastName,
  }) async {
    await Future.wait([
      _storage.write(key: _userIdKey, value: userId),
      _storage.write(key: _userEmailKey, value: email),
      if (firstName != null) _storage.write(key: _userNameKey, value: firstName),
    ]);
  }

  // Obtener ID del usuario
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  // Obtener email del usuario
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  // Obtener nombre del usuario
  static Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }

  // Verificar si el token está expirado
  static Future<bool> isTokenExpired() async {
    final token = await getAccessToken();
    if (token == null) return true;

    try {
      // Decodificar el JWT manualmente (formato: header.payload.signature)
      final parts = token.split('.');
      if (parts.length != 3) return true;

      // Decodificar el payload (parte central)
      final payload = _decodeBase64(parts[1]);

      // Obtener la fecha de expiración
      final exp = payload['exp'];
      if (exp == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
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
    await _storage.deleteAll();
  }

  // Verificar si el usuario está autenticado
  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    if (token == null) return false;

    final expired = await isTokenExpired();
    return !expired;
  }
}
