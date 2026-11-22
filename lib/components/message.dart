import 'package:material_ui/material_ui.dart';

import 'package:flame/components.dart';

import '../game.dart';

class Message extends TextComponent with HasGameReference<MyGame> {
  Message(String msg) {
    text = msg;
    anchor = Anchor.center;
    textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    position.setValues(game.size.x / 2, game.size.y / 1.3);
    super.onGameResize(size);
  }
}
