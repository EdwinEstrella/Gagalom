import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/stripe_service.dart';

class StripeNotifier extends StateNotifier<Map<String, dynamic>?> {
  final StripeService _stripeService;

  StripeNotifier(this._stripeService) : super(null);

  // Crear Payment Intent
  Future<Map<String, dynamic>?> createPaymentIntent({
    required double amount,
    String currency = 'usd',
    List<Map<String, dynamic>>? items,
  }) async {
    state = {'loading': true};

    try {
      final result = await _stripeService.createPaymentIntent(
        amount: amount,
        currency: currency,
        items: items,
      );

      state = result;
      return result;
    } catch (e) {
      state = {'error': e.toString()};
      return null;
    }
  }

  // Confirmar pago
  Future<Map<String, dynamic>?> confirmPayment({
    required String paymentIntentId,
    required List<Map<String, dynamic>> items,
    Map<String, dynamic>? shippingAddress,
  }) async {
    state = {'loading': true};

    try {
      final result = await _stripeService.confirmPayment(
        paymentIntentId: paymentIntentId,
        items: items,
        shippingAddress: shippingAddress,
      );

      state = result;
      return result;
    } catch (e) {
      state = {'error': e.toString()};
      return null;
    }
  }

  // Limpiar estado
  void clearState() {
    state = null;
  }
}

// Provider del servicio de Stripe
final stripeServiceProvider = Provider<StripeService>((ref) {
  return StripeService();
});

// Provider del StripeNotifier
final stripeProvider = StateNotifierProvider<StripeNotifier, Map<String, dynamic>?>((ref) {
  final stripeService = ref.watch(stripeServiceProvider);
  return StripeNotifier(stripeService);
});

// Provider para obtener las órdenes
final ordersProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final stripeService = ref.watch(stripeServiceProvider);
  return await stripeService.getOrders();
});
