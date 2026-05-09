import 'dart:ui';

import 'package:flutter/material.dart';
class SVideoRevealClipper extends CustomClipper<Path> {
  final double progress;

  const SVideoRevealClipper({required this.progress});

  Path _buildSCenterPath(Size size) {
    final w = size.width;
    final h = size.height;

    // Single centerline S — two cubics, top-right to bottom-left
    return Path()
      ..moveTo(w * 0.75, h * 0.08)
      ..cubicTo(
        w * 0.10, h * 0.04, // pull hard upper-left
        w * 0.02, h * 0.44, // anchor left-middle
        w * 0.50, h * 0.50, // center crossover
      )
      ..cubicTo(
        w * 0.98, h * 0.56, // pull hard lower-right
        w * 0.90, h * 0.96, // anchor right-bottom
        w * 0.25, h * 0.92, // end bottom-left
      );
  }

  @override
  Path getClip(Size size) {
    final p = Curves.easeOutCubic.transform(progress.clamp(0.0, 1.0));

    final centerPath = _buildSCenterPath(size);
    final metrics = centerPath.computeMetrics().toList();
    if (metrics.isEmpty) return Path();

    final metric = metrics.first;
    final drawLength = metric.length * p;
    if (drawLength < 1) return Path();

    // Half the stroke width — increase this to make the S fatter/bigger
    final halfW = size.width * 0.15;
    const samples = 120;

    final leftPts = <Offset>[];
    final rightPts = <Offset>[];

    for (int i = 0; i <= samples; i++) {
      final dist = (i / samples) * drawLength;
      if (dist > metric.length) break;

      final tangent = metric.getTangentForOffset(dist);
      if (tangent == null) continue;

      final pos = tangent.position;
      final vec = tangent.vector;

      // Normal is perpendicular to the tangent direction
      final normal = Offset(-vec.dy, vec.dx);

      leftPts.add(pos + normal * halfW);
      rightPts.add(pos - normal * halfW);
    }

    if (leftPts.length < 2) return Path();

    final result = Path();

    // Rounded start cap — arc from right to left side at the tip start
    result.moveTo(rightPts.first.dx, rightPts.first.dy);
    result.arcToPoint(
      leftPts.first,
      radius: Radius.circular(halfW),
      clockwise: false,
    );

    // Left offset side — draws forward along S
    for (int i = 1; i < leftPts.length; i++) {
      result.lineTo(leftPts[i].dx, leftPts[i].dy);
    }

    // Rounded end cap at the current drawing tip
    result.arcToPoint(
      rightPts.last,
      radius: Radius.circular(halfW),
      clockwise: true,
    );

    // Right offset side — traces backward to close the shape
    for (int i = rightPts.length - 2; i >= 0; i--) {
      result.lineTo(rightPts[i].dx, rightPts[i].dy);
    }

    result.close();
    return result;
  }

  @override
  bool shouldReclip(covariant SVideoRevealClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
class SBrandRibbonPainter extends CustomPainter {
  final double progress;
  final Color color;

  const SBrandRibbonPainter({
    required this.progress,
    this.color = const Color(0xFF171820),
  });

  Path _buildSPath(Size size) {
    final w = size.width;
    final h = size.height;

    return Path()
      ..moveTo(w * 0.95, h * 0.26)
      ..cubicTo(
        w * 0.76,
        h * 0.17,
        w * 0.49,
        h * 0.18,
        w * 0.42,
        h * 0.34,
      )
      ..cubicTo(
        w * 0.35,
        h * 0.51,
        w * 0.72,
        h * 0.47,
        w * 0.72,
        h * 0.62,
      )
      ..cubicTo(
        w * 0.72,
        h * 0.77,
        w * 0.32,
        h * 0.78,
        w * 0.14,
        h * 0.58,
      );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final p = Curves.easeOutCubic.transform(progress.clamp(0.0, 1.0));
    final path = _buildSPath(size);

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final metric = metrics.first;
    final visiblePath = metric.extractPath(0, metric.length * p);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(visiblePath, paint);
  }

  @override
  bool shouldRepaint(covariant SBrandRibbonPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class PremiumSWipePainter extends CustomPainter {
  final double progress;

  const PremiumSWipePainter({
    required this.progress,
  });

  Path _buildWipePath(Size size) {
    final w = size.width;
    final h = size.height;

    return Path()
      ..moveTo(w * 1.18, -h * 0.08)
      ..cubicTo(
        w * 0.62,
        h * 0.02,
        w * 0.12,
        h * 0.12,
        w * 0.20,
        h * 0.34,
      )
      ..cubicTo(
        w * 0.30,
        h * 0.58,
        w * 0.92,
        h * 0.42,
        w * 0.86,
        h * 0.68,
      )
      ..cubicTo(
        w * 0.80,
        h * 0.94,
        w * 0.18,
        h * 1.04,
        -w * 0.10,
        h * 0.78,
      );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final p = Curves.easeInOutCubic.transform(progress.clamp(0.0, 1.0));

    if (p < 0.58) {
      final wipeProgress = (p / 0.58).clamp(0.0, 1.0);
      final path = _buildWipePath(size);

      final paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = lerpDouble(size.width * 0.18, size.width * 1.9, wipeProgress)!
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true;

      canvas.drawPath(path, paint);
    } else {
      final fadeProgress = ((p - 0.58) / 0.42).clamp(0.0, 1.0);
      final opacity = 1.0 - fadeProgress;

      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawRect(Offset.zero & size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PremiumSWipePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}