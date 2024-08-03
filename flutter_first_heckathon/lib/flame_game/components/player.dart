import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/animation.dart';

import '../../audio/sounds.dart';
import '../effects/hurt_effect.dart';
import '../effects/jump_effect.dart';
import '../endless_runner.dart';
import '../endless_world.dart';
import 'obstacle.dart';
import 'point.dart';

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with
        CollisionCallbacks,
        HasWorldReference<EndlessWorld>,
        HasGameReference<EndlessRunner> {
  Player({
    required this.addScore,
    required this.resetScore,
    super.position,
  }) : super(size: Vector2.all(150), anchor: Anchor.center, priority: 1);

  final void Function({int amount}) addScore;
  final VoidCallback resetScore;

  double _gravityVelocity = 0;

  final double _jumpLength = 600;

  bool get inAir => (position.y + size.y / 2) < world.groundLevel;

  final Vector2 _lastPosition = Vector2.zero();

  bool get isFalling => _lastPosition.y < position.y;

  @override
  Future<void> onLoad() async {
    animations = {
      PlayerState.running: await game.loadSpriteAnimation(
        'dash/dash_running.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2.all(16),
          stepTime: 0.15,
        ),
      ),
      PlayerState.jumping: SpriteAnimation.spriteList(
        [await game.loadSprite('dash/dash_jumping.png')],
        stepTime: double.infinity,
      ),
      PlayerState.falling: SpriteAnimation.spriteList(
        [await game.loadSprite('dash/dash_falling.png')],
        stepTime: double.infinity,
      ),
    };
    current = PlayerState.running;
    _lastPosition.setFrom(position);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (inAir) {
      _gravityVelocity += world.gravity * dt;
      position.y += _gravityVelocity;
      if (isFalling) {
        current = PlayerState.falling;
      }
    }

    final belowGround = position.y + size.y / 2 > world.groundLevel;
    if (belowGround) {
      position.y = world.groundLevel - size.y / 2;
      _gravityVelocity = 0;
      current = PlayerState.running;
    }

    _lastPosition.setFrom(position);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Obstacle) {
      game.audioController.playSfx(SfxType.damage);
      resetScore();
      add(HurtEffect());
    } else if (other is Point) {
      game.audioController.playSfx(SfxType.score);
      other.removeFromParent();
      addScore();
    }
  }

  void jump(Vector2 towards) {
    current = PlayerState.jumping;
    final jumpEffect = JumpEffect(towards..scaleTo(_jumpLength));

    if (!inAir) {
      game.audioController.playSfx(SfxType.jump);
      add(jumpEffect);
    }
  }
}

enum PlayerState {
  running,
  jumping,
  falling,
}
