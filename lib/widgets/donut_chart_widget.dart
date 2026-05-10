import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/app_styles.dart';
import '../utils/currency_formatter.dart';

class DonutChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final double total;

  const DonutChartWidget({
    super.key,
    required this.data,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(200, 200),
            painter: _DonutPainter(data: data),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total Pengeluaran',
                style: TextStyle(fontSize: 10, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatterHelper.formatRupiah(total),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final Map<String, double> data;

  _DonutPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final thickness = radius * 0.25;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    double totalValue = data.values.fold(0, (sum, value) => sum + value);
    if (totalValue == 0) {
      paint.color = AppColors.border.withOpacity(0.5);
      canvas.drawCircle(center, radius - thickness / 2, paint);
      return;
    }

    double startAngle = -pi / 2;
    final colors = [
      AppColors.accent,
      Colors.orange,
      Colors.blue,
      Colors.purple,
      Colors.red,
      Colors.indigo,
      Colors.teal,
    ];

    int i = 0;
    data.forEach((key, value) {
      final sweepAngle = (value / totalValue) * 2 * pi;
      paint.color = colors[i % colors.length];
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - thickness / 2),
        startAngle,
        sweepAngle - (data.length > 1 ? 0.05 : 0), // Small gap
        false,
        paint,
      );
      
      startAngle += sweepAngle;
      i++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
