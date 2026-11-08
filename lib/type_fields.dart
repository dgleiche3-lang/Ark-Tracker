import 'package:flutter/material.dart';

import 'models.dart';

class SpeciesDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const SpeciesDropdown(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Rasse'),
      dropdownColor: kSurface,
      items: kSpecies
          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
          .toList(),
      onChanged: (v) => onChanged(v ?? value),
    );
  }
}

class TypeSelector extends StatelessWidget {
  final TimerType value;
  final ValueChanged<TimerType> onChanged;
  const TypeSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Typ', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<TimerType>(
            segments: const [
              ButtonSegment(
                value: TimerType.egg,
                icon: Icon(Icons.egg_outlined),
                label: Text('Ei-Inkubation'),
              ),
              ButtonSegment(
                value: TimerType.baby,
                icon: Icon(Icons.child_care),
                label: Text('Baby-Imprint'),
              ),
            ],
            selected: {value},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ),
      ],
    );
  }
}
