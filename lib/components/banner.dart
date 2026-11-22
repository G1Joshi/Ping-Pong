import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:material_ui/material_ui.dart';

import '../game.dart';
import 'mode.dart';

class GameBanner extends RectangleComponent with HasGameReference<MyGame> {
  @override
  FutureOr<void> onLoad() {
    position = Vector2(game.size[0] / 2, game.size[1] / 2);
    size = Vector2(game.size[0] / 4, game.size[1] / 4);
    anchor = Anchor.center;
    add(
      RectangleHitbox()
        ..renderShape = true
        ..setColor(const Color(0xff112233)),
    );
    add(TextComponent(text: 'Select playing mode', position: Vector2(70, 20)));
    add(Mode.single());
    add(Mode.multiple());
    return super.onLoad();
  }
}
