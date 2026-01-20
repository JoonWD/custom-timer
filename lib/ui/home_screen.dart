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
                const SizedBox(width: 20),
                TimeAdjusterColumn(
                  label: 'M',
                  mode: AdjusterMode.increment,
                  onPressed: () => engine.addMinutes(1),
                ),
                const SizedBox(width: 20),
                TimeAdjusterColumn(
                  label: 'S',
                  mode: AdjusterMode.increment,
                  onPressed: () => engine.addSeconds(1),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // CONTADOR + BOTÓN +10s
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TimerDisplay(time: engine.formattedTime),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => engine.addSeconds(10),
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: '+10s',
                ),
              ],
            ),
            const SizedBox(height: 40),
            // - - -
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeAdjusterColumn(
                  label: 'H',
                  mode: AdjusterMode.decrement,
                  onPressed: () => engine.addHours(-1),
                ),
                const SizedBox(width: 20),
                TimeAdjusterColumn(
                  label: 'M',
                  mode: AdjusterMode.decrement,
                  onPressed: () => engine.addMinutes(-1),
                ),
                const SizedBox(width: 20),
                TimeAdjusterColumn(
                  label: 'S',
                  mode: AdjusterMode.decrement,
                  onPressed: () => engine.addSeconds(-1),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // BOTONES CONTROL
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: engine.start,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: engine.pause,
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: engine.reset,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
