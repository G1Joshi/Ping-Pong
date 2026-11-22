import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:material_ui/material_ui.dart';

import '../game.dart';
import '../utils.dart';
import 'bat.dart';

class Ball extends CircleComponent
    with HasGameReference<MyGame>, CollisionCallbacks, TapCallbacks {
  Vector2 velocity = Vector2.zero();
  final List<Vector2> _trail = [];
  static const int _maxTrailLength = 6;

  Ball() : super(radius: GameConfig.ballRadius, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    resetToCenter();
    add(CircleHitbox());
  }

  @override
  void onMount() {
    super.onMount();
    resetToCenter();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (game.state != GameState.playing) {
      resetToCenter();
    }
  }

  void resetToCenter() {
    if (game.size.x > 0 && game.size.y > 0) {
      position.setValues(game.size.x / 2, game.size.y / 2);
    }
    velocity = Vector2.zero();
    _trail.clear();
  }

  void launch({bool towardsRight = true}) {
    resetToCenter();
    final speed = GameConfig.initialBallSpeed;
    final angle = getRandomBallAngle;

    if (game.mode == GameMode.solo) {
      final random = Random();
      final dirX = random.nextBool() ? 1.0 : -1.0;
      velocity = Vector2(dirX * cos(pi / 4) * speed, -sin(pi / 4) * speed);
    } else {
      final dir = towardsRight ? 1.0 : -1.0;
      velocity = Vector2(dir * cos(angle) * speed, sin(angle) * speed);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (game.state == GameState.ready || game.state == GameState.menu) {
      game.startPlaying();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state != GameState.playing) {
      if (game.size.x > 0 && game.size.y > 0) {
        position.setValues(game.size.x / 2, game.size.y / 2);
      }
      return;
    }

    _trail.insert(0, position.clone());
    if (_trail.length > _maxTrailLength) {
      _trail.removeLast();
    }

    position += velocity * dt;

    final gameSize = game.size;

    if (game.mode == GameMode.solo) {
      if (position.x - radius <= 0) {
        position.x = radius;
        velocity.x = velocity.x.abs();
      }
      if (position.x + radius >= gameSize.x) {
        position.x = gameSize.x - radius;
        velocity.x = -velocity.x.abs();
      }
      if (position.y - radius <= 0) {
        position.y = radius;
        velocity.y = velocity.y.abs();
      }
      if (position.y - radius >= gameSize.y) {
        game.onSoloMiss();
      }
    } else {
      if (position.y - radius <= 0) {
        position.y = radius;
        velocity.y = velocity.y.abs();
      }
      if (position.y + radius >= gameSize.y) {
        position.y = gameSize.y - radius;
        velocity.y = -velocity.y.abs();
      }
      if (position.x + radius <= 0) {
        game.onScore(scorer: 1);
      }
      if (position.x - radius >= gameSize.x) {
        game.onScore(scorer: 2);
      }
    }
  }

  double _calculateIncreasedSpeed() {
    final currentSpeed = velocity.length;
    return (currentSpeed * GameConfig.ballSpeedMultiplier +
            GameConfig.ballSpeedIncrement)
        .clamp(GameConfig.initialBallSpeed, GameConfig.maxBallSpeed);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (game.state != GameState.playing) return;

    if (other is Bat) {
      final speed = _calculateIncreasedSpeed();

      if (other.side == BatSide.bottom && velocity.y > 0) {
        final relative = (position.x - other.position.x) / (other.size.x / 2);
        final bounceAngle = relative.clamp(-0.85, 0.85) * (pi / 3);

        velocity = Vector2(sin(bounceAngle) * speed, -cos(bounceAngle) * speed);
        position.y = other.position.y - other.size.y / 2 - radius - 1.0;
        game.onSoloHit();
      } else if (other.side == BatSide.left && velocity.x < 0) {
        final relative = (position.y - other.position.y) / (other.size.y / 2);
        final bounceAngle = relative.clamp(-0.85, 0.85) * (pi / 3);

        velocity = Vector2(cos(bounceAngle) * speed, sin(bounceAngle) * speed);
        position.x = other.position.x + other.size.x / 2 + radius + 1.0;
      } else if (other.side == BatSide.right && velocity.x > 0) {
        final relative = (position.y - other.position.y) / (other.size.y / 2);
        final bounceAngle = relative.clamp(-0.85, 0.85) * (pi / 3);

        velocity = Vector2(-cos(bounceAngle) * speed, sin(bounceAngle) * speed);
        position.x = other.position.x - other.size.x / 2 - radius - 1.0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(radius, radius);

    for (int i = 0; i < _trail.length; i++) {
      final trailPos = _trail[i];
      final relPos = trailPos - position;
      final factor = 1.0 - ((i + 1) / (_trail.length + 1));
      final trailPaint = Paint()
        ..color = GameColors.ball.withAlpha((factor * 90).toInt());
      canvas.drawCircle(
        center + Offset(relPos.x, relPos.y),
        radius * factor * 0.85,
        trailPaint,
      );
    }

    final glowPaint = Paint()..color = GameColors.ballGlow;
    canvas.drawCircle(center, radius * 1.35, glowPaint);

    final ballPaint = Paint()..color = GameColors.ball;
    canvas.drawCircle(center, radius, ballPaint);

    final shinePaint = Paint()..color = Colors.white.withAlpha(180);
    canvas.drawCircle(
      center + Offset(-radius * 0.32, -radius * 0.32),
      radius * 0.32,
      shinePaint,
    );
  }
}
