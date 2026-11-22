import 'package:material_ui/material_ui.dart';

import 'package:flame/components.dart';

import '../game.dart';

class Mode extends TextComponent with HasGameReference<MyGame> {
  Mode.single()
    : player = 'Single\nPress 1',
      textPaint = TextPaint(
        style: const TextStyle(
          fontSize: 30,
          color: Colors.green,
          fontWeight: FontWeight.w900,
        ),
      );
  Mode.multiple()
    : player = 'Multiple\nPress 2',
      textPaint = TextPaint(
        style: const TextStyle(
          fontSize: 30,
          color: Colors.blue,
          fontWeight: FontWeight.w900,
        ),
      );

  final TextPaint textPaint;
  String player;

  @override
  void onGameResize(Vector2 size) {
    position.setValues(player == 'Single\nPress 1' ? 70 : 270, 120);
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    textPaint.render(canvas, player, Vector2.zero(), anchor: Anchor.center);
  }
}
