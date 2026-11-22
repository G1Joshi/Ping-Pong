import 'package:flame/game.dart';
import 'package:material_ui/material_ui.dart';

import 'bat.dart';

class DraggableBat extends Bat {
  DraggableBat.solo([Vector2? gameSize])
    : super(side: BatSide.bottom, color: const Color(0xFF34D399));
}
