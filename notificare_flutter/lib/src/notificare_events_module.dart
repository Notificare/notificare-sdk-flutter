import 'package:flutter/services.dart';

class NotificareEventsModule {
  final MethodChannel _channel;

  NotificareEventsModule(this._channel);

  /// Logs in Notificare a custom event in the application.
  ///
  /// This function allows logging, in Notificare, of application-specific events,
  /// optionally associating structured data for more detailed event tracking and
  /// analysis.
  ///
  /// - `event`: The name of the custom event to log.
  /// - `data`: Optional structured event data for further details.
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
