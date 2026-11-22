import 'package:flame/components.dart';
import 'package:material_ui/material_ui.dart';

import '../game.dart';
import '../utils.dart';

class Foreground extends Component with HasGameReference<MyGame> {
  static const double borderWidth = 3.0;
  static const double dashWidth = 8.0;
  static const double dashSpace = 10.0;

  final Paint _borderPaint = Paint()
    ..color = GameColors.courtBorder
    ..style = PaintingStyle.stroke
    ..strokeWidth = borderWidth;

  final Paint _netPaint = Paint()
    ..color = GameColors.courtNet
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  @override
  void render(Canvas canvas) {
    final size = game.size;
    final courtRect = Rect.fromLTWH(
      borderWidth / 2,
      borderWidth / 2,
      size.x - borderWidth,
      size.y - borderWidth,
    );

    canvas.drawRect(courtRect, _borderPaint);

    if (game.mode == GameMode.solo) {
      final topGoalPaint = Paint()
        ..color = GameColors.courtNet
        ..strokeWidth = 2.0;
      canvas.drawLine(Offset(0, 10), Offset(size.x, 10), topGoalPaint);
    } else {
      final centerX = size.x / 2;
      double startY = 8.0;
      while (startY < size.y - 8.0) {
        canvas.drawLine(
          Offset(centerX, startY),
          Offset(centerX, (startY + dashWidth).clamp(0, size.y - 8.0)),
          _netPaint,
        );
        startY += dashWidth + dashSpace;
      }

      final centerCirclePaint = Paint()
        ..color = GameColors.courtNet.withAlpha(80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        48.0,
        centerCirclePaint,
      );
    }
  }
}
