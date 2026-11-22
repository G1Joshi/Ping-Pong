import 'package:flame/components.dart';
import 'package:material_ui/material_ui.dart';

import '../game.dart';

class Background extends Component with HasGameReference<MyGame> {
  static const double width = 4.0;
  late Rect gameRect;
  final Rect rect = Vector2.zero() & Vector2(width / 2, width);
  final Paint back = Paint()..color = const Color(0xff001122);

  @override
  void onGameResize(Vector2 size) {
    gameRect = Vector2.zero() & game.size;
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    canvas
      ..save()
      ..drawRect(gameRect, back);
    canvas.restore();
  }
}
