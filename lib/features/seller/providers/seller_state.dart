part of 'seller_provider.dart';

class SellerState {
  final bool hasPendingRequest;
  final bool isApproved;
  final bool isRejected;
  final String? rejectionReason;
  final bool isLoading;
  final String? error;

  const SellerState({
    this.hasPendingRequest = false,
    this.isApproved = false,
    this.isRejected = false,
    this.rejectionReason,
    this.isLoading = false,
    this.error,
  });

  SellerState copyWith({
    bool? hasPendingRequest,
    bool? isApproved,
    bool? isRejected,
    String? rejectionReason,
    bool? isLoading,
    String? error,
  }) {
    return SellerState(
      hasPendingRequest: hasPendingRequest ?? this.hasPendingRequest,
      isApproved: isApproved ?? this.isApproved,
      isRejected: isRejected ?? this.isRejected,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  String toString() {
    return 'SellerState(hasPendingRequest: $hasPendingRequest, isApproved: $isApproved, isRejected: $isRejected, rejectionReason: $rejectionReason, isLoading: $isLoading, error: $error)';
  }
}
