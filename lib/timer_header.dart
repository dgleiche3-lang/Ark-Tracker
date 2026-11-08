import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import 'models.dart';

String formatDuration(Duration d) {
  if (d.isNegative) d = Duration.zero;
  String two(int n) => n.toString().padLeft(2, '0');
  final h = two(d.inHours);
  final m = two(d.inMinutes.remainder(60));
  final s = two(d.inSeconds.remainder(60));
  return '$h:$m:$s';
}

class TimerHeader extends StatelessWidget {
  final BreedingTimer timer;
  final Color accent;
  const TimerHeader({super.key, required this.timer, required this.accent});

  @override
  Widget build(BuildContext context) {
    final isEgg = timer.type == TimerType.egg;
    final ready = timer.isReady;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accent.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isEgg ? Icons.egg_outlined : Icons.child_care,
            color: accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timer.name,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                '${timer.species} · '
                '${isEgg ? 'Ei-Inkubation' : 'Baby-Imprint'}',
                style: const TextStyle(color: Colors.white60),
              ),
            ],
          ),
        ),
        Text(
          ready ? 'BEREIT!' : formatDuration(timer.remaining),
          style: TextStyle(
            color: accent,
            fontSize: ready ? 18 : 22,
            fontWeight: FontWeight.bold,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
