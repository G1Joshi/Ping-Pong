import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:material_ui/material_ui.dart';

import '../game.dart';
import '../utils.dart';
import 'ball.dart';

class Bat extends RectangleComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  bool isBeforeSpaceAvailable = true;
  bool isAfterSpaceAvailable = true;

  Bat.solo(Vector2 gameSize) {
    position = Vector2(gameSize[0] / 2, gameSize[1] - 25);
    size = Vector2(gameSize[0] / 4, gameSize[1] / 64);
    anchor = Anchor.center;
    add(
      RectangleHitbox()
        ..renderShape = true
        ..setColor(Colors.green),
    );
  }

  Bat.top(Vector2 gameSize, GameMode mode) {
    if (mode == GameMode.multiple) {
      position = Vector2(gameSize[0] - 20, gameSize[1] / 2);
      size = Vector2(gameSize[0] / 128, gameSize[1] / 5);
    } else {
      position = Vector2(gameSize[0] / 2, gameSize[1] - 25);
      size = Vector2(gameSize[0] / 6, gameSize[1] / 64);
    }
    anchor = Anchor.center;
    add(
      RectangleHitbox()
        ..renderShape = true
        ..setColor(Colors.green),
    );
  }

  Bat.down(Vector2 gameSize, GameMode mode) {
    if (mode == GameMode.multiple) {
      position = Vector2(20, gameSize[1] / 2);
      size = Vector2(gameSize[0] / 128, gameSize[1] / 5);
    } else {
      position = Vector2(gameSize[0] / 2, 25);
      size = Vector2(gameSize[0] / 3, gameSize[1] / 64);
    }
    anchor = Anchor.center;
    add(
      RectangleHitbox()
        ..renderShape = true
        ..setColor(Colors.blue),
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is ScreenHitbox) {
      final collision = intersectionPoints.first;
      if (game.mode == GameMode.multiple) {
        if (collision.y == 0) {
          isBeforeSpaceAvailable = false;
        }
        if (collision.y == game.size.y) {
          isAfterSpaceAvailable = false;
        }
      } else {
        if (collision.x == 0) {
          isBeforeSpaceAvailable = false;
        }
        if (collision.x == game.size.x) {
          isAfterSpaceAvailable = false;
        }
      }
    }
    if (other is Ball) {
      game.points?.score++;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    isBeforeSpaceAvailable = true;
    isAfterSpaceAvailable = true;
  }
}
