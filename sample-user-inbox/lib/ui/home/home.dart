import 'dart:async';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_push/notificare_push.dart';
import 'package:notificare_user_inbox/notificare_user_inbox.dart';
import 'package:sample_user_inbox/ui/home/views/authentication_card_view.dart';
import 'package:sample_user_inbox/ui/home/views/dnd_card_view.dart';
import 'package:sample_user_inbox/ui/home/views/launch_flow_card_view.dart';
import 'package:sample_user_inbox/ui/home/views/remote_notifications_card_view.dart';

import '../../logger/logger.dart';
import '../../network/user_inbox_request.dart';
import '../../utils/enviroment_variables.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const String customScheme =
      'auth.re.notifica.sample.user.inbox.app.dev';

  StreamSubscription<NotificareApplication>? _onReadyStreamSubscription;
  StreamSubscription<void>? _onUnlaunchedStreamSubscription;
  StreamSubscription<NotificareNotification>? _onNotificationOpenedSubscription;
  StreamSubscription<NotificareNotificationReceivedEvent>?
      _onNotificationReceivedSubscription;

  bool _isReady = false;
  bool _isLoggedIn = false;
  bool _isDeviceRegistered = false;
  int _badge = 0;

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();

    _initAuth0();
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
        title: const Text("Sample User Inbox"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LaunchFlowCardView(isReady: _isReady),
            _isReady
                ? Column(
                    children: [
                      AuthenticationCardView(
                        isLoggedIn: _isLoggedIn,
                        isDeviceRegistered: _isDeviceRegistered,
                        startLogin: _startLoginFlow,
                        startLogout: _startLogoutFlow,
                      ),
                      RemoteNotificationsCardView(
                        badge: _badge,
                        refreshBadge: _refreshBadge,
                      ),
                      const DoNotDisturbCardView(),
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

      _startAutoLoginFlow();
    });

    _onUnlaunchedStreamSubscription = Notificare.onUnlaunched.listen((event) {
      setState(() {
        _isReady = false;
      });
    });

    _onNotificationReceivedSubscription =
        NotificarePush.onNotificationInfoReceived.listen((event) {
      _refreshBadge();
    });

    _onNotificationOpenedSubscription =
        NotificarePush.onNotificationOpened.listen((event) {
      _refreshBadge();
    });
  }

  _cancelListeners() {
    _onReadyStreamSubscription?.cancel();
    _onUnlaunchedStreamSubscription?.cancel();
    _onNotificationReceivedSubscription?.cancel();
    _onNotificationOpenedSubscription?.cancel();
  }

  void _initAuth0() async {
    final env = await parseEnvVariablesToMap(assetsFileName: '.env');
    final domain = env['USER_INBOX_DOMAIN'];
    final clientId = env['USER_INBOX_CLIENT_ID'];

    auth0 = Auth0(domain!, clientId!);
  }

  void _startAutoLoginFlow() async {
    logger.i('Auto login flow start.');

    try {
      if (!await auth0.credentialsManager.hasValidCredentials()) {
        logger.e('Failed to auto login, no valid credentials.');
        return;
      }

      final credentials = await auth0.credentialsManager.credentials();
      setState(() {
        _isLoggedIn = true;
      });

      logger.i('Successfully got stored credentials.');

      registerDeviceWithUser(credentials.accessToken);
      setState(() {
        _isDeviceRegistered = true;
      });

      logger.i('Successfully registered device with user.');

      _refreshBadge();

      logger.i('Auto login flow success.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Auto login flow success.'),
        ),
      );
    } catch (error) {
      logger.e('Failed auto login flow.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed auto login flow.'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _startLoginFlow() async {
    logger.i('Login flow start.');

    try {
      final credentials = await _loginWithBrowser();
      setState(() {
        _isLoggedIn = true;
      });

      logger.i('Successfully logged in.');

      registerDeviceWithUser(credentials.accessToken);
      setState(() {
        _isDeviceRegistered = true;
      });

      logger.i('Successfully registered device with user.');

      _refreshBadge();

      logger.i('Login flow success.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login flow success.'),
        ),
      );
    } catch (error) {
      logger.e('Failed login flow.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed login flow.'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _startLogoutFlow() async {
    logger.i('Logout flow start.');

    try {
      if (!await auth0.credentialsManager.hasValidCredentials()) {
        logger.e('Failed to logout, no valid credentials.');
        return;
      }

      final credentials = await auth0.credentialsManager.credentials();
      logger.i('Successfully got stored credentials.');

      if (!await auth0.credentialsManager.clearCredentials()) {
        logger.e('Failed to logout, could not clear stored credentials.');
        return;
      }

      logger.i('Successfully cleared stored credentials.');

      await _logoutWithBrowser();
      logger.i('Successfully cleared web credentials.');

      setState(() {
        _isLoggedIn = false;
      });

      registerDeviceAsAnonymous(credentials.accessToken);
      setState(() {
        _isDeviceRegistered = false;
      });

      logger.i('Successfully registered device as anonymous.');

      setState(() {
        _badge = 0;
      });

      logger.i('Logout flow success.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout flow success.'),
        ),
      );
    } catch (error) {
      logger.e('Failed logout flow.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed logout flow.'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  Future<Credentials> _loginWithBrowser() async {
    return await auth0.webAuthentication(scheme: customScheme).login();
  }

  Future<void> _logoutWithBrowser() async {
    await auth0.webAuthentication(scheme: customScheme).logout();
  }

  void _refreshBadge() async {
    try {
      if (!await auth0.credentialsManager.hasValidCredentials()) {
        logger.e('Failed refreshing badge, no valid credentials.');
        return;
      }

      final credentials = await auth0.credentialsManager.credentials();

      final requestResponse =
          await getUserInboxResponse(credentials.accessToken);
      final userInboxResponse =
          await NotificareUserInbox.parseResponseFromString(requestResponse);

      setState(() {
        _badge = userInboxResponse.unread;
      });

      logger.i('Successfully updated badge.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully updated badge.'),
        ),
      );
    } catch (error) {
      logger.e('Failed to refresh badge.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to refresh badge.'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
