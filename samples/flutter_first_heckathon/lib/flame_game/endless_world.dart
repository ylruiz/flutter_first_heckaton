import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import 'components/obstacle.dart';
import 'components/player.dart';
import 'components/point.dart';
import 'game_screen.dart';

class EndlessWorld extends World with TapCallbacks, HasGameReference {
  EndlessWorld({
    required this.level,
    required this.playerProgress,
    Random? random,
  }) : _random = random ?? Random();

  final GameLevel level;

  final PlayerProgress playerProgress;

  late double speed = _calculateSpeed(level.number);

  final scoreNotifier = ValueNotifier(0);
  late final Player player;
  late final DateTime timeStarted;
  Vector2 get size => (parent as FlameGame).size;
  int levelCompletedIn = 0;

  final Random _random;

  final double gravity = 30;

  late final double groundLevel = (size.y / 2) - (size.y / 5);

  @override
  Future<void> onLoad() async {
    timeStarted = DateTime.now();

    player = Player(
      position: Vector2(-size.x / 3, groundLevel - 900),
      addScore: addScore,
      substractScore: substractScore,
      resetScore: resetScore,
    );
    add(player);

    add(
      SpawnComponent(
        factory: (_) => Obstacle.random(
          random: _random,
          canSpawnTall: level.canSpawnTall,
        ),
        period: 5,
        area: Rectangle.fromPoints(
          Vector2(size.x / 2, groundLevel),
          Vector2(size.x / 2, groundLevel),
        ),
        random: _random,
      ),
    );

    add(
      SpawnComponent.periodRange(
        factory: (_) => Point(),
        minPeriod: 3.0,
        maxPeriod: 5.0 + level.number,
        area: Rectangle.fromPoints(
          Vector2(size.x / 2, -size.y / 2 + Point.spriteSize.y),
          Vector2(size.x / 2, groundLevel),
        ),
        random: _random,
      ),
    );

    scoreNotifier.addListener(() {
      if (scoreNotifier.value < 0) {
        game.pauseEngine();
        game.overlays.add(GameScreen.gameOverDialogKey);
        resetScore();
        return;
      }

      if (scoreNotifier.value >= level.winScore) {
        final levelTime = (DateTime.now().millisecondsSinceEpoch -
                timeStarted.millisecondsSinceEpoch) /
            1000;

        levelCompletedIn = levelTime.round();

        playerProgress.setLevelFinished(level.number, levelCompletedIn);
        game.pauseEngine();
        game.overlays.add(GameScreen.winDialogKey);
      }
    });
  }

  @override
  void onMount() {
    super.onMount();
    game.overlays.add(GameScreen.backButtonKey);
  }

  @override
  void onRemove() {
    game.overlays.remove(GameScreen.backButtonKey);
  }

  void addScore({int amount = 1}) {
    scoreNotifier.value += amount;
  }

  void substractScore({int amount = 1}) {
    scoreNotifier.value -= amount;
  }

  void resetScore() {
    scoreNotifier.value = 0;
  }

  @override
  void onTapDown(TapDownEvent event) {
    final towards = (event.localPosition - player.position)..normalize();
    if (towards.y.isNegative) {
      player.jump(towards);
    }
  }

  static double _calculateSpeed(int level) => 200 + (level * 200);
}
