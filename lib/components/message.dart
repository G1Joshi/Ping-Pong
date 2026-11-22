import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:material_ui/material_ui.dart';

import '../game.dart';
import '../utils.dart';

class Message extends PositionComponent
    with HasGameReference<MyGame>, TapCallbacks {
  String text;
  final String? subtext;

  Message(this.text, {this.subtext}) : super(anchor: Anchor.center);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position.setValues(game.size.x / 2, game.size.y * 0.68);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (game.state == GameState.ready) {
      game.startPlaying();
    } else if (game.state == GameState.gameOver) {
      game.replayCurrentMode();
    }
  }

  @override
  void render(Canvas canvas) {
    final titlePaint = TextPaint(
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: GameColors.textLight,
        shadows: [
          Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
    );

    titlePaint.render(canvas, text, Vector2.zero(), anchor: Anchor.center);

    if (subtext != null && subtext!.isNotEmpty) {
      final subPaint = TextPaint(
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: GameColors.textMuted,
        ),
      );
      subPaint.render(canvas, subtext!, Vector2(0, 28), anchor: Anchor.center);
    }
  }
}
