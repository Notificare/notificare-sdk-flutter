import 'package:flutter/material.dart';
import 'package:notificare/notificare.dart';

import '../../../logger/logger.dart';

class LaunchFlowCardView extends StatelessWidget {
  final bool isReady;

  const LaunchFlowCardView({
    super.key,
    required this.isReady,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                "Launch Flow".toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _showNotificareStatusInfo(context),
                icon: const Icon(Icons.info),
              ),
            ],
          ),
        ),
        Card(
          elevation: 1,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed:
                        isReady ? null : () => _launchNotificare(context),
                    child: const Text("Launch"),
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: TextButton(
                    onPressed:
                        !isReady ? null : () => _unLaunchNotificare(context),
                    child: const Text("Unlaunch"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Launch Flow

  void _launchNotificare(BuildContext context) async {
    try {
      logger.i('Launching Notificare.');
      await Notificare.launch();

      logger.i('Launching Notificare finished.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notificare launched successfully.'),
        ),
      );
    } catch (error) {
      logger.e('Notificare launch failed.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _unLaunchNotificare(BuildContext context) async {
    try {
      logger.i('Unlaunching Notificare.');
      await Notificare.unlaunch();

      logger.i('Unlaunching Notificare finished.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notificare unlaunched successfully.'),
        ),
      );
    } catch (error) {
      logger.e('Notificare unlaunch failed.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  Future<void> _showNotificareStatusInfo(BuildContext context) async {
    try {
      final isConfigured = await Notificare.isConfigured;
      final isReady = await Notificare.isReady;

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Notificare"),
            content: Wrap(
              children: [
                Row(
                  children: [
                    const Text("Configured: "),
                    const Spacer(),
                    Text(
                      isConfigured.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("Ready: "),
                    const Spacer(),
                    Text(
                      isReady.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      logger.e('Launch flow info error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
