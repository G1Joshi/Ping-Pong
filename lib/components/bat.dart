import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:material_ui/material_ui.dart';

import '../game.dart';
import '../utils.dart';

enum BatSide { left, right, bottom }

class Bat extends PositionComponent
    with HasGameReference<MyGame>, DragCallbacks, CollisionCallbacks {
  final BatSide side;
  final bool isAi;
  final Color color;

  double movementDirection = 0.0;

  Bat({required this.side, required this.color, this.isAi = false})
    : super(anchor: Anchor.center);

  factory Bat.left({bool isAi = false}) =>
      Bat(side: BatSide.left, color: GameColors.player2, isAi: isAi);

  factory Bat.right() =>
      Bat(side: BatSide.right, color: GameColors.player1, isAi: false);

  factory Bat.bottom() =>
      Bat(side: BatSide.bottom, color: GameColors.player2, isAi: false);

  factory Bat.solo(Vector2 gameSize) => Bat.bottom();
  factory Bat.top(Vector2 gameSize, GameMode mode) => Bat.right();
  factory Bat.down(Vector2 gameSize, GameMode mode) => Bat.left();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _recalculateSizeAndPosition();
    add(RectangleHitbox());
  }

  void _recalculateSizeAndPosition() {
    final gameSize = game.size;
    if (side == BatSide.bottom) {
      final width = (gameSize.x * GameConfig.soloPaddleWidthRatio).clamp(
        80.0,
        180.0,
      );
      final height = GameConfig.paddleWidth;
      size.setValues(width, height);
      position.setValues(gameSize.x / 2, gameSize.y - 28.0);
    } else if (side == BatSide.left) {
      final width = GameConfig.paddleWidth;
      final height = (gameSize.y * GameConfig.paddleHeightRatio).clamp(
        70.0,
        160.0,
      );
      size.setValues(width, height);
      position.setValues(24.0, gameSize.y / 2);
    } else {
      final width = GameConfig.paddleWidth;
      final height = (gameSize.y * GameConfig.paddleHeightRatio).clamp(
        70.0,
        160.0,
      );
      size.setValues(width, height);
      position.setValues(gameSize.x - 24.0, gameSize.y / 2);
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _recalculateSizeAndPosition();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isAi && game.state == GameState.playing) {
      _updateAiMovement(dt);
    } else if (movementDirection != 0.0) {
      final speed = GameConfig.paddleSpeed;
      if (side == BatSide.bottom) {
        position.x += movementDirection * speed * dt;
      } else {
        position.y += movementDirection * speed * dt;
      }
    }

    _clampPosition();
  }

  void _updateAiMovement(double dt) {
    final ball = game.ball;
    if (ball == null) return;
    if (ball.velocity.x < 0) {
      final targetY = ball.position.y;
      final diff = targetY - position.y;
      if (diff.abs() > 10.0) {
        final dir = diff.sign;
        position.y += dir * GameConfig.aiSpeed * dt;
      }
    } else {
      final centerY = game.size.y / 2;
      final diff = centerY - position.y;
      if (diff.abs() > 20.0) {
        position.y += diff.sign * (GameConfig.aiSpeed * 0.4) * dt;
      }
    }
  }

  void _clampPosition() {
    final gameSize = game.size;
    if (side == BatSide.bottom) {
      final halfWidth = size.x / 2;
      position.x = position.x.clamp(
        halfWidth + 6.0,
        gameSize.x - halfWidth - 6.0,
      );
    } else {
      final halfHeight = size.y / 2;
      position.y = position.y.clamp(
        halfHeight + 6.0,
        gameSize.y - halfHeight - 6.0,
      );
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (side == BatSide.bottom) {
      position.x += event.canvasDelta.x;
    } else {
      position.y += event.canvasDelta.y;
    }
    _clampPosition();
  }

  @override
  void render(Canvas canvas) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(6.0),
    );

    final paint = Paint()..color = color;
    canvas.drawRRect(rrect, paint);

    final highlightPaint = Paint()
      ..color = Colors.white.withAlpha(70)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(rrect, highlightPaint);
  }
}
