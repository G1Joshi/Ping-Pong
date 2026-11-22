import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:material_ui/material_ui.dart';

import '../utils.dart';

class MenuButton extends PositionComponent with TapCallbacks {
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTapCallback;

  MenuButton({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTapCallback,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  void onTapDown(TapDownEvent event) {
    event.continuePropagation = false;
    onTapCallback();
  }

  @override
  void render(Canvas canvas) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(10.0),
    );

    final bgPaint = Paint()..color = GameColors.buttonBg;
    canvas.drawRRect(rrect, bgPaint);

    final stripRRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, 6.0, size.y),
      topLeft: const Radius.circular(10.0),
      bottomLeft: const Radius.circular(10.0),
    );
    final stripPaint = Paint()..color = accentColor;
    canvas.drawRRect(stripRRect, stripPaint);

    final borderPaint = Paint()
      ..color = GameColors.buttonHover
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(rrect, borderPaint);

    final titlePaint = TextPaint(
      style: TextStyle(
        fontSize: (size.y * 0.35).clamp(14.0, 18.0),
        fontWeight: FontWeight.w800,
        color: GameColors.textLight,
      ),
    );

    final subtitlePaint = TextPaint(
      style: TextStyle(
        fontSize: (size.y * 0.25).clamp(10.0, 13.0),
        fontWeight: FontWeight.w500,
        color: GameColors.textMuted,
      ),
    );

    titlePaint.render(canvas, title, Vector2(18.0, size.y * 0.22));

    subtitlePaint.render(canvas, subtitle, Vector2(18.0, size.y * 0.58));
  }
}

class Mode extends MenuButton {
  Mode.single()
    : super(
        title: 'Single Player',
        subtitle: 'Press 1 or Tap',
        accentColor: GameColors.player2,
        onTapCallback: () {},
        position: Vector2.zero(),
        size: Vector2(180, 50),
      );

  Mode.multiple()
    : super(
        title: 'Two Players',
        subtitle: 'Press 2 or Tap',
        accentColor: GameColors.player1,
        onTapCallback: () {},
        position: Vector2.zero(),
        size: Vector2(180, 50),
      );
}
