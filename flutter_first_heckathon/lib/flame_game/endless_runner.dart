import 'package:flame/components.dart';  
import 'package:flame/game.dart';  
import 'package:flutter/material.dart';  
  
import '../audio/audio_controller.dart';  
import '../level_selection/levels.dart';  
import '../player_progress/player_progress.dart';  
import 'components/background.dart';  
import 'endless_world.dart';  
  
class EndlessRunner extends FlameGame with HasCollisionDetection {  
  EndlessRunner({  
    required this.level,  
    required PlayerProgress playerProgress,  
    required this.audioController,  
  }) : endlessWorld = EndlessWorld(level: level, playerProgress: playerProgress);  
  
  final GameLevel level;  
  final AudioController audioController;  
  final EndlessWorld endlessWorld;  
  
  @override  
  Future<void> onLoad() async {  
    add(endlessWorld);  
  
    camera = CameraComponent.withFixedResolution(  
      world: endlessWorld,  
      width: 1600,  
      height: 720,  
    );  
    add(camera);  
  
    camera.backdrop.add(Background(speed: endlessWorld.speed));  
  
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
  
    endlessWorld.scoreNotifier.addListener(() {  
      scoreComponent.text =  
          scoreText.replaceFirst('0', '${endlessWorld.scoreNotifier.value}');  
    });  
  }  
}  
