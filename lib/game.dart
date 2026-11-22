import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'components/background.dart';
import 'components/ball.dart';
import 'components/banner.dart';
import 'components/bat.dart';
import 'components/foreground.dart';
import 'components/message.dart';
import 'components/score.dart';
import 'utils.dart';

class MyGame extends FlameGame with HasCollisionDetection, KeyboardEvents {
  GameState state = GameState.menu;
  GameMode mode = GameMode.solo;

  int soloScore = 0;
  int highScore = 0;
  int lives = GameConfig.initialLives;
  int player1Score = 0;
  int player2Score = 0;

  String gameOverTitle = '';
  String gameOverSubtitle = '';

  Background background = Background();
  Foreground foreground = Foreground();
  Ball? ball;
  ScoreHud? scoreHud;
  GameBanner banner = GameBanner();

  Bat? bat1;
  Bat? bat2;
  Bat? batSolo;
  Message? readyMessage;

  final Set<LogicalKeyboardKey> _activeKeys = {};

  bool get isGameStarted => state == GameState.playing;
  set isGameStarted(bool val) {
    if (val) {
      state = GameState.playing;
    } else if (state == GameState.playing) {
      state = GameState.gameOver;
    }
  }

  int get speed => state == GameState.menu ? 0 : 600;
  set speed(int _) {}

  int get miss => GameConfig.initialLives - lives;
  set miss(int val) {
    lives = (GameConfig.initialLives - val).clamp(0, GameConfig.initialLives);
  }

