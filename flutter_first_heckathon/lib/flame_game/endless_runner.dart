import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../audio/audio_controller.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import 'components/background.dart';
import 'endless_world.dart';

class EndlessRunner extends FlameGame<EndlessWorld> with HasCollisionDetection {
  EndlessRunner({
    required this.level,
    required PlayerProgress playerProgress,
    required this.audioController,
  }) : super(
          world: EndlessWorld(level: level, playerProgress: playerProgress),
          camera: CameraComponent.withFixedResolution(width: 1600, height: 720),
        );

  final GameLevel level;

  final AudioController audioController;

  @override
  Future<void> onLoad() async {
    camera.backdrop.add(Background(speed: world.speed));

    final textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontFamily: 'Press Start 2P',
      ),
    );

    final scoreText = 'Embers: 0 / ${level.winScore}';

    final scoreComponent = TextComponent(
      text: scoreText,
      position: Vector2.all(30),
      textRenderer: textRenderer,
    );

    camera.viewport.add(scoreComponent);

    world.scoreNotifier.addListener(() {
      scoreComponent.text =
          scoreText.replaceFirst('0', '${world.scoreNotifier.value}');
    });
  }
}
