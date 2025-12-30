import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Processing', 'Shipped', 'Delivered', 'Returned', 'Cancel'];

  // Sample orders data
  final List<OrderItem> _orders = [
    OrderItem(
      orderNumber: '#456765',
      itemCount: 2,
    ),
    OrderItem(
      orderNumber: '#454569',
      itemCount: 2,
    ),
    OrderItem(
      orderNumber: '#454809',
      itemCount: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate back (optional, since we have tab bar)
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tab Bar
          _buildTabBar(context),

          const SizedBox(height: 16),

          // Orders List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildOrderCard(context, _orders[index]);
              },
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = _selectedTab == index;

            return Padding(
              padding: EdgeInsets.only(
                right: index < _tabs.length - 1 ? 8 : 0,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTab = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Colors.black
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderItem order) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Navigate to order details (can be expanded later)
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Document Icon
            Icon(
              Icons.description_outlined,
              size: 24,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),

            const SizedBox(width: 16),

            // Order Number
            Expanded(
              child: Text(
                'Order ${order.orderNumber}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            // Item Count
            Text(
              '${order.itemCount} items',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),

            const SizedBox(width: 8),

            // Chevron
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem {
  final String orderNumber;
  final int itemCount;

  OrderItem({
    required this.orderNumber,
    required this.itemCount,
  });
}