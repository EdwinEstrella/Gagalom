import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/seller_api_service.dart';
import '../../../core/services/auth_api_service.dart';

part 'seller_state.dart';

// Provider del servicio API
final sellerApiServiceProvider = Provider<SellerApiService>((ref) {
  return SellerApiService();
});

// Provider del estado de vendedor
class SellerNotifier extends StateNotifier<SellerState> {
  final SellerApiService _sellerService;

  SellerNotifier(this._sellerService) : super(const SellerState()) {
    _checkExistingRequest();
  }

  // Verificar si ya existe una solicitud
  Future<void> _checkExistingRequest() async {
    try {
      final request = await _sellerService.getMySellerRequest();

      if (request != null) {
        state = SellerState(
          hasPendingRequest: request['status'] == 'pending',
          isApproved: request['status'] == 'approved',
          isRejected: request['status'] == 'rejected',
          rejectionReason: request['rejectionReason'],
          isLoading: false,
        );
      }
    } catch (e) {
      // No hay solicitud o error
      state = const SellerState(isLoading: false);
    }
  }

  // Enviar solicitud de vendedor
  Future<bool> submitSellerRequest({
    required String businessName,
    String? businessDescription,
    String? businessType,
    String? taxId,
    required String phone,
    required String address,
    required String city,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _sellerService.createSellerRequest(
        businessName: businessName,
        businessDescription: businessDescription,
        businessType: businessType,
        taxId: taxId,
        phone: phone,
        address: address,
        city: city,
      );

      if (result['success'] == true) {
        state = SellerState(
          hasPendingRequest: true,
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

  // Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider del SellerNotifier
final sellerProvider = StateNotifierProvider<SellerNotifier, SellerState>((ref) {
  final sellerService = ref.watch(sellerApiServiceProvider);
  return SellerNotifier(sellerService);
});
