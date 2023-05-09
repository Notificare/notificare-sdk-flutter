import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notificare/notificare.dart';

class LaunchFlowCardView extends StatefulWidget {
  final bool isReady;

  const LaunchFlowCardView({
    super.key,
    required this.isReady,
  });

  @override
  LaunchFlowCardViewState createState() => LaunchFlowCardViewState();
}

class LaunchFlowCardViewState extends State<LaunchFlowCardView> {
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
                onPressed: () => _launchFlowInfo(),
                icon: const Icon(
                  Icons.info,
                ),
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
                        onPressed: !widget.isReady ? null : () => _unLaunch(), child: const Text("Unlaunch"))),
                const VerticalDivider(width: 1),
                Expanded(
                    child: TextButton(onPressed: widget.isReady ? null : () => _launch(), child: const Text("Launch"))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Launch Flow

  void _launch() async {
    try {
      Logger().i('Notificare launch clicked.');
      await Notificare.launch();

      Logger().i('Notificare launched successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notificare launched successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Notificare launch failed.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _unLaunch() async {
    try {
      Logger().i('Notificare unlaunch clicked.');
      await Notificare.unlaunch();

      Logger().i('Notificare unlaunched successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notificare unlaunched successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Notificare unlaunch failed.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  Future<void> _launchFlowInfo() async {
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
      Logger().e('Launch flow info error.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
