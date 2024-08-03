import 'dart:async';

import 'package:flutter/foundation.dart';

import 'persistence/local_storage_player_progress_persistence.dart';
import 'persistence/player_progress_persistence.dart';

class PlayerProgress extends ChangeNotifier {
  PlayerProgress({PlayerProgressPersistence? store})
      : _store = store ?? LocalStoragePlayerProgressPersistence() {
    unawaited(getLatestFromStore());
  }

  final PlayerProgressPersistence _store;

  List<int> _levelsFinished = [];

  List<int> get levels => _levelsFinished;

  Future<void> getLatestFromStore() async {
    final levelsFinished = await _store.getFinishedLevels();
    if (!listEquals(_levelsFinished, levelsFinished)) {
      _levelsFinished = levelsFinished;
      notifyListeners();
    }
  }

  void reset() {
    _store.reset();
    _levelsFinished.clear();
    notifyListeners();
  }

  void setLevelFinished(int level, int time) {
    if (level < _levelsFinished.length - 1) {
      final currentTime = _levelsFinished[level - 1];
      if (time < currentTime) {
        _levelsFinished[level - 1] = time;
        notifyListeners();
        unawaited(_store.saveLevelFinished(level, time));
      }
    } else {
      _levelsFinished.add(time);
      notifyListeners();
      unawaited(_store.saveLevelFinished(level, time));
    }
  }
}
