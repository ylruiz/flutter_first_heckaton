import 'package:endless_runner/flame_game/components/game_over_dialog.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import 'endless_runner.dart';
import 'game_win_dialog.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({required this.level, super.key});

  final GameLevel level;

  static const String winDialogKey = 'win_dialog';
  static const String gameOverDialogKey = 'game_over';
  static const String backButtonKey = 'back_buttton';

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();
    return Scaffold(
      body: GameWidget<EndlessRunner>(
        key: const Key('play session'),
        game: EndlessRunner(
          level: level,
          playerProgress: context.read<PlayerProgress>(),
          audioController: audioController,
        ),
        overlayBuilderMap: {
          backButtonKey: (BuildContext context, EndlessRunner game) {
            return Positioned(
              top: 20,
              right: 10,
              child: NesButton(
                type: NesButtonType.normal,
                onPressed: GoRouter.of(context).pop,
                child: NesIcon(iconData: NesIcons.leftArrowIndicator),
              ),
            );
          },
          winDialogKey: (BuildContext context, EndlessRunner game) {
            return GameWinDialog(
              level: level,
              levelCompletedIn: game.world.levelCompletedIn,
            );
          },
          gameOverDialogKey: (BuildContext context, EndlessRunner game) {
            return GameOverDialog(level: level);
          },
        },
      ),
    );
  }
}
