import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<SettingsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sound', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),

            // UI Volume
            Text('UI Volume: ${(controller.uiVolume * 100).round()}%'),
            Slider(
              value: controller.uiVolume,
              min: 0,
              max: 1,
              onChanged: (v) => controller.setUiVolume(v),
            ),

            const SizedBox(height: 12),

            // Alarm Volume
            Text('Alarm Volume: ${(controller.alarmVolume * 100).round()}%'),
            Slider(
              value: controller.alarmVolume,
              min: 0,
              max: 1,
              onChanged: (v) => controller.setAlarmVolume(v),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),

            Text('Appearance', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),

            // Dark Mode
            SwitchListTile(
              title: const Text('Dark mode'),
              value: controller.isDarkMode,
              onChanged: (v) => controller.setDarkMode(v),
            ),
          ],
        ),
      ),
    );
  }
}
