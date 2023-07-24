import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notificare/notificare.dart';
import 'package:sample/ui/home/views/device_card_view.dart';
import 'package:sample/ui/home/views/dnd_card_view.dart';
import 'package:sample/ui/home/views/geo_card_view.dart';
import 'package:sample/ui/home/views/iam_card_view.dart';
import 'package:sample/ui/home/views/launch_flow_card_view.dart';
import 'package:sample/ui/home/views/other_features_card_view.dart';
import 'package:sample/ui/home/views/remote_notifications_card_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription<NotificareApplication>? _onReadyStreamSubscription;
  StreamSubscription<void>? _onUnlaunchedStreamSubscription;

  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    _setupListeners();
  }

  @override
  void dispose() {
    super.dispose();

    _cancelListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sample"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LaunchFlowCardView(isReady: _isReady),
            _isReady
                ? const Column(
                    children: [
                      DeviceCardView(),
                      RemoteNotificationsCardView(),
                      DoNotDisturbCardView(),
                      GeoCardView(),
                      InAppMessagingCardView(),
                      OtherFeaturesCardViewView(),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  _setupListeners() {
    _onReadyStreamSubscription = Notificare.onReady.listen((application) {
      setState(() {
        _isReady = true;
      });
    });

    _onUnlaunchedStreamSubscription = Notificare.onUnlaunched.listen((event) {
      setState(() {
        _isReady = false;
      });
    });
  }

  _cancelListeners() {
    _onReadyStreamSubscription?.cancel();
    _onUnlaunchedStreamSubscription?.cancel();
  }
}
