import 'package:flutter/material.dart';

const kBackground = Color(0xFF111416);
const kSurface = Color(0xFF1C2125);
const kNeonGreen = Color(0xFF39FF88);
const kCyan = Color(0xFF00E5FF);

// Rassen für das Dropdown - einfach erweitern!
const kSpecies = <String>[
  'Rex', 'Therizinosaurus', 'Giganotosaurus', 'Raptor',
  'Carnotaurus', 'Triceratops', 'Stegosaurus', 'Ankylosaurus',
  'Argentavis', 'Quetzal', 'Spinosaurus', 'Andere',
];

// Voreinstellungen in Minuten
const kPresets = <String, int>{'45 Min': 45, '4 Std': 240, '8 Std': 480};

enum TimerType { egg, baby }

class BreedingTimer {
  final int id;
  final String name;
  final String species;
  final TimerType type;
  final int durationSeconds;
  DateTime endTime;

  BreedingTimer({
    required this.id,
    required this.name,
    required this.species,
    required this.type,
    required this.durationSeconds,
    required this.endTime,
  });

  Duration get remaining => endTime.difference(DateTime.now());
  bool get isReady => remaining <= Duration.zero;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'species': species,
        'type': type.name,
        'duration': durationSeconds,
        'end': endTime.millisecondsSinceEpoch,
      };

  factory BreedingTimer.fromJson(Map<String, dynamic> json) => BreedingTimer(
        id: json['id'] as int,
        name: json['name'] as String,
        species: json['species'] as String,
        type: TimerType.values.byName(json['type'] as String),
        durationSeconds: json['duration'] as int,
        endTime: DateTime.fromMillisecondsSinceEpoch(json['end'] as int),
      );
}
