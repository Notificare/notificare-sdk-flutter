import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notificare_in_app_messaging/notificare_in_app_messaging.dart';

import '../../../main.dart';

class InAppMessagingCardView extends StatefulWidget {
  const InAppMessagingCardView({
    super.key,
  });

  @override
  InAppMessagingCardViewState createState() => InAppMessagingCardViewState();
}

class InAppMessagingCardViewState extends State<InAppMessagingCardView> {
  bool _evaluateContext = false;
  bool _suppressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 32, 16, 8),
          child: Text(
            "In App Messaging".toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
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
                    const Icon(Icons.message),
                    const SizedBox(
                      width: 12,
                    ),
                    Text("Evaluate Context", style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    CupertinoSwitch(
                      activeColor: App.primaryBlue,
                      value: _evaluateContext,
                      onChanged: (value) => _setEvaluateContext(value),
                    ),
                  ],
                ),
              ),
              Container(margin: const EdgeInsets.fromLTRB(48, 0, 0, 0), child: const Divider(height: 0)),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    const Icon(Icons.timer_off),
                    const SizedBox(
                      width: 12,
                    ),
                    Text("Suppressed", style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    CupertinoSwitch(
                      activeColor: App.primaryBlue,
                      value: _suppressed,
                      onChanged: (value) => _setSuppressed(value),
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

  void _setEvaluateContext(bool shouldEvaluate) {
    setState(() {
      _evaluateContext = shouldEvaluate;
    });
  }

  Future<void> _setSuppressed(bool suppressed) async {
    try {
      Logger().i((suppressed ? 'Suppress' : 'Unsuppress') + ' in-app messages clicked.');
      await NotificareInAppMessaging.setMessagesSuppressed(suppressed, evaluateContext: _evaluateContext);

      Logger().i((suppressed ? 'Suppress' : 'Unsuppress') + ' in-app messages successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((suppressed ? 'Suppress' : 'Unsuppress') + ' in-app messages successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Set messages suppressed error.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
      return;
    }

    setState(() {
      _suppressed = suppressed;
    });
  }
}
