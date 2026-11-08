import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'new_timer_screen.dart';
import 'timer_card.dart';
import 'timer_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timers = context.watch<TimerProvider>().timers;

    return Scaffold(
      appBar: AppBar(title: const Text('ARK BREEDING TRACKER')),
      body: timers.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Noch keine Timer.\nTippe auf + um das erste Ei\n'
                  'oder Baby anzulegen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
              itemCount: timers.length,
              itemBuilder: (context, i) {
                final t = timers[i];
                return Dismissible(
                  key: ValueKey(t.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.only(right: 24),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Colors.red.shade900,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => context.read<TimerProvider>().remove(t),
                  child: TimerCard(timer: t),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const NewTimerScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
