import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  final String time;

  const StatusBar({
    super.key,
    this.time = '9:41',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 53,
      color: isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Side - Time
            Expanded(
              child: Center(
                child: Container(
                  height: 21,
                  width: 54,
                  alignment: Alignment.center,
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black,
                      letterSpacing: -0.408,
                    ),
                  ),
                ),
              ),
            ),
            // Dynamic Island
            const _DynamicIsland(),
            // Right Side - Signal, Wifi, Battery
            const Expanded(
              child: _StatusBarIcons(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      width: 125,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Stack(
        children: [
          // TrueDepth camera
          Positioned(
            left: 28,
            top: 0,
            bottom: 0,
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          // FaceTime camera
          Positioned(
            right: 28,
            top: 0,
            bottom: 0,
            child: Container(
              width: 37,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBarIcons extends StatelessWidget {
  const _StatusBarIcons();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final iconColor = isDark ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Signal
        _SignalIcon(color: iconColor),
        const SizedBox(width: 8),
        // Wifi
        _WifiIcon(color: iconColor),
        const SizedBox(width: 8),
        // Battery
        _BatteryIcon(color: iconColor),
      ],
    );
  }
}

class _SignalIcon extends StatelessWidget {
  final Color color;

  const _SignalIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(18, 12),
      painter: _SignalPainter(color: color),
    );
  }
}

class _SignalPainter extends CustomPainter {
  final Color color;

  _SignalPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final barWidth = 3.0;
    final gap = 2.0;

    // Draw 4 bars
    for (int i = 0; i < 4; i++) {
      final height = 4.0 + (i * 2.0);
      final x = i * (barWidth + gap);
      final y = size.height - height;
      canvas.drawRect(Rect.fromLTWH(x, y, barWidth, height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WifiIcon extends StatelessWidget {
  final Color color;

  const _WifiIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(17, 11.83),
      painter: _WifiPainter(color: color),
    );
  }
}

class _WifiPainter extends CustomPainter {
  final Color color;

  _WifiPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Draw 3 arcs
    for (int i = 0; i < 3; i++) {
      final arcRadius = radius * (0.4 + (i * 0.3));
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: arcRadius),
        0,
        3.14159,
        false,
        paint,
      );
    }

    // Center dot
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BatteryIcon extends StatelessWidget {
  final Color color;

  const _BatteryIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(27.4, 13),
      painter: _BatteryPainter(color: color),
    );
  }
}

class _BatteryPainter extends CustomPainter {
  final Color color;

  _BatteryPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Battery outline
    final outlineRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, 25, 13),
      const Radius.circular(3),
    );
    canvas.drawRRect(outlineRect, paint);

    // Battery end (positive terminal)
    final endPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(25.5, 4.5, 1.4, 4),
      endPaint,
    );

    // Battery fill (80%)
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(2, 2, 21, 9),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
