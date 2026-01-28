import 'package:flutter/material.dart';
import '../core/timer_engine.dart';
import '../widgets/timer_display.dart';
import '../widgets/time_adjuster_column.dart';
import '../widgets/circular_timer.dart';
import '../widgets/animated_action_button.dart';
import '../widgets/quick_adjust_button.dart';
import '../core/ui_sounds.dart';
import 'settings_screen.dart';

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

  Widget _buildControls() {
    if (engine.isFinished) {
      return AnimatedActionButton(
        icon: Icons.stop,
        foregroundColor: Colors.redAccent,
        isCircle: true,
        onPressed: () {
          engine.stop();
          UISounds.click();
        },
      );
    }

    if (engine.isRunning) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedActionButton(
            icon: Icons.pause,
            foregroundColor: Colors.blueAccent,
            onPressed: () {
              engine.pause();
              UISounds.click();
            },
          ),
          const SizedBox(width: 16),
          AnimatedActionButton(
            icon: Icons.restart_alt,
            foregroundColor: Colors.redAccent,
            onPressed: () {
              engine.reset();
              UISounds.click();
            },
          ),
        ],
      );
    }

    if (engine.isPaused) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedActionButton(
            icon: Icons.play_arrow,
            foregroundColor: Colors.greenAccent,
            onPressed: () {
              engine.start();
              UISounds.yet();
            },
          ),
          const SizedBox(width: 16),
          AnimatedActionButton(
            icon: Icons.restart_alt,
            foregroundColor: Colors.redAccent,
            onPressed: () {
              engine.reset();
              UISounds.click();
            },
          ),
        ],
      );
    }

    return AnimatedActionButton(
      icon: Icons.play_arrow,
      foregroundColor: Colors.greenAccent,
      onPressed: () {
        engine.start();
        UISounds.yet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final showRunningView =
        engine.isRunning || engine.isPaused || engine.isFinished;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChronoSync'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: showRunningView ? _buildRunningView() : _buildEditView(),
        ),
      ),
    );
  }

  // =========================
  // EDIT VIEW — mantiene TimerDisplay + alineación perfecta
  // =========================

  Widget _buildEditView() {
    return Column(
      key: const ValueKey('edit'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 360,
          child: Column(
            children: [
              // ↑ Botones arriba perfectamente alineados
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _incButton('H', () => engine.addHours(1)),
                  const SizedBox(width: 16),
                  _incButton('M', () => engine.addMinutes(1)),
                  const SizedBox(width: 16),
                  _incButton('S', () => engine.addSeconds(1)),
                ],
              ),

              const SizedBox(height: 8),

              // Timer con +10s flotante
              Stack(
                alignment: Alignment.center,
                children: [
                  TimerDisplay(time: engine.formattedTime),
                  Positioned(
                    right: 0,
                    child: QuickAdjustButton(
                      label: '+10s',
                      onPressed: () {
                        UISounds.tap();
                        engine.addSeconds(10);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ↓ Botones abajo perfectamente alineados
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _decButton('H', () => engine.addHours(-1)),
                  const SizedBox(width: 16),
                  _decButton('M', () => engine.addMinutes(-1)),
                  const SizedBox(width: 16),
                  _decButton('S', () => engine.addSeconds(-1)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
        _buildControls(),
      ],
    );
  }

  Widget _incButton(String label, VoidCallback onTap) {
    return Center(
      child: TimeAdjusterColumn(
        label: label,
        mode: AdjusterMode.increment,
        onPressed: () {
          UISounds.tap();
          onTap();
        },
      ),
    );
  }

  Widget _decButton(String label, VoidCallback onTap) {
    return Center(
      child: TimeAdjusterColumn(
        label: label,
        mode: AdjusterMode.decrement,
        onPressed: () {
          UISounds.tap();
          onTap();
        },
      ),
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
          isFinished: engine.isFinished,
        ),
        const SizedBox(height: 32),
        _buildControls(),
      ],
    );
  }
}
