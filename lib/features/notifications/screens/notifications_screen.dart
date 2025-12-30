import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  // Sample notifications data
  final List<NotificationItem> _notifications = [
    NotificationItem(
      message: 'Gilbert, you placed and order check your order history for full details',
      time: '2 min ago',
    ),
    NotificationItem(
      message: 'Gilbert, Thank you for shopping with us we have canceled order #24568.',
      time: '1 hour ago',
    ),
    NotificationItem(
      message: 'Gilbert, your Order #24568 has been confirmed check your order history for full details',
      time: '2 hours ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 71),

              // Title
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 59),

              // Notifications List
              if (_notifications.isEmpty)
                _buildEmptyState(context)
              else
                ..._notifications.asMap().entries.map((entry) {
                  final index = entry.key;
                  final notification = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < _notifications.length - 1 ? 8 : 200,
                    ),
                    child: _buildNotificationCard(context, notification),
                  );
                }),

              if (_notifications.isEmpty) const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem notification,
  ) {
    final theme = Theme.of(context);

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Notification Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),

          const SizedBox(width: 21),

          // Message
          Expanded(
            child: Text(
              notification.message,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface,
                height: 1.6,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 130),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications_outlined,
            size: 50,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'No Notification yet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 54),
        SizedBox(
          width: 185,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              // Navigate back to home - functionality placeholder
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text('Explore Categories'),
          ),
        ),
      ],
    );
  }
}

class NotificationItem {
  final String message;
  final String time;

  NotificationItem({
    required this.message,
    required this.time,
  });
}
