import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import '../endless_world.dart';

class Obstacle extends SpriteComponent with HasWorldReference<EndlessWorld> {
  Obstacle.small({super.position})
      : _srcSize = Vector2.all(16),
        _srcPosition = Vector2.all(32),
        super(
          size: Vector2.all(150),
          anchor: Anchor.bottomLeft,
        );

  Obstacle.tall({super.position})
      : _srcSize = Vector2(32, 48),
        _srcPosition = Vector2.zero(),
        super(
          size: Vector2(200, 250),
          anchor: Anchor.bottomLeft,
        );

  Obstacle.wide({super.position})
      : _srcSize = Vector2(32, 16),
        _srcPosition = Vector2(48, 32),
        super(
          size: Vector2(200, 100),
          anchor: Anchor.bottomLeft,
        );

  factory Obstacle.random({
    Vector2? position,
    Random? random,
    bool canSpawnTall = true,
  }) {
    final values = canSpawnTall
        ? const [ObstacleType.small, ObstacleType.tall, ObstacleType.wide]
        : const [ObstacleType.small, ObstacleType.wide];
    final obstacleType = values.random(random);
    return switch (obstacleType) {
      ObstacleType.small => Obstacle.small(position: position),
      ObstacleType.tall => Obstacle.tall(position: position),
      ObstacleType.wide => Obstacle.wide(position: position),
    };
  }

  final Vector2 _srcSize;
  final Vector2 _srcPosition;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
      'enemies/obstacles.png',
      srcSize: _srcSize,
      srcPosition: _srcPosition,
    );
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= world.speed * dt;
    if (position.x + size.x < -world.size.x / 2) {
      removeFromParent();
    }
  }
}

enum ObstacleType {
  small,
  tall,
  wide,
}
