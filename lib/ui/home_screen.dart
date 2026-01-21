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

  // =========================
  // BOTONES DINÁMICOS
  // =========================
  Widget _buildControls() {
    // Estado inicial → solo Play
    if (!engine.isRunning && engine.currentDuration == Duration.zero) {
      return OutlinedButton(
        onPressed: engine.start,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.greenAccent.shade400,
        ),
        child: const Icon(Icons.play_arrow),
      );
    }

    // Estado pausado → Play (reanudar) + Reset
    if (!engine.isRunning && engine.currentDuration > Duration.zero) {
      return Row(
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
            onPressed: engine.reset,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
            ),
            child: const Icon(Icons.restart_alt),
          ),
        ],
      );
    }

    // Estado corriendo → Pause + Reset
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
    );
  }

  // =========================
  // UI PRINCIPAL
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Timer')),
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

            // CONTADOR +10s centrado correctamente
            SizedBox(
              width: 360,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TimerDisplay(time: engine.formattedTime),

                  Positioned(
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: IconButton(
                        onPressed: () => engine.addSeconds(10),
                        icon: Text(
                          '+10s',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        tooltip: 'agregar 10s',
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

            // BOTONES DINÁMICOS
            _buildControls(),
          ],
        ),
      ),
    );
  }
}
