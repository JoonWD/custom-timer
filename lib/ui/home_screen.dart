import 'package:flutter/material.dart';
import '../core/timer_engine.dart';
import '../widgets/timer_display.dart';
import '../widgets/time_adjuster_column.dart';
import '../widgets/circular_timer.dart';
import '../widgets/animated_action_button.dart';
import '../widgets/quick_adjust_button.dart';
import '../core/ui_sounds.dart';
import '../core/settings_controller.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TimerEngine engine;
  late final SettingsController settings;

  @override
  void initState() {
    super.initState();
    engine = TimerEngine(onTick: () => setState(() {}));

    settings = SettingsController();
    settings.load();
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

    // Running → Pause + Reset
    if (engine.isRunning) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedActionButton(
            icon: Icons.pause,
            foregroundColor: Colors.blueAccent,
            isCircle: false,
            onPressed: () {
              engine.pause();
              UISounds.click();
            },
          ),
          const SizedBox(width: 16),
          AnimatedActionButton(
            icon: Icons.restart_alt,
            foregroundColor: Colors.redAccent,
            isCircle: false,
            onPressed: () {
              engine.reset();
              UISounds.click();
            },
          ),
        ],
      );
    }

    // Paused → Resume + Reset
    if (engine.isPaused) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedActionButton(
            icon: Icons.play_arrow,
            foregroundColor: Colors.greenAccent,
            isCircle: false,
            onPressed: () {
              engine.start();
              UISounds.yet();
            },
          ),
          const SizedBox(width: 16),
          AnimatedActionButton(
            icon: Icons.restart_alt,
            foregroundColor: Colors.redAccent,
            isCircle: false,
            onPressed: () {
              engine.reset();
              UISounds.click();
            },
          ),
        ],
      );
    }

    // Idle → solo Play
    return AnimatedActionButton(
      icon: Icons.play_arrow,
      foregroundColor: Colors.greenAccent,
      isCircle: false,
      onPressed: () {
        engine.start();
        UISounds.yet();
      },
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
              onPressed: () {
                UISounds.tap();
                engine.addHours(1);
              },
            ),
            const SizedBox(width: 24),
            TimeAdjusterColumn(
              label: 'M',
              mode: AdjusterMode.increment,
              onPressed: () {
                UISounds.tap();
                engine.addMinutes(1);
              },
            ),
            const SizedBox(width: 24),
            TimeAdjusterColumn(
              label: 'S',
              mode: AdjusterMode.increment,
              onPressed: () {
                UISounds.tap();
                engine.addSeconds(1);
              },
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: 360,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              TimerDisplay(time: engine.formattedTime),

              // Botón flotante +10s
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
        ),

        const SizedBox(height: 12),

        // - - -
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimeAdjusterColumn(
              label: 'H',
              mode: AdjusterMode.decrement,
              onPressed: () {
                UISounds.tap();
                engine.addHours(-1);
              },
            ),
            const SizedBox(width: 24),
            TimeAdjusterColumn(
              label: 'M',
              mode: AdjusterMode.decrement,
              onPressed: () {
                UISounds.tap();
                engine.addMinutes(-1);
              },
            ),
            const SizedBox(width: 24),
            TimeAdjusterColumn(
              label: 'S',
              mode: AdjusterMode.decrement,
              onPressed: () {
                UISounds.tap();
                engine.addSeconds(-1);
              },
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
          isFinished: engine.isFinished,
        ),

        const SizedBox(height: 32),
        _buildControls(),
      ],
    );
  }
}
