import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notificare/notificare.dart';

import '../../main.dart';

class CustomEventsView extends StatefulWidget {
  const CustomEventsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomEventsViewState();
}

class _CustomEventsViewState extends State<CustomEventsView> {
  final _dataFields = {
    'key_one': 'value_one',
    'key_two': 'value_two',
  };
  final _controller = TextEditingController();

  String _eventName = "";
  bool _shouldIncludeFields = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Custom Event'),
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
                    "Register Event".toUpperCase(),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: UnderlineInputBorder(),
                        labelText: 'Event Name',
                      ),
                      onChanged: _didChangeEventName,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Data fields", style: App.secondaryText),
                      Checkbox(
                        value: _shouldIncludeFields,
                        onChanged: _didChangeDataFieldCheckBox,
                      ),
                    ],
                  ),
                  const Divider(height: 0),
                  TextButton(
                    child: const Text("Register"),
                    onPressed: _eventName != "" ? _onRegisterCustomEventClicked : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _didChangeEventName(name) {
    setState(() {
      _eventName = name;
    });
  }

  void _didChangeDataFieldCheckBox(checked) {
    setState(() {
      _shouldIncludeFields = checked;
    });
  }

  void _onRegisterCustomEventClicked() async {
    try {
      Logger().i('Register custom event clicked.');

      if (_shouldIncludeFields) {
        await Notificare.events().logCustom(_eventName, data: _dataFields);
      } else {
        await Notificare.events().logCustom(_eventName);
      }

      _controller.clear();
      setState(() {
        _eventName = "";
        _shouldIncludeFields = false;
      });

      Logger().i('Registered custom event successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registered custom event successfully.'),
        ),
      );
    } catch (error) {
      Logger().e('Register custom event failed.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
