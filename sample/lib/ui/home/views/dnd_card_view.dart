import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notificare/notificare.dart';

import '../../../main.dart';

class DoNotDisturbCardView extends StatefulWidget {
  const DoNotDisturbCardView({
    super.key,
  });

  @override
  DoNotDisturbCardViewState createState() => DoNotDisturbCardViewState();
}

class DoNotDisturbCardViewState extends State<DoNotDisturbCardView> {
  final NotificareDoNotDisturb _defaultDnd = NotificareDoNotDisturb(
    start: NotificareTime(hours: 23, minutes: 00),
    end: NotificareTime(hours: 08, minutes: 00),
  );

  bool _hasDndEnabled = false;

  @override
  void initState() {
    super.initState();

    _checkDndEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 1,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_filled),
                    const SizedBox(
                      width: 12,
                    ),
                    Text("Do Not Disturb", style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    CupertinoSwitch(
                      activeColor: App.primaryBlue,
                      value: _hasDndEnabled,
                      onChanged: _updateDndSettings,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _checkDndEnabled() async {
    try {
      final device = await Notificare.device().currentDevice;

      setState(() {
        _hasDndEnabled = device?.dnd != null;
      });
    } catch (error) {
      Logger().e('Fetch DND error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _updateDndSettings(bool checked) async {
    Logger().i((checked ? "Update" : "Clear") + " do not disturb clicked.");

    if (checked) {
      _updateDndTime(_defaultDnd);
      return;
    }

    try {
      await Notificare.device().clearDoNotDisturb();

      Logger().i('Cleared do not disturb successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cleared do not disturb successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Clear do not disturb error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }

    setState(() {
      _hasDndEnabled = false;
    });
  }

  void _updateDndTime(NotificareDoNotDisturb dnd) async {
    try {
      await Notificare.device().updateDoNotDisturb(dnd);

      Logger().i('Updated do not disturb successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updated do not disturb successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Update Do Not Disturb error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
      return;
    }

    setState(() {
      _hasDndEnabled = true;
    });
  }
}
