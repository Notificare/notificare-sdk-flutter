import 'package:flutter/services.dart';
import 'package:notificare/models/notificare_device.dart';
import 'package:notificare/models/notificare_do_not_disturb.dart';

class NotificareEventsManager {
  final MethodChannel _channel;

  NotificareEventsManager(this._channel);

  Future<void> logCustom(
    String event, {
    Map<String, dynamic>? data,
  }) async {
    await _channel.invokeMethod('logCustom', {
      'event': event,
      'data': data,
    });
  }
}