  Score? get points => null;
  Score? get player1 => null;
  Score? get player2 => null;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await add(background);
    await add(foreground);
    await add(banner);
  }

  void startSolo() {
    _setupGameField(GameMode.solo);
  }

  void startVsAi() {
    _setupGameField(GameMode.vsAi);
  }

  void startTwoPlayer() {
    _setupGameField(GameMode.twoPlayer);
  }

  void solo() => startSolo();
  void single() => startSolo();
  void multiple() => startTwoPlayer();

  void _setupGameField(GameMode selectedMode) {
    mode = selectedMode;
    state = GameState.ready;

    soloScore = 0;
    lives = GameConfig.initialLives;
    player1Score = 0;
    player2Score = 0;

    _cleanupGameplayComponents();

    if (banner.isMounted) {
      remove(banner);
    }

    ball = Ball();
    scoreHud = ScoreHud();
    add(ball!);
    add(scoreHud!);

    if (mode == GameMode.solo) {
      batSolo = Bat.bottom();
      add(batSolo!);
      readyMessage = Message(
        'Tap ball or press Space to play',
        subtext: 'Use Left/Right arrows or drag paddle',
      );
    } else if (mode == GameMode.vsAi) {
      bat1 = Bat.right();
      bat2 = Bat.left(isAi: true);
      add(bat1!);
      add(bat2!);
      readyMessage = Message(
        'Tap ball or press Space to serve',
        subtext: 'P1: Use Up/Down arrows or drag right paddle',
      );
    } else {
      bat1 = Bat.right();
      bat2 = Bat.left(isAi: false);
      add(bat1!);
      add(bat2!);
      readyMessage = Message(
        'Tap ball or press Space to serve',
        subtext: 'P1: Up/Down arrows • P2: W/S keys',
      );
    }

    add(readyMessage!);
  }

  void startPlaying() {
    if (state != GameState.ready) return;

    if (readyMessage != null && readyMessage!.isMounted) {
      remove(readyMessage!);
      readyMessage = null;
    }

    state = GameState.playing;
    ball?.launch(towardsRight: true);
  }

  void onSoloHit() {
    soloScore++;
    if (soloScore > highScore) {
      highScore = soloScore;
    }
  }

  void onSoloMiss() {
    lives--;
    if (lives <= 0) {
      gameOverTitle = 'GAME OVER';
      gameOverSubtitle = 'FINAL SCORE: $soloScore • BEST: $highScore';
      _triggerGameOver();
    } else {
      _prepareNextServe(serveTowardsRight: true);
    }
  }

  void onScore({required int scorer}) {
    if (scorer == 1) {
      player1Score++;
    } else {
      player2Score++;
    }

    if (player1Score >= GameConfig.maxScore ||
        player2Score >= GameConfig.maxScore) {
      final winner = player1Score >= GameConfig.maxScore
          ? 'PLAYER 1'
          : (mode == GameMode.vsAi ? 'AI' : 'PLAYER 2');
      gameOverTitle = '$winner WINS!';
      gameOverSubtitle = '$player2Score - $player1Score';
      _triggerGameOver();
    } else {
      _prepareNextServe(serveTowardsRight: scorer == 2);
    }
  }

  void _prepareNextServe({required bool serveTowardsRight}) {
    state = GameState.ready;
    ball?.resetToCenter();

    readyMessage = Message(
      'Point Scored!',
      subtext: 'Tap ball or press Space to continue',
    );
    add(readyMessage!);
  }

  void _triggerGameOver() {
    state = GameState.gameOver;
    ball?.resetToCenter();

    if (readyMessage != null && readyMessage!.isMounted) {
      remove(readyMessage!);
      readyMessage = null;
    }

    if (!banner.isMounted) {
      add(banner);
    } else {
      banner.refresh();
    }
  }

  void togglePause() {
    if (state == GameState.playing) {
      state = GameState.paused;
      if (!banner.isMounted) {
        add(banner);
      } else {
        banner.refresh();
      }
    } else if (state == GameState.paused) {
      state = GameState.playing;
      if (banner.isMounted) remove(banner);
    }
  }

  void replayCurrentMode() {
    _setupGameField(mode);
  }

  void returnToMenu() {
    state = GameState.menu;
    _cleanupGameplayComponents();

    if (!banner.isMounted) {
      add(banner);
    } else {
      banner.refresh();
    }
  }

  void _cleanupGameplayComponents() {
    if (ball != null && ball!.isMounted) remove(ball!);
    if (scoreHud != null && scoreHud!.isMounted) remove(scoreHud!);
    if (batSolo != null && batSolo!.isMounted) remove(batSolo!);
    if (bat1 != null && bat1!.isMounted) remove(bat1!);
    if (bat2 != null && bat2!.isMounted) remove(bat2!);
    if (readyMessage != null && readyMessage!.isMounted) {
      remove(readyMessage!);
      readyMessage = null;
    }

    ball = null;
    scoreHud = null;
    batSolo = null;
    bat1 = null;
    bat2 = null;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (state != GameState.playing) return;

    _processPaddleKeyboardInput();
  }

  void _processPaddleKeyboardInput() {
    if (mode == GameMode.solo) {
      double dir = 0.0;
      if (_activeKeys.contains(LogicalKeyboardKey.arrowLeft) ||
          _activeKeys.contains(LogicalKeyboardKey.keyA)) {
        dir -= 1.0;
      }
      if (_activeKeys.contains(LogicalKeyboardKey.arrowRight) ||
          _activeKeys.contains(LogicalKeyboardKey.keyD)) {
        dir += 1.0;
      }
      batSolo?.movementDirection = dir;
    } else {
      double dir1 = 0.0;
      if (_activeKeys.contains(LogicalKeyboardKey.arrowUp)) dir1 -= 1.0;
      if (_activeKeys.contains(LogicalKeyboardKey.arrowDown)) dir1 += 1.0;
      bat1?.movementDirection = dir1;

      if (mode == GameMode.twoPlayer) {
        double dir2 = 0.0;
        if (_activeKeys.contains(LogicalKeyboardKey.keyW)) dir2 -= 1.0;
        if (_activeKeys.contains(LogicalKeyboardKey.keyS)) dir2 += 1.0;
        bat2?.movementDirection = dir2;
      }
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent) {
      _activeKeys.add(event.logicalKey);

      if (state == GameState.menu) {
        if (event.logicalKey == LogicalKeyboardKey.digit1) {
          startSolo();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.digit2) {
          startVsAi();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.digit3) {
          startTwoPlayer();
          return KeyEventResult.handled;
        }
      }

      if (state == GameState.ready) {
        if (event.logicalKey == LogicalKeyboardKey.space) {
          startPlaying();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.escape) {
          returnToMenu();
          return KeyEventResult.handled;
        }
      }

      if (state == GameState.gameOver) {
        if (event.logicalKey == LogicalKeyboardKey.space) {
          replayCurrentMode();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.escape) {
          returnToMenu();
          return KeyEventResult.handled;
        }
      }

      if (state == GameState.paused) {
        if (event.logicalKey == LogicalKeyboardKey.keyP) {
          togglePause();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.escape) {
          returnToMenu();
          return KeyEventResult.handled;
        }
      }

      if (state == GameState.playing) {
        if (event.logicalKey == LogicalKeyboardKey.keyP ||
            event.logicalKey == LogicalKeyboardKey.escape) {
          togglePause();
          return KeyEventResult.handled;
        }
      }
    } else if (event is KeyUpEvent) {
      _activeKeys.remove(event.logicalKey);
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
