import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notificare_inbox/notificare_inbox.dart';
import 'package:notificare_push/notificare_push.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sample/theme/theme.dart';

import '../../../logger/logger.dart';
import '../../inbox/inbox.dart';
import '../../tags/tags.dart';

class RemoteNotificationsCardView extends StatefulWidget {
  const RemoteNotificationsCardView({super.key});

  @override
  RemoteNotificationsCardViewState createState() => RemoteNotificationsCardViewState();
}

class RemoteNotificationsCardViewState extends State<RemoteNotificationsCardView> with WidgetsBindingObserver {
  StreamSubscription<int>? _inboxBadgeStreamSubscription;
  StreamSubscription<bool>? _notificationsSettingsStreamSubscription;

  int _inboxBadge = 0;
  bool _hasNotificationsEnabled = false;
  bool _hasOpenedNotificationsSettings = false;

  @override
  void initState() {
    super.initState();

    _setupListeners();
    _checkNotificationsStatus();
  }

  @override
  void dispose() {
    super.dispose();

    _cancelListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkSettingsChanges();
    }
  }

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
                onPressed: () => _showNotificationsStatusInfo(),
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
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    const Icon(Icons.notifications),
                    const SizedBox(width: 12),
                    Text(
                      "Notifications",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      activeColor: AppTheme.primaryBlue,
                      value: _hasNotificationsEnabled,
                      onChanged: (value) => _updateNotificationsStatus(value),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(48, 0, 0, 0),
                child: const Divider(height: 0),
              ),
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
                      const SizedBox(width: 12),
                      Text(
                        "Inbox",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Spacer(),
                      Badge.count(
                        isLabelVisible: _inboxBadge > 0,
                        largeSize: 24,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        count: _inboxBadge,
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(48, 0, 0, 0),
                child: const Divider(height: 0),
              ),
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
                      const SizedBox(width: 12),
                      Text(
                        "Tags",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.black26,
                      ),
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

  void _setupListeners() {
    _inboxBadgeStreamSubscription = NotificareInbox.onBadgeUpdated.listen((badge) {
      setState(() {
        _inboxBadge = badge;
      });
    });

    _notificationsSettingsStreamSubscription = NotificarePush.onNotificationSettingsChanged.listen((granted) {
      _onNotificationSettingsChanged(granted);
    });

    WidgetsBinding.instance.addObserver(this);
  }

  void _cancelListeners() {
    _inboxBadgeStreamSubscription?.cancel();
    _notificationsSettingsStreamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _onNotificationSettingsChanged(bool granted) {
    if (granted != _hasNotificationsEnabled) {
      _checkNotificationsStatus();
    }
  }

  _checkSettingsChanges() async {
    if (_hasOpenedNotificationsSettings) {
      _hasOpenedNotificationsSettings = false;

      if (!await Permission.notification.isGranted) {
        return;
      }

      _updateNotificationsStatus(true);
    }
  }

  void _checkNotificationsStatus() async {
    try {
      final enabled = await NotificarePush.hasRemoteNotificationsEnabled && await NotificarePush.allowedUI;

      setState(() {
        _hasNotificationsEnabled = enabled;
      });
    } catch (error) {
      logger.e('Get Notifications status error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _updateNotificationsStatus(bool checked) async {
    logger.i((checked ? "Enabling" : "Disabling") + " remote notifications.");
    setState(() {
      _hasNotificationsEnabled = checked;
    });

    if (!checked) {
      try {
        await NotificarePush.disableRemoteNotifications();

        logger.i('Disabling remote notifications finished.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disabled remote notifications successfully.'),
          ),
        );
      } catch (error) {
        logger.e('Disabled remote notifications error.', error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$error'),
            backgroundColor: Colors.red.shade900,
          ),
        );
      }

      return;
    }

    try {
      if (await _ensureNotificationsPermission()) {
        await NotificarePush.enableRemoteNotifications();

        logger.i('Enabling remote notifications finished.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enabled remote notifications successfully.'),
          ),
        );

        return;
      }
    } catch (error) {
      logger.e('Enabling remote notifications error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }

    setState(() {
      _hasNotificationsEnabled = false;
    });
  }

  Future<bool> _ensureNotificationsPermission() async {
    const permission = Permission.notification;
    if (await permission.isGranted) return true;

    if (await permission.isPermanentlyDenied) {
      await _handleOpenSettings();

      return false;
    }

    if (await permission.shouldShowRequestRationale) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sample"),
            content: const Text("Allow notifications in order to receive relevant content."),
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

      return await permission.request().isGranted;
    }

    final granted = await permission.request().isGranted;

    if (Platform.isAndroid) {
      if (!granted && !await permission.shouldShowRequestRationale) {
        await _handleOpenSettings();

        return false;
      }
    }

    return granted;
  }

  Future<void> _handleOpenSettings() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sample"),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Allow notifications in order to receive relevant content."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text("Settings"),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
                _hasOpenedNotificationsSettings = true;
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNotificationsStatusInfo() async {
    try {
      final allowedUi = await NotificarePush.allowedUI;
      final hasRemoteNotificationsEnabled = await NotificarePush.hasRemoteNotificationsEnabled;
      final transport = await NotificarePush.transport;
      final subscriptionId = await NotificarePush.subscriptionId;

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
                Row(
                  children: [
                    const Text("Transport: "),
                    const Spacer(),
                    Text(
                      transport != null ? transport.name : "null",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("SubscriptionID: "),
                    const Spacer(),
                    Text(
                      subscriptionId != null ? "...${subscriptionId.substring(subscriptionId.length - 8)}" : "null",
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
      logger.e('Remote Notifications info error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
