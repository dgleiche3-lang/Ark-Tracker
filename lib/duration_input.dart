import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models.dart';

class DurationInput extends StatelessWidget {
  final TextEditingController hoursCtrl;
  final TextEditingController minutesCtrl;
  final int totalMinutes;
  final VoidCallback onChanged;
  final ValueChanged<int> onPreset;

  const DurationInput({
    super.key,
    required this.hoursCtrl,
    required this.minutesCtrl,
    required this.totalMinutes,
    required this.onChanged,
    required this.onPreset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dauer', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: kPresets.entries
              .map((e) => ChoiceChip(
                    label: Text(e.key),
                    selected: totalMinutes == e.value,
                    selectedColor: kCyan.withAlpha(90),
                    onSelected: (_) => onPreset(e.value),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: hoursCtrl,
                decoration: const InputDecoration(labelText: 'Stunden'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => onChanged(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: minutesCtrl,
                decoration: const InputDecoration(labelText: 'Minuten'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => onChanged(),
                validator: (_) =>
                    totalMinutes <= 0 ? 'Dauer muss größer als 0 sein' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
