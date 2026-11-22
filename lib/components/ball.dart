import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../game.dart';
import '../utils.dart';
import 'bat.dart';
import 'message.dart';

class Ball extends CircleComponent
    with HasGameReference<MyGame>, CollisionCallbacks, TapCallbacks {
  Vector2 velocity = Vector2.zero();
  Message? message;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (kIsWeb) {
      if (game.mode == GameMode.multiple) {
        message = Message(
          'Tap on the ball to play\nPlayer 1: Use W/S keys to play\nPlayer 2: Use ArrowUp/ArrowDown keys to play',
        );
      } else {
        message = Message(
          'Tap on the ball to play\nUse ArrowLeft/ArrowRight keys to play',
        );
      }
    } else {
      message = Message('Tap on the ball to play');
    }
    game.add(message!);
    radius = 20;
    anchor = Anchor.center;
    position = game.size / 2;
    add(
      CircleHitbox()
        ..renderShape = true
        ..setColor(Colors.red),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  void start() {
    if (message != null) {
      game.remove(message!);
      message = null;
    }
    game.isGameStarted = true;
    position = game.size / 2;
    final list = [-getRandom, getRandom, getRandom, -getRandom];
    list.shuffle();
    velocity = Vector2(list.first, list.last);
  }

  void reset() {
    game.miss = 0;
    game.points?.score = 0;
    game.player1?.score = 0;
    game.player2?.score = 0;
    position = game.size / 2;
    velocity = Vector2.zero();
  }

  void replay() {
    reset();
    start();
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
        if (collision.y == 0 || collision.y == game.size.y) {
          velocity.y = -velocity.y;
        }
        if (collision.x == 0) {
          game.player2?.score++;
          if (game.player2?.score == 3) {
            game.isGameStarted = false;
            message = Message(
              'Player 2 Won\nPress space to replay\nPress enter for main menu',
            );
            game.add(message!);
          } else {
            start();
          }
        }
        if (collision.x == game.size.x) {
          game.player1?.score++;
          if (game.player1?.score == 3) {
            game.isGameStarted = false;
            message = Message(
              'Player 1 Won\nPress space to replay\nPress enter for main menu',
            );
            game.add(message!);
          } else {
            start();
          }
        }
      } else {
        if (collision.x == 0 || collision.x == game.size.x) {
          velocity.x = -velocity.x;
        }
        if (collision.y == 0) {
          velocity.y = -velocity.y;
        }
        if (collision.y == game.size.y) {
          game.miss++;
          if (game.miss == 3) {
            game.isGameStarted = false;
            if (kIsWeb) {
              message = Message(
                'Game over. Your score: ${game.points?.score}\nPress space to replay\nPress enter for main menu',
              );
              game.add(message!);
            } else {
              message = Message(
                'Game over. Your score: ${game.points?.score}\nTap on the ball to replay',
              );
              game.add(message!);
              reset();
            }
          } else {
            start();
          }
        }
      }
    }
    if (other is Bat) {
      if (game.mode == GameMode.multiple) {
        final list = [-velocity.y, velocity.y];
        list.shuffle();
        velocity.y = list.first * 1.01;
        velocity.x = -velocity.x * 1.01;
      } else {
        final list = [-velocity.x, velocity.x];
        list.shuffle();
        velocity.x = list.first * 1.01;
        velocity.y = -velocity.y * 1.01;
      }
    }
  }
}
