import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../components/bat.dart';

class DraggableBat extends Bat with DragCallbacks {
  DraggableBat.solo(super.gameSize) : super.solo();

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position.add(Vector2(event.canvasDelta.x, 0));
  }
}
