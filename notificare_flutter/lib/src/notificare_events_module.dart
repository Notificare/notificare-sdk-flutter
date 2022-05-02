import 'package:flutter/services.dart';

class NotificareEventsModule {
  final MethodChannel _channel;

  NotificareEventsModule(this._channel);

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
