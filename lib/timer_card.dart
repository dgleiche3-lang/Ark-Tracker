import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models.dart';
import 'timer_header.dart';
import 'timer_provider.dart';

class TimerCard extends StatelessWidget {
  final BreedingTimer timer;
  const TimerCard({super.key, required this.timer});

  @override
  Widget build(BuildContext context) {
    final isEgg = timer.type == TimerType.egg;
    final ready = timer.isReady;
    final accent = ready ? kNeonGreen : kCyan;
    final progress = timer.durationSeconds == 0
        ? 1.0
        : (1 - timer.remaining.inSeconds / timer.durationSeconds)
            .clamp(0.0, 1.0);
    final provider = context.read<TimerProvider>();

    return Card(
      color: kSurface,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: accent.withAlpha(ready ? 200 : 80), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimerHeader(timer: timer, accent: accent),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                color: accent,
                backgroundColor: Colors.white12,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: isEgg
                  ? FilledButton.icon(
                      onPressed: ready ? () => provider.remove(timer) : null,
                      icon: const Icon(Icons.check),
                      label: Text(ready ? 'Geschlüpft – abhaken' : 'Brütet …'),
                    )
                  : FilledButton.icon(
                      onPressed: () => provider.restart(timer),
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Imprint erledigt – Neustart'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
