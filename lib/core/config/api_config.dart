class ApiConfig {
  // Cambia esta URL según tu configuración del backend
  static const String baseUrl = 'http://apis-gagalom-irihu3-d97289-190-166-109-120.traefik.me';

  // Endpoints
  static const String authPath = '/api/auth';
  static const String paymentsPath = '/api/payments';
  static const String ordersPath = '/api/orders';

  // Auth endpoints
  static const String registerEndpoint = '$authPath/register';
  static const String loginEndpoint = '$authPath/login';
  static const String logoutEndpoint = '$authPath/logout';
  static const String profileEndpoint = '$authPath/me';
  static const String updateProfileEndpoint = '$authPath/profile';
  static const String changePasswordEndpoint = '$authPath/change-password';

  // Payment endpoints
  static const String createPaymentIntentEndpoint = '$paymentsPath/create-intent';
  static const String confirmPaymentEndpoint = '$paymentsPath/confirm';

  // Order endpoints
  static const String getOrdersEndpoint = ordersPath;
  static String getOrderDetailsEndpoint(String orderId) => '$ordersPath/$orderId';

  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
