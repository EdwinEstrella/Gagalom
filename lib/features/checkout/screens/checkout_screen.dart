import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String? _shippingAddress;
  String? _paymentMethod;

  // Sample data
  double subtotal = 200;
  double shippingCost = 8.00;
  double tax = 0.00;
  double get total => subtotal + shippingCost + tax;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 74),

                  // Header
                  Center(
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: 49),

                  // Shipping Address
                  _buildShippingAddress(theme),

                  const SizedBox(height: 16),

                  // Payment Method
                  _buildPaymentMethod(theme),

                  const SizedBox(height: 150),

                  // Payment Info
                  _buildPaymentInfo(theme),

                  const SizedBox(height: 120),
                ],
              ),
            ),

            // Back Button
            Positioned(
              top: 63,
              left: 27,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            // Place Order Button
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: _buildPlaceOrderButton(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingAddress(ThemeData theme) {
    return GestureDetector(
      onTap: () => _showAddressBottomSheet(theme),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Shipping Address',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _shippingAddress ?? 'Add Shipping Address',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                      fontWeight: _shippingAddress != null ? FontWeight.normal : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: theme.colorScheme.onSurface,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(ThemeData theme) {
    return GestureDetector(
      onTap: () => _showPaymentBottomSheet(theme),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _paymentMethod ?? 'Add Payment Method',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: theme.colorScheme.onSurface,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildPaymentRow(theme, 'Subtotal', '\$${subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 12),
          _buildPaymentRow(theme, 'Shipping Cost', '\$${shippingCost.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildPaymentRow(theme, 'Tax', '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildPaymentRow(
            theme,
            'Total',
            '\$${total.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(ThemeData theme, String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          _showOrderPlacedDialog(theme);
        },
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddressBottomSheet(ThemeData theme) {
    final addresses = [
      '2715 Ash Dr. San Jose, South Dakota 83475',
      '1234 Main St. New York, NY 10001',
      '5678 Oak Ave. Los Angeles, CA 90001',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 500,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Address',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: addresses.length + 1,
                  itemBuilder: (context, index) {
                    if (index < addresses.length) {
                      final address = addresses[index];
                      final isSelected = _shippingAddress == address;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _shippingAddress = address;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              address,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            // Add new address
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '+ Add New Address',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentBottomSheet(ThemeData theme) {
    final paymentMethods = [
      {'name': '**** 4187', 'icon': Icons.credit_card},
      {'name': 'PayPal', 'icon': Icons.account_balance_wallet},
      {'name': 'Apple Pay', 'icon': Icons.phone_iphone},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 500,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Payment',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: paymentMethods.length + 1,
                  itemBuilder: (context, index) {
                    if (index < paymentMethods.length) {
                      final method = paymentMethods[index];
                      final name = method['name'] as String;
                      final icon = method['icon'] as IconData;
                      final isSelected = _paymentMethod == name;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _paymentMethod = name;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(icon, color: theme.colorScheme.onSurface),
                                const SizedBox(width: 16),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const Spacer(),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: theme.colorScheme.primary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            // Add new payment method
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '+ Add New Payment Method',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOrderPlacedDialog(ThemeData theme) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 48,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Order Placed Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You will receive an email confirmation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text('Continue Shopping'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          // Navigate to orders
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text('View Order'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
