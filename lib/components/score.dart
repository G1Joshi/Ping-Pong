import 'package:flame/components.dart';
import 'package:material_ui/material_ui.dart';

import '../game.dart';
import '../utils.dart';

class ScoreHud extends PositionComponent with HasGameReference<MyGame> {
  final TextPaint _scorePaint = TextPaint(
    style: const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w900,
      color: GameColors.textLight,
      letterSpacing: 2,
    ),
  );

  final TextPaint _labelPaint = TextPaint(
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: GameColors.textMuted,
      letterSpacing: 1.5,
    ),
  );

  static const IconData _heartIcon = Icons.favorite;

  final TextPaint _p1ScorePaint = TextPaint(
    style: const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w900,
      color: GameColors.player1,
    ),
  );

  final TextPaint _p2ScorePaint = TextPaint(
    style: const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w900,
      color: GameColors.player2,
    ),
  );

  @override
  void render(Canvas canvas) {
    final gameSize = game.size;

    if (game.mode == GameMode.solo) {
      final scoreText = '${game.soloScore}';
      _scorePaint.render(
        canvas,
        scoreText,
        Vector2(gameSize.x / 2, 34),
        anchor: Anchor.center,
      );

      _labelPaint.render(
        canvas,
        'BEST: ${game.highScore}',
        Vector2(16, 24),
        anchor: Anchor.topLeft,
      );

      final heartChar = String.fromCharCode(_heartIcon.codePoint);
      final heartText = heartChar * game.lives;

      final heartPainter = TextPainter(
        text: TextSpan(
          text: heartText,
          style: TextStyle(
            fontFamily: _heartIcon.fontFamily,
            package: _heartIcon.fontPackage,
            fontSize: 18,
            color: const Color(0xFFFF2E63),
            letterSpacing: 2.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      TextPainter? labelPainter;
      if (gameSize.x >= 420) {
        labelPainter = TextPainter(
          text: const TextSpan(
            text: 'LIVES:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: GameColors.textMuted,
              letterSpacing: 1.5,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
      }

      const double targetCenterY = 32.0;
      final double heartY = targetCenterY - heartPainter.height / 2;
      final double heartX = gameSize.x - 20 - heartPainter.width;
      heartPainter.paint(canvas, Offset(heartX, heartY));

      if (labelPainter != null) {
        final double labelY = targetCenterY - labelPainter.height / 2;
        final double labelX = heartX - 8.0 - labelPainter.width;
        labelPainter.paint(canvas, Offset(labelX, labelY));
      }
    } else {
      final p2Label = game.mode == GameMode.vsAi ? 'AI' : 'PLAYER 2 (W/S)';
      const p1Label = 'PLAYER 1 (ARROWS)';

      _labelPaint.render(
        canvas,
        p2Label,
        Vector2(gameSize.x * 0.25, 20),
        anchor: Anchor.center,
      );
      _p2ScorePaint.render(
        canvas,
        '${game.player2Score}',
        Vector2(gameSize.x * 0.25, 52),
        anchor: Anchor.center,
      );

      _labelPaint.render(
        canvas,
        p1Label,
        Vector2(gameSize.x * 0.75, 20),
        anchor: Anchor.center,
      );
      _p1ScorePaint.render(
        canvas,
        '${game.player1Score}',
        Vector2(gameSize.x * 0.75, 52),
        anchor: Anchor.center,
      );
    }
  }
}

class Score extends ScoreHud {
  Score.mid(dynamic mode);
  Score.right(dynamic mode);
  Score.left(dynamic mode);
  int score = 0;
}
