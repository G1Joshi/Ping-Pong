import 'package:flame/components.dart';
import 'package:material_ui/material_ui.dart';

import '../game.dart';
import '../utils.dart';

class Background extends Component with HasGameReference<MyGame> {
  late Rect _rect;
  final Paint _bgPaint = Paint()..color = GameColors.background;

  @override
  void onGameResize(Vector2 size) {
    _rect = Rect.fromLTWH(0, 0, game.size.x, game.size.y);
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(_rect, _bgPaint);
  }
}
