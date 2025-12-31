import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../checkout/screens/checkout_screen.dart';

class CartItem {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String size;
  final String color;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.size,
    required this.color,
    this.quantity = 1,
  });

  double get totalPrice => double.parse(price.replaceAll('\$', '')) * quantity;
}

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      name: "Men's Harrington Jacket",
      price: '\$148',
      imageUrl: 'assets/images/products/hoodies/harrington_jacket.jpg', // Ensure this exists or map to available one
      size: 'M',
      color: 'Lemon',
      quantity: 1,
    ),
    CartItem(
      id: '2',
      name: "Men's Coaches Jacket",
      price: '\$52.00',
      imageUrl: 'assets/images/products/hoodies/coaches_jacket.jpg',
      size: 'M',
      color: 'Black',
      quantity: 1,
    ),
  ];

  double get subtotal => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  double get shippingCost => 8.00;
  double get tax => 0.00;
  double get total => subtotal + shippingCost + tax;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_cartItems.isEmpty) {
      return _buildEmptyCart(theme);
    }

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
                      'Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: 29),

                  // Remove All
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _cartItems.clear();
                        });
                      },
                      child: Text(
                        'Remove All',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Cart Items List
                  ...List.generate(_cartItems.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                      child: _buildCartItem(theme, _cartItems[index]),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Payment Info
                  _buildPaymentInfo(theme),

                  const SizedBox(height: 24),

                  // Promo Code
                  _buildPromoCode(theme),

                  const SizedBox(height: 40), // Spacing for bottom bar
                ],
              ),
            ),

            // Back Button
            Positioned(
              top: 8,
              left: 24,
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
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: _buildCheckoutButton(theme),
      ),
    );
  }

  Widget _buildEmptyCart(ThemeData theme) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 100,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 27),
                  Text(
                    'Your Cart is Empty',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 27),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text('Explore Categories'),
                  ),
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(ThemeData theme, CartItem item) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: item.imageUrl.startsWith('http')
                    ? NetworkImage(item.imageUrl) as ImageProvider
                    : AssetImage(item.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                          height: 1.6,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      item.price,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Size, Color, and Quantity Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Size and Color
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            children: [
                              const TextSpan(text: 'Size'),
                              const TextSpan(text: ' - '),
                              TextSpan(
                                text: item.size,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            children: [
                              const TextSpan(text: 'Color'),
                              const TextSpan(text: ' - '),
                              TextSpan(
                                text: item.color,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Quantity Controls
                    Row(
                      children: [
                        // Minus Button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (item.quantity > 1) item.quantity--;
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.remove,
                              size: 12,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Plus Button
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              item.quantity++;
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 12,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildPromoCode(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.discount_outlined,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Enter Coupon Code',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                height: 1.6,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CheckoutScreen(),
            ),
          );
        },
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            'Checkout',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
