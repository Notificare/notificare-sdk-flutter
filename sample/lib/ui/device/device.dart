import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notificare/notificare.dart';
import 'package:sample/ui/device/views/device_data_field_view.dart';

import '../../main.dart';

class DeviceView extends StatefulWidget {
  const DeviceView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  Map<String, String> _currentDeviceData = <String, String>{};
  Map<String, String> _userData = <String, String>{};

  @override
  void initState() {
    super.initState();

    _getDeviceData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Device'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    "Current Device".toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium,
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
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Column(
                  children: [
                    _currentDeviceData.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _currentDeviceData.length,
                            itemBuilder: (context, i) {
                              final dataKey = _currentDeviceData.keys.elementAt(i);
                              final dataValue = _currentDeviceData.values.elementAt(i);
                              return Column(
                                children: [
                                  DeviceDataFieldView(dataKey: dataKey, dataValue: dataValue),
                                  _currentDeviceData.length > i ? const Divider(height: 0) : Container(),
                                ],
                              );
                            },
                          )
                        : Row(
                            children: const [
                              Text(
                                "No data",
                                style: App.secondaryText,
                              ),
                            ],
                          ),
                  ],
                ),
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
                    margin: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                    child: Row(
                      children: [
                        Text("User Data", style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: _userData.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: _userData.length,
                            itemBuilder: (context, i) {
                              return Container(
                                margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                child: Row(
                                  children: [
                                    Text(_userData.keys.elementAt(i)),
                                    const Spacer(),
                                    Text(_userData.values.elementAt(i)),
                                  ],
                                ),
                              );
                            },
                          )
                        : Row(
                            children: const [
                              Text(
                                "No data",
                                style: App.secondaryText,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 32, 16, 8),
              child: Row(
                children: [
                  Text(
                    "Registration".toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(onPressed: _onRegisterDeviceWithUserClicked, child: const Text("Register with User")),
                  const Divider(height: 0),
                  TextButton(
                      onPressed: _onRegisterDeviceWithAnonymousUserClicked, child: const Text("Register as Anonymous")),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 32, 16, 8),
              child: Row(
                children: [
                  Text(
                    "Language".toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                      onPressed: _onUpdatePreferredLanguageClicked, child: const Text("Update preferred language")),
                  const Divider(height: 0),
                  TextButton(
                      onPressed: _onClearPreferredLanguageClicked, child: const Text("Clear preferred language")),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 32, 16, 8),
              child: Row(
                children: [
                  Text(
                    "User Data".toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(onPressed: _onUpdateUserDataClicked, child: const Text("Update user data")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getDeviceData() async {
    try {
      Logger().i('Getting current device data.');

      final currentDevice = await Notificare.device().currentDevice;
      if (currentDevice == null) {
        return;
      }

      final userName = currentDevice.userName;
      final dnd = currentDevice.dnd;
      final currentDeviceData = <String, String>{};
      final preferredLanguage = await Notificare.device().preferredLanguage;
      final userData = await Notificare.device().fetchUserData();

      currentDeviceData["ID"] = currentDevice.id.length > 14
          ? "..." + currentDevice.id.substring(currentDevice.id.length - 14)
          : currentDevice.id;
      currentDeviceData["User Name"] =
          userName != null && userName.length > 14 ? userName.substring(0, 14) + "..." : userName.toString();
      currentDeviceData["Registered"] = currentDevice.lastRegistered.toLocal().toString();
      currentDeviceData["DnD"] = dnd != null ? "${dnd.start} - ${dnd.end}" : "";
      currentDeviceData["Region"] = currentDevice.region;
      currentDeviceData["Language"] = currentDevice.language;
      currentDeviceData["Preferred Language"] = preferredLanguage.toString();
      currentDeviceData["Transport"] = currentDevice.transport;
      currentDeviceData["OS Version"] = currentDevice.osVersion;
      currentDeviceData["SDK Version"] = currentDevice.sdkVersion;

      setState(() {
        _currentDeviceData = currentDeviceData;
        _userData = userData;
      });

      Logger().i('Got current device data successfully.');
    } catch (error) {
      Logger().e('Getting current device data error.', error);

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
      Logger().i('Notificare register device with user clicked.');
      await Notificare.device().register(
        userId: 'helder@notifica.re',
        userName: 'Helder Pinhal',
      );

      _getDeviceData();

      Logger().i('Notificare registered device with user successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notificare registered device with user successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Notificare register device with user error.', error);

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
      Logger().i('Notificare register device with anonymous clicked.');
      await Notificare.device().register(
        userId: null,
        userName: null,
      );

      _getDeviceData();

      Logger().i('Notificare registered device with anonymous successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notificare registered device with anonymous successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Notificare register device with anonymous error.', error);

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
      Logger().i('Update preferred language clicked.');
      await Notificare.device().updatePreferredLanguage('nl-NL');

      _getDeviceData();

      Logger().i('Updated preferred language successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updated preferred language successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Update preferred language error.', error);

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
      Logger().i('Clear preferred language clicked.');
      await Notificare.device().updatePreferredLanguage(null);

      _getDeviceData();

      Logger().i('Clear preferred language successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clear preferred language successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Clear preferred language error.', error);

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
      Logger().i('Update user data clicked.');
      await Notificare.device().updateUserData({
        'firstName': 'Helder',
        'lastName': 'Pinhal',
      });

      _getDeviceData();

      Logger().i('Updated user data successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updated user data successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Updated user data error.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
