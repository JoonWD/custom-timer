import 'dart:async';
import 'package:flutter/material.dart';
import '../core/timer_engine.dart';
import '../widgets/timer_display.dart';
import '../widgets/time_adjuster_column.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TimerEngine engine;

  @override
  void initState() {
    super.initState();
    engine = TimerEngine(
      onTick: () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Timer'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // + + +
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeAdjusterColumn(
                  label: 'H',
                  mode: AdjusterMode.increment,
                  onPressed: () => engine.addHours(1),
                ),
                const SizedBox(width: 24),
                TimeAdjusterColumn(
                  label: 'M',
                  mode: AdjusterMode.increment,
                  onPressed: () => engine.addMinutes(1),
                ),
                const SizedBox(width: 24),
                TimeAdjusterColumn(
                  label: 'S',
                  mode: AdjusterMode.increment,
                  onPressed: () => engine.addSeconds(1),
                ),
              ],
            ),

            const SizedBox(height: 12),
            // CONTADOR +10s integrado
            SizedBox(
              width:
                  360, // puedes ajustar según te guste más ancho o más compacto
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Contador perfectamente centrado
                  TimerDisplay(time: engine.formattedTime),

                  // Botón +10s flotante a la derecha
                  Positioned(
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => engine.addSeconds(10),
                        icon: const Icon(Icons.add),
                        tooltip: '+10s',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            // - - -
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeAdjusterColumn(
                  label: 'H',
                  mode: AdjusterMode.decrement,
                  onPressed: () => engine.addHours(-1),
                ),
                const SizedBox(width: 24),
                TimeAdjusterColumn(
                  label: 'M',
                  mode: AdjusterMode.decrement,
                  onPressed: () => engine.addMinutes(-1),
                ),
                const SizedBox(width: 24),
                TimeAdjusterColumn(
                  label: 'S',
                  mode: AdjusterMode.decrement,
                  onPressed: () => engine.addSeconds(-1),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // BOTONES CONTROL mejorados visualmente
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: engine.start,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.greenAccent.shade400,
                  ),
                  child: const Icon(Icons.play_arrow),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: engine.pause,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                  ),
                  child: const Icon(Icons.pause),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: engine.reset,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                  child: const Icon(Icons.restart_alt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
