import 'package:endless_runner/level_selection/levels.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

import '../../style/palette.dart';

class GameOverDialog extends StatelessWidget {
  const GameOverDialog({
    super.key,
    required this.level,
  });

  /// The properties of the level that was just losed.
  final GameLevel level;

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    return Center(
      child: NesContainer(
        width: 420,
        height: 300,
        backgroundColor: palette.backgroundPlaySession.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            NesButton(
              onPressed: () {
                context.pop();
                context.push('/play/session/${level.number}');
              },
              type: NesButtonType.primary,
              child: const Text('Try Again'),
            ),
            const SizedBox(height: 16),
            NesButton(
              onPressed: () {
                context.go('/play');
              },
              type: NesButtonType.normal,
              child: const Text('Level selection'),
            ),
          ],
        ),
      ),
    );
  }
}
