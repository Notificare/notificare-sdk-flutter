import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notificare_push/notificare_push.dart';

import '../../../main.dart';
import '../../inbox/inbox.dart';
import '../../tags/tags.dart';

class RemoteNotificationsCardView extends StatefulWidget {
  final bool hasNotificationsEnabled;
  final Function(bool checked) updateNotificationsSettings;
  final int inboxBadge;

  const RemoteNotificationsCardView({
    super.key,
    required this.hasNotificationsEnabled,
    required this.updateNotificationsSettings,
    required this.inboxBadge,
  });

  @override
  RemoteNotificationsCardViewState createState() => RemoteNotificationsCardViewState();
}

class RemoteNotificationsCardViewState extends State<RemoteNotificationsCardView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 32, 16, 8),
          child: Row(
            children: [
              Text(
                "Remote Notifications".toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _remoteNotificationsInfo(),
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
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    const Icon(Icons.notifications),
                    const SizedBox(
                      width: 12,
                    ),
                    Text("Notifications", style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    CupertinoSwitch(
                      activeColor: App.primaryBlue,
                      value: widget.hasNotificationsEnabled,
                      onChanged: (value) => widget.updateNotificationsSettings(value),
                    ),
                  ],
                ),
              ),
              Container(margin: const EdgeInsets.fromLTRB(48, 0, 0, 0), child: const Divider(height: 0)),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InboxView(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    children: [
                      const Icon(Icons.inbox),
                      const SizedBox(
                        width: 12,
                      ),
                      Text("Inbox", style: Theme.of(context).textTheme.titleSmall),
                      const Spacer(),
                      Badge.count(
                        isLabelVisible: widget.inboxBadge > 0,
                        largeSize: 24,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        count: widget.inboxBadge,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
                    ],
                  ),
                ),
              ),
              Container(margin: const EdgeInsets.fromLTRB(48, 0, 0, 0), child: const Divider(height: 0)),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TagsView(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    children: [
                      const Icon(Icons.discount),
                      const SizedBox(
                        width: 12,
                      ),
                      Text("Tags", style: Theme.of(context).textTheme.titleSmall),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _remoteNotificationsInfo() async {
    try {
      final allowedUi = await NotificarePush.allowedUI;
      final hasRemoteNotificationsEnabled = await NotificarePush.hasRemoteNotificationsEnabled;

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Remote Notifications"),
            content: Wrap(
              children: [
                Row(
                  children: [
                    const Text("AllowedUI: "),
                    const Spacer(),
                    Text(
                      allowedUi.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("Enabled: "),
                    const Spacer(),
                    Text(
                      hasRemoteNotificationsEnabled.toString(),
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
      Logger().e('Remote Notifications info error.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
