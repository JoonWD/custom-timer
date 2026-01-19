import 'dart:async';
import 'package:flutter/material.dart';
import '../core/timer_engine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimerEngine engine = TimerEngine(hours: 0, minutes: 1, seconds: 0);
  Timer? timer;

  final TextEditingController hoursController = TextEditingController(text: "0");
  final TextEditingController minutesController = TextEditingController(text: "1");
  final TextEditingController secondsController = TextEditingController(text: "0");

  void startTimer() {
    if (timer != null) return;

    setState(() {
      engine.start();
    });

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        engine.tick();

        if (engine.isFinished) {
          stopTimer();
        }
      });
    });
  }

  void pauseTimer() {
    setState(() {
      engine.pause();
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
    setState(() {
      engine.pause();
    });
  }

  void resetTimer() {
    stopTimer();

    final h = int.tryParse(hoursController.text) ?? 0;
    final m = int.tryParse(minutesController.text) ?? 0;
    final s = int.tryParse(secondsController.text) ?? 0;

    setState(() {
      engine = TimerEngine(hours: h, minutes: m, seconds: s);
    });
  }

  String format(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom Timer")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${format(engine.displayHours)}:"
              "${format(engine.displayMinutes)}:"
              "${format(engine.displaySeconds)}",
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _timeField(hoursController, "HH"),
                const SizedBox(width: 10),
                _timeField(minutesController, "MM"),
                const SizedBox(width: 10),
                _timeField(secondsController, "SS"),
              ],
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: startTimer, child: const Text("Start")),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: pauseTimer, child: const Text("Pause")),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: resetTimer, child: const Text("Reset")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeField(TextEditingController controller, String label) {
    return SizedBox(
      width: 70,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
