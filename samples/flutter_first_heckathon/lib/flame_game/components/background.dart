import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

class Background extends ParallaxComponent {
  Background({required this.speed});

  final double speed;

  @override
  Future<void> onLoad() async {
    final layers = [
      ParallaxImageData('scenery/background.png'),
      ParallaxImageData('scenery/clouds.png'),
      ParallaxImageData('scenery/cliffs.png'),
      ParallaxImageData('scenery/trees.png'),
      ParallaxImageData('scenery/ground.png'),
    ];

    final baseVelocity = Vector2(speed / pow(2, layers.length), 0);

    final velocityMultiplierDelta = Vector2(2.0, 0.0);

    parallax = await game.loadParallax(
      layers,
      baseVelocity: baseVelocity,
      velocityMultiplierDelta: velocityMultiplierDelta,
      filterQuality: FilterQuality.none,
    );
  }
}
