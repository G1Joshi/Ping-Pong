import 'package:material_ui/material_ui.dart';

import 'package:flame/components.dart';

import '../game.dart';
import '../utils.dart';

class Foreground extends Component with HasGameReference<MyGame> {
  static const double width = 4.0;
  late Rect gameRect;
  final Rect rect = Vector2.zero() & Vector2(width / 2, width);
  final Paint mid = Paint()..color = Colors.white;
  final Paint front = Paint()
    ..color = Colors.white
    ..strokeWidth = width
    ..style = PaintingStyle.stroke;

  @override
  void onGameResize(Vector2 size) {
    gameRect = Vector2.zero() & game.size;
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    if (game.mode == GameMode.multiple) {
      canvas
        ..save()
        ..drawRect(gameRect, front)
        ..translate(game.size.x / 2 - rect.width / 2, width / 2);
      for (var i = 0; i < game.size.y / width; i++) {
        canvas
          ..drawRect(rect, mid)
          ..translate(0, width * 2);
      }
    } else {
      canvas
        ..save()
        ..drawRect(gameRect, front);
    }
    canvas.restore();
  }
}
