import 'dart:math';

import 'package:material_ui/material_ui.dart';

enum GameMode { solo, vsAi, twoPlayer }

enum GameState { menu, ready, playing, paused, gameOver }

class GameColors {
  static const Color background = Color(0xFF070B19);
  static const Color courtBorder = Color(0xFF1E293B);
  static const Color courtNet = Color(0xFF334155);
  static const Color player1 = Color(0xFF38BDF8);
  static const Color player2 = Color(0xFF34D399);
  static const Color ball = Color(0xFFF87171);
  static const Color ballGlow = Color(0x66F87171);
  static const Color accentGold = Color(0xFFFBBF24);
  static const Color textLight = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color bannerBg = Color(0xEE0F172A);
  static const Color buttonBg = Color(0xFF1E293B);
  static const Color buttonHover = Color(0xFF334155);
}

class GameConfig {
  static const double initialBallSpeed = 620.0;
  static const double maxBallSpeed = 1600.0;
  static const double ballSpeedMultiplier = 1.06;
  static const double ballSpeedIncrement = 30.0;
  static const double ballRadius = 14.0;

  static const double paddleSpeed = 760.0;
  static const double aiSpeed = 620.0;
  static const double paddleWidth = 16.0;
  static const double paddleHeightRatio = 0.22;
  static const double soloPaddleWidthRatio = 0.25;

  static const int maxScore = 5;
  static const int initialLives = 3;
}

double get getRandomBallAngle {
  final random = Random();
  final degrees = (random.nextDouble() * 70) - 35;
  return degrees * pi / 180;
}
