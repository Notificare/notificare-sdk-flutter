import 'package:flutter/material.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_assets/notificare_assets.dart';
import 'package:notificare_authentication/notificare_authentication.dart';
import 'package:notificare_geo/notificare_geo.dart';
import 'package:notificare_in_app_messaging/notificare_in_app_messaging.dart';
import 'package:notificare_loyalty/notificare_loyalty.dart';
import 'package:notificare_push/notificare_push.dart';
import 'package:notificare_scannables/notificare_scannables.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sample/theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton(
              child: const Text('Launch'),
              style: AppTheme.buttonStyle,
              onPressed: _onLaunchClicked,
            ),
            TextButton(
              child: const Text('Unlaunch'),
              style: AppTheme.buttonStyle,
              onPressed: _onUnlaunchClicked,
            ),
            TextButton(
              child: const Text('Fetch application'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchApplicationClicked,
            ),
            TextButton(
              child: const Text('Cached application'),
              style: AppTheme.buttonStyle,
              onPressed: _onCachedApplicationClicked,
            ),
            TextButton(
              child: const Text('Fetch notification'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchNotificationClicked,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Push',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            TextButton(
              child: const Text('Enable remote notifications'),
              style: AppTheme.buttonStyle,
              onPressed: _onEnableRemoteNotificationsClicked,
            ),
            TextButton(
              child: const Text('Disable remote notifications'),
              style: AppTheme.buttonStyle,
              onPressed: _onDisableRemoteNotificationsClicked,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Geo',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            TextButton(
              child: const Text('Enable location updates'),
              style: AppTheme.buttonStyle,
              onPressed: _onEnableLocationUpdatesClicked,
            ),
            TextButton(
              child: const Text('Disable location updates'),
              style: AppTheme.buttonStyle,
              onPressed: _onDisableLocationUpdatesClicked,
            ),
            TextButton(
              child: const Text('View ranging beacons'),
              style: AppTheme.buttonStyle,
              onPressed: _onRangingBeaconsClicked,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Inbox',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            TextButton(
              child: const Text('Open inbox'),
              style: AppTheme.buttonStyle,
              onPressed: _onInboxClicked,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Device',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            TextButton(
              child: const Text('Current device'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchCurrentDeviceClicked,
            ),
            TextButton(
              child: const Text('Register device with user'),
              style: AppTheme.buttonStyle,
              onPressed: _onRegisterDeviceWithUserClicked,
            ),
            TextButton(
              child: const Text('Register device with anonymous user'),
              style: AppTheme.buttonStyle,
              onPressed: _onRegisterDeviceWithAnonymousUserClicked,
            ),
            TextButton(
              child: const Text('Fetch tags'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchTagsClicked,
            ),
            TextButton(
              child: const Text('Add tags'),
              style: AppTheme.buttonStyle,
              onPressed: _onAddTagsClicked,
            ),
            TextButton(
              child: const Text('Remove tags'),
              style: AppTheme.buttonStyle,
              onPressed: _onRemoveTagsClicked,
            ),
            TextButton(
              child: const Text('Clear tags'),
              style: AppTheme.buttonStyle,
              onPressed: _onClearTagsClicked,
            ),
            TextButton(
              child: const Text('Fetch do not disturb'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchDoNotDisturbClicked,
            ),
            TextButton(
              child: const Text('Update do not disturb'),
              style: AppTheme.buttonStyle,
              onPressed: _onUpdateDoNotDisturbClicked,
            ),
            TextButton(
              child: const Text('Clear do not disturb'),
              style: AppTheme.buttonStyle,
              onPressed: _onClearDoNotDisturbClicked,
            ),
            TextButton(
              child: const Text('Fetch user data'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchUserDataClicked,
            ),
            TextButton(
              child: const Text('Update user data'),
              style: AppTheme.buttonStyle,
              onPressed: _onUpdateUserDataClicked,
            ),
            TextButton(
              child: const Text('Fetch preferred language'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchPreferredLanguageClicked,
            ),
            TextButton(
              child: const Text('Update preferred language'),
              style: AppTheme.buttonStyle,
              onPressed: _onUpdatePreferredLanguageClicked,
            ),
            TextButton(
              child: const Text('Clear preferred language'),
              style: AppTheme.buttonStyle,
              onPressed: _onClearPreferredLanguageClicked,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Assets',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            TextButton(
              child: const Text('Fetch assets'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchAssetsClicked,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Authentication',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            TextButton(
              child: const Text('Create user account'),
              style: AppTheme.buttonStyle,
              onPressed: _onCreateUserAccountClicked,
            ),
            TextButton(
              child: const Text('Login'),
              style: AppTheme.buttonStyle,
              onPressed: _onLoginClicked,
            ),
            TextButton(
              child: const Text('Logout'),
              style: AppTheme.buttonStyle,
              onPressed: _onLogoutClicked,
            ),
            TextButton(
              child: const Text('Fetch user details'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchUserDetailsClicked,
            ),
            TextButton(
              child: const Text('Fetch user preferences'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchUserPreferencesClicked,
            ),
            TextButton(
              child: const Text('Fetch user segments'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchUserSegmentsClicked,
            ),
            TextButton(
              child: const Text('Send password reset'),
              style: AppTheme.buttonStyle,
              onPressed: _onSendPasswordResetClicked,
            ),
            TextButton(
              child: const Text('Reset password'),
              style: AppTheme.buttonStyle,
              onPressed: _onResetPasswordClicked,
            ),
            TextButton(
              child: const Text('Change password'),
              style: AppTheme.buttonStyle,
              onPressed: _onChangePasswordClicked,
            ),
            TextButton(
              child: const Text('Validate user'),
              style: AppTheme.buttonStyle,
              onPressed: _onValidateUserClicked,
            ),
            TextButton(
              child: const Text('Generate push email'),
              style: AppTheme.buttonStyle,
              onPressed: _onGeneratePushEmailClicked,
            ),
            TextButton(
              child: const Text('Add user segment'),
              style: AppTheme.buttonStyle,
              onPressed: _onAddUserSegmentClicked,
            ),
            TextButton(
              child: const Text('Remove user segment'),
              style: AppTheme.buttonStyle,
              onPressed: _onRemoveUserSegmentClicked,
            ),
            TextButton(
              child: const Text('Add user segment to preference'),
              style: AppTheme.buttonStyle,
              onPressed: _onAddUserSegmentToPreferenceClicked,
            ),
            TextButton(
              child: const Text('Remove user segment from preference'),
              style: AppTheme.buttonStyle,
              onPressed: _onRemoveUserSegmentFromPreferenceClicked,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Scannables',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            TextButton(
              child: const Text('Start scannable session'),
              style: AppTheme.buttonStyle,
              onPressed: _onStartScannableSessionClicked,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Loyalty',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            TextButton(
              child: const Text('Fetch pass'),
              style: AppTheme.buttonStyle,
              onPressed: _onFetchPassClicked,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'In-app messaging',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            TextButton(
              child: const Text('Check suppressed state'),
              style: AppTheme.buttonStyle,
              onPressed: _onCheckSuppressedStateClicked,
            ),
            TextButton(
              child: const Text('Suppress messages'),
              style: AppTheme.buttonStyle,
              onPressed: _onSuppressMessagesClicked,
            ),
            TextButton(
              child: const Text('Un-suppress messages'),
              style: AppTheme.buttonStyle,
              onPressed: _onUnSuppressMessagesClicked,
            ),
          ],
        ),
      ),
    );
  }

  void _onLaunchClicked() async {
    try {
      await Notificare.launch();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onUnlaunchClicked() async {
    try {
      await Notificare.unlaunch();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchApplicationClicked() async {
    try {
      final application = await Notificare.fetchApplication();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${application.toJson()}'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onCachedApplicationClicked() async {
    try {
      final application = await Notificare.application;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${application?.toJson()}'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchNotificationClicked() async {
    try {
      final notification = await Notificare.fetchNotification('618e4812974aab0d61ac1483');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${notification.toJson()}'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onEnableRemoteNotificationsClicked() async {
    try {
      await NotificarePush.enableRemoteNotifications();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onDisableRemoteNotificationsClicked() async {
    try {
      await NotificarePush.disableRemoteNotifications();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onEnableLocationUpdatesClicked() async {
    try {
      final hasFullCapabilities = await _ensureForegroundLocationPermission() &&
          await _ensureBackgroundLocationPermission() &&
          await _ensureBluetoothScanPermission();

      // Calling enableLocationUpdates() will evaluate the given permissions, if any, and enable the available capabilities.
      await NotificareGeo.enableLocationUpdates();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  Future<bool> _ensureForegroundLocationPermission() async {
    if (await Permission.locationWhenInUse.isGranted) return true;

    if (await Permission.locationWhenInUse.isPermanentlyDenied) {
      // TODO: Show some informational UI, educating the user to change the permission via the Settings app.
      await openAppSettings();
      return false;
    }

    if (await Permission.locationWhenInUse.shouldShowRequestRationale) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Sample'),
              content: const Text('We need access to foreground location in order to show relevant content.'),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (await Permission.locationWhenInUse.request().isGranted) {
                      _onEnableLocationUpdatesClicked();
                    }
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });

      return false;
    }

    return await Permission.locationWhenInUse.request().isGranted;
  }

  Future<bool> _ensureBackgroundLocationPermission() async {
    if (await Permission.locationAlways.isGranted) return true;

    if (await Permission.locationAlways.isPermanentlyDenied) {
      // TODO: Show some informational UI, educating the user to change the permission via the Settings app.
      await openAppSettings();
      return false;
    }

    if (await Permission.locationAlways.shouldShowRequestRationale) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Sample'),
              content: const Text('We need access to background location in order to show relevant content.'),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (await Permission.locationAlways.request().isGranted) {
                      _onEnableLocationUpdatesClicked();
                    }
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });

      return false;
    }

    return await Permission.locationAlways.request().isGranted;
  }

  Future<bool> _ensureBluetoothScanPermission() async {
    if (await Permission.bluetoothScan.isGranted) return true;

    if (await Permission.bluetoothScan.isPermanentlyDenied) {
      // TODO: Show some informational UI, educating the user to change the permission via the Settings app.
      await openAppSettings();
      return false;
    }

    if (await Permission.bluetoothScan.shouldShowRequestRationale) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Sample'),
              content: const Text('We need access to bluetooth scan in order to show relevant content.'),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (await Permission.bluetoothScan.request().isGranted) {
                      _onEnableLocationUpdatesClicked();
                    }
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });

      return false;
    }

    return await Permission.bluetoothScan.request().isGranted;
  }

  void _onDisableLocationUpdatesClicked() async {
    try {
      await NotificareGeo.disableLocationUpdates();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onRangingBeaconsClicked() {
    Navigator.of(context).pushNamed('/beacons');
  }

  void _onInboxClicked() {
    Navigator.of(context).pushNamed('/inbox');
  }

  void _onFetchCurrentDeviceClicked() async {
    try {
      final device = await Notificare.device().currentDevice;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${device?.toJson()}'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onRegisterDeviceWithUserClicked() async {
    try {
      await Notificare.device().register(
        userId: 'helder@notifica.re',
        userName: 'Helder Pinhal',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onRegisterDeviceWithAnonymousUserClicked() async {
    try {
      await Notificare.device().register(
        userId: null,
        userName: null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchTagsClicked() async {
    try {
      final tags = await Notificare.device().fetchTags();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$tags'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onAddTagsClicked() async {
    try {
      await Notificare.device().addTags(['flutter', 'hpinhal']);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onRemoveTagsClicked() async {
    try {
      await Notificare.device().removeTag('remove-me');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onClearTagsClicked() async {
    try {
      await Notificare.device().clearTags();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchDoNotDisturbClicked() async {
    try {
      final dnd = await Notificare.device().fetchDoNotDisturb();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${dnd?.toJson()}'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onUpdateDoNotDisturbClicked() async {
    try {
      await Notificare.device().updateDoNotDisturb(
        NotificareDoNotDisturb(
          start: NotificareTime.fromString('23:00'),
          end: NotificareTime(hours: 8, minutes: 0),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onClearDoNotDisturbClicked() async {
    try {
      await Notificare.device().clearDoNotDisturb();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchUserDataClicked() async {
    try {
      final userData = await Notificare.device().fetchUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$userData'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onUpdateUserDataClicked() async {
    try {
      await Notificare.device().updateUserData({
        'firstName': 'Helder',
        'lastName': 'Pinhal',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchPreferredLanguageClicked() async {
    try {
      final language = await Notificare.device().preferredLanguage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$language'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onUpdatePreferredLanguageClicked() async {
    try {
      await Notificare.device().updatePreferredLanguage('nl-NL');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onClearPreferredLanguageClicked() async {
    try {
      await Notificare.device().updatePreferredLanguage(null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchAssetsClicked() async {
    try {
      final assets = await NotificareAssets.fetch(group: 'LANDSCAPES');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${assets.map((asset) => asset.title)}'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onCreateUserAccountClicked() async {
    try {
      if (await NotificareAuthentication.isLoggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('There is a logged in user.'),
          ),
        );

        return;
      }

      await NotificareAuthentication.createAccount(
        email: 'helder@notifica.re',
        password: '123456',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onLoginClicked() async {
    try {
      await NotificareAuthentication.login(
        email: 'helder@notifica.re',
        password: '123456',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onLogoutClicked() async {
    try {
      await NotificareAuthentication.logout();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchUserDetailsClicked() async {
    try {
      final user = await NotificareAuthentication.fetchUserDetails();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.toJson()}'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchUserPreferencesClicked() async {
    try {
      final preferences = await NotificareAuthentication.fetchUserPreferences();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${preferences.map((e) => e.toJson())}'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchUserSegmentsClicked() async {
    try {
      final segments = await NotificareAuthentication.fetchUserSegments();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${segments.map((e) => e.toJson())}'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onSendPasswordResetClicked() async {
    try {
      await NotificareAuthentication.sendPasswordReset(email: 'helder@notifica.re');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onResetPasswordClicked() async {
    try {
      await NotificareAuthentication.resetPassword("123456", token: "token");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onChangePasswordClicked() async {
    try {
      await NotificareAuthentication.changePassword('123456');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onValidateUserClicked() async {
    try {
      await NotificareAuthentication.validateUser(token: 'token');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onGeneratePushEmailClicked() async {
    try {
      await NotificareAuthentication.generatePushEmailAddress();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onAddUserSegmentClicked() async {
    try {
      final segments = await NotificareAuthentication.fetchUserSegments();
      await NotificareAuthentication.addUserSegment(segments.first);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onRemoveUserSegmentClicked() async {
    try {
      final segments = await NotificareAuthentication.fetchUserSegments();
      await NotificareAuthentication.removeUserSegment(segments.first);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onAddUserSegmentToPreferenceClicked() async {
    try {
      final preferences = await NotificareAuthentication.fetchUserPreferences();

      final preference = preferences.first;
      final option = preference.options.first;

      await NotificareAuthentication.addUserSegmentToPreference(
        preference: preference,
        option: option,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onRemoveUserSegmentFromPreferenceClicked() async {
    try {
      final preferences = await NotificareAuthentication.fetchUserPreferences();

      final preference = preferences.first;
      final option = preference.options.first;

      await NotificareAuthentication.removeUserSegmentFromPreference(
        preference: preference,
        option: option,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onStartScannableSessionClicked() async {
    try {
      // await NotificareScannables.startScannableSession();

      if (await NotificareScannables.canStartNfcScannableSession) {
        await NotificareScannables.startNfcScannableSession();
      } else {
        await NotificareScannables.startQrCodeScannableSession();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onFetchPassClicked() async {
    try {
      final pass = await NotificareLoyalty.fetchPassBySerial("42dcb3e9-76dd-4451-a0cf-1d15545d415f");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pass.toJson()}'),
        ),
      );

      await NotificareLoyalty.present(pass: pass);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onCheckSuppressedStateClicked() async {
    try {
      final suppressed = await NotificareInAppMessaging.hasMessagesSuppressed;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Suppressed = $suppressed'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onSuppressMessagesClicked() async {
    try {
      await NotificareInAppMessaging.setMessagesSuppressed(true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onUnSuppressMessagesClicked() async {
    try {
      await NotificareInAppMessaging.setMessagesSuppressed(false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Done.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
