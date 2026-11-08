import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'notification_service.dart';

class TimerProvider extends ChangeNotifier {
  static const _storageKey = 'breeding_timers_v1';

  final List<BreedingTimer> _timers = [];
  Timer? _ticker;

  List<BreedingTimer> get timers => List.unmodifiable(_timers);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      _timers
        ..clear()
        ..addAll(list
            .map((e) => BreedingTimer.fromJson(e as Map<String, dynamic>)));
      _sort();
    }
    // Jede Sekunde neu zeichnen (Live-Countdown).
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timers.isNotEmpty) notifyListeners();
    });
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _storageKey, jsonEncode(_timers.map((t) => t.toJson()).toList()));
  }

  void _sort() => _timers.sort((a, b) => a.endTime.compareTo(b.endTime));

  Future<void> _scheduleFor(BreedingTimer t) {
    final isEgg = t.type == TimerType.egg;
    return NotificationService.schedule(
      id: t.id,
      title: isEgg ? '🥚 Ei ist fertig!' : '🍼 Imprint bereit!',
      body: isEgg
          ? '${t.name} (${t.species}) ist ausgebrütet.'
          : '${t.name} (${t.species}) wartet auf den nächsten Imprint.',
      when: t.endTime,
    );
  }

  Future<void> add({
    required String name,
    required String species,
    required TimerType type,
    required Duration duration,
  }) async {
    final timer = BreedingTimer(
      id: DateTime.now().millisecondsSinceEpoch % 2147483647,
      name: name,
      species: species,
      type: type,
      durationSeconds: duration.inSeconds,
      endTime: DateTime.now().add(duration),
    );
    _timers.add(timer);
    _sort();
    notifyListeners();
    await _scheduleFor(timer);
    await _save();
  }

  /// Imprint abgehakt: Timer startet von vorne.
  Future<void> restart(BreedingTimer t) async {
    t.endTime = DateTime.now().add(Duration(seconds: t.durationSeconds));
    _sort();
    notifyListeners();
    await NotificationService.cancel(t.id);
    await _scheduleFor(t);
    await _save();
  }

  Future<void> remove(BreedingTimer t) async {
    _timers.removeWhere((x) => x.id == t.id);
    notifyListeners();
    await NotificationService.cancel(t.id);
    await _save();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
