import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'duration_input.dart';
import 'models.dart';
import 'timer_provider.dart';
import 'type_fields.dart';

class NewTimerScreen extends StatefulWidget {
  const NewTimerScreen({super.key});

  @override
  State<NewTimerScreen> createState() => _NewTimerScreenState();
}

class _NewTimerScreenState extends State<NewTimerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController(text: '0');
  final _minutesCtrl = TextEditingController(text: '45');

  String _species = kSpecies.first;
  TimerType _type = TimerType.baby;

  int get _totalMinutes =>
      (int.tryParse(_hoursCtrl.text) ?? 0) * 60 +
      (int.tryParse(_minutesCtrl.text) ?? 0);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _hoursCtrl.dispose();
    _minutesCtrl.dispose();
    super.dispose();
  }

  void _applyPreset(int minutes) {
    setState(() {
      _hoursCtrl.text = (minutes ~/ 60).toString();
      _minutesCtrl.text = (minutes % 60).toString();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<TimerProvider>();
    final navigator = Navigator.of(context);
    await provider.add(
      name: _nameCtrl.text.trim(),
      species: _species,
      type: _type,
      duration: Duration(minutes: _totalMinutes),
    );
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NEUER TIMER')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name des Dinos',
                hintText: 'z. B. Cera #01',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Bitte einen Namen eingeben'
                  : null,
            ),
            const SizedBox(height: 16),
            SpeciesDropdown(
              value: _species,
              onChanged: (v) => setState(() => _species = v),
            ),
            const SizedBox(height: 20),
            TypeSelector(
              value: _type,
              onChanged: (v) => setState(() => _type = v),
            ),
            const SizedBox(height: 20),
            DurationInput(
              hoursCtrl: _hoursCtrl,
              minutesCtrl: _minutesCtrl,
              totalMinutes: _totalMinutes,
              onChanged: () => setState(() {}),
              onPreset: _applyPreset,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.timer),
              label: const Text('Timer starten'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
