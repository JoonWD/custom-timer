import 'package:flutter/material.dart';
import '../core/timer_engine.dart';
import '../widgets/timer_display.dart';
import '../widgets/time_adjuster_column.dart';
import '../widgets/circular_timer.dart';

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
    engine = TimerEngine(onTick: () => setState(() {}));
  }

  @override
  void dispose() {
    engine.dispose();
    super.dispose();
  }

  // =========================
  // CONTROLES DINÁMICOS
  // =========================

  Widget _buildControls() {
    // Finished → solo botón Stop
    if (engine.isFinished) {
      return OutlinedButton(
        onPressed: engine.stop,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(22),
        ),
        child: const Icon(Icons.stop),
      );
    }

    // Running → Pause + Reset
    if (engine.isRunning) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: engine.pause,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.blueAccent),
            child: const Icon(Icons.pause),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: engine.reset,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Icon(Icons.restart_alt),
          ),
        ],
      );
    }

    // Paused → Resume + Reset
    if (engine.isPaused) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: engine.start,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.greenAccent,
            ),
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: engine.reset,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Icon(Icons.restart_alt),
          ),
        ],
      );
    }

    // Idle → solo Play
    return OutlinedButton(
      onPressed: engine.start,
      style: OutlinedButton.styleFrom(foregroundColor: Colors.greenAccent),
      child: const Icon(Icons.play_arrow),
    );
  }

  // =========================
  // UI PRINCIPAL
  // =========================

  @override
  Widget build(BuildContext context) {
    final bool showRunningView =
        engine.isRunning || engine.isPaused || engine.isFinished;

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Timer')),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: showRunningView ? _buildRunningView() : _buildEditView(),
        ),
      ),
    );
  }

  // =========================
  // EDIT VIEW
  // =========================

  Widget _buildEditView() {
    return Column(
      key: const ValueKey('edit'),
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
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: IconButton(
                    onPressed: () => engine.addSeconds(10),
                    icon: const Text('+10s'),
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

        _buildControls(),
      ],
    );
  }

  // =========================
  // RUNNING VIEW
  // =========================

  Widget _buildRunningView() {
    return Column(
      key: const ValueKey('running'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularTimer(
          current: engine.currentDuration,
          total: engine.initialDuration,
          isRunning: engine.isRunning,
        ),

        const SizedBox(height: 32),
        _buildControls(),
      ],
    );
  }
}
