import 'dart:async';

import 'package:flame/components.dart';
import 'package:material_ui/material_ui.dart';

import '../game.dart';
import '../utils.dart';
import 'mode.dart';

class GameBanner extends PositionComponent with HasGameReference<MyGame> {
  GameBanner() : super(anchor: Anchor.center, priority: 100);

  @override
  FutureOr<void> onLoad() {
    _layoutOverlay();
    return super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    _layoutOverlay();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _layoutOverlay();
  }

  void refresh() {
    _layoutOverlay();
  }

  void _layoutOverlay() {
    final gameSize = game.size;
    final bannerWidth = (gameSize.x * 0.75).clamp(280.0, 480.0);
    final bannerHeight = (gameSize.y * 0.70).clamp(320.0, 440.0);

    size.setValues(bannerWidth, bannerHeight);
    position.setValues(gameSize.x / 2, gameSize.y / 2);

    removeAll(children);

    if (game.state == GameState.menu) {
      _buildMainMenu();
    } else if (game.state == GameState.gameOver) {
      _buildGameOver();
    } else if (game.state == GameState.paused) {
      _buildPauseMenu();
    }
  }

  void _buildMainMenu() {
    final btnWidth = size.x - 48.0;
    const btnHeight = 60.0;

    add(
      MenuButton(
        title: 'Solo Challenge',
        subtitle: 'Bounce ball with paddle • Press 1',
        accentColor: GameColors.player2,
        onTapCallback: () => game.startSolo(),
        position: Vector2(size.x / 2, size.y * 0.40),
        size: Vector2(btnWidth, btnHeight),
      ),
    );

    add(
      MenuButton(
        title: 'Play vs AI',
        subtitle: 'Compete against bot • Press 2',
        accentColor: GameColors.accentGold,
        onTapCallback: () => game.startVsAi(),
        position: Vector2(size.x / 2, size.y * 0.58),
        size: Vector2(btnWidth, btnHeight),
      ),
    );

    add(
      MenuButton(
        title: '2 Players (Local)',
        subtitle: 'W/S vs Arrow Keys • Press 3',
        accentColor: GameColors.player1,
        onTapCallback: () => game.startTwoPlayer(),
        position: Vector2(size.x / 2, size.y * 0.76),
        size: Vector2(btnWidth, btnHeight),
      ),
    );
  }

  void _buildGameOver() {
    final btnWidth = size.x - 48.0;
    const btnHeight = 56.0;

    add(
      MenuButton(
        title: 'Play Again',
        subtitle: 'Tap or Press Space to restart',
        accentColor: GameColors.player2,
        onTapCallback: () => game.replayCurrentMode(),
        position: Vector2(size.x / 2, size.y * 0.60),
        size: Vector2(btnWidth, btnHeight),
      ),
    );

    add(
      MenuButton(
        title: 'Main Menu',
        subtitle: 'Tap or Press Esc/Enter',
        accentColor: GameColors.player1,
        onTapCallback: () => game.returnToMenu(),
        position: Vector2(size.x / 2, size.y * 0.78),
        size: Vector2(btnWidth, btnHeight),
      ),
    );
  }

  void _buildPauseMenu() {
    final btnWidth = size.x - 48.0;
    const btnHeight = 56.0;

    add(
      MenuButton(
        title: 'Resume Game',
        subtitle: 'Tap or Press P to continue',
        accentColor: GameColors.player2,
        onTapCallback: () => game.togglePause(),
        position: Vector2(size.x / 2, size.y * 0.54),
        size: Vector2(btnWidth, btnHeight),
      ),
    );

    add(
      MenuButton(
        title: 'Quit to Menu',
        subtitle: 'Tap or Press Esc/Enter',
        accentColor: GameColors.player1,
        onTapCallback: () => game.returnToMenu(),
        position: Vector2(size.x / 2, size.y * 0.74),
        size: Vector2(btnWidth, btnHeight),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(16.0),
    );

    final bgPaint = Paint()..color = GameColors.bannerBg;
    canvas.drawRRect(rrect, bgPaint);

    final borderPaint = Paint()
      ..color = GameColors.courtBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(rrect, borderPaint);

    if (game.state == GameState.menu) {
      _renderMenuTitle(canvas);
    } else if (game.state == GameState.gameOver) {
      _renderGameOverTitle(canvas);
    } else if (game.state == GameState.paused) {
      _renderPauseTitle(canvas);
    }
  }

  void _renderMenuTitle(Canvas canvas) {
    final titlePaint = TextPaint(
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: GameColors.textLight,
        letterSpacing: 3,
      ),
    );

    final subPaint = TextPaint(
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: GameColors.textMuted,
        letterSpacing: 1.5,
      ),
    );

    titlePaint.render(
      canvas,
      'PING PONG',
      Vector2(size.x / 2, 38),
      anchor: Anchor.center,
    );

    subPaint.render(
      canvas,
      'SELECT GAME MODE',
      Vector2(size.x / 2, 68),
      anchor: Anchor.center,
    );
  }

  void _renderGameOverTitle(Canvas canvas) {
    final titlePaint = TextPaint(
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w900,
        color: GameColors.accentGold,
        letterSpacing: 2,
      ),
    );

    final resultPaint = TextPaint(
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: GameColors.textLight,
      ),
    );

    titlePaint.render(
      canvas,
      game.gameOverTitle,
      Vector2(size.x / 2, 42),
      anchor: Anchor.center,
    );

    resultPaint.render(
      canvas,
      game.gameOverSubtitle,
      Vector2(size.x / 2, 82),
      anchor: Anchor.center,
    );
  }

  void _renderPauseTitle(Canvas canvas) {
    final titlePaint = TextPaint(
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w900,
        color: GameColors.textLight,
        letterSpacing: 2,
      ),
    );

    titlePaint.render(
      canvas,
      'PAUSED',
      Vector2(size.x / 2, 54),
      anchor: Anchor.center,
    );
  }
}
