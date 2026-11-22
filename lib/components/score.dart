import 'package:flame/components.dart';
import 'package:material_ui/material_ui.dart';

import '../game.dart';
import '../utils.dart';

class Score extends TextComponent with HasGameReference<MyGame> {
  Score.mid(GameMode mode)
    : player = 0,
      textPaint = TextPaint(
        style: const TextStyle(
          fontSize: 60,
          color: Colors.green,
          fontWeight: FontWeight.w900,
        ),
      );
  Score.right(GameMode mode)
    : player = 1,
      textPaint = TextPaint(
        style: const TextStyle(
          fontSize: 60,
          color: Colors.blue,
          fontWeight: FontWeight.w900,
        ),
      );
  Score.left(GameMode mode)
    : player = 2,
      textPaint = TextPaint(
        style: const TextStyle(
          fontSize: 60,
          color: Colors.green,
          fontWeight: FontWeight.w900,
        ),
      );

  final TextPaint textPaint;
  final int player;
  int score = 0;

  @override
  void onGameResize(Vector2 size) {
    if (game.mode == GameMode.multiple) {
      position.setValues(player == 1 ? game.size.x / 3 : game.size.x / 1.5, 40);
    } else {
      position.setValues(game.size.x / 2, 40);
    }
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    textPaint.render(canvas, '$score', Vector2.zero(), anchor: Anchor.center);
  }
}
