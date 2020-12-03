import 'package:flutter/services.dart';

class NotificarePushManager {
  final MethodChannel _channel;

  NotificarePushManager(this._channel);

  Future<void> enableRemoteNotifications() async {
    await _channel.invokeMethod('enableRemoteNotifications');
  }
}
