import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare_in_app_messaging/src/events/notificare_action_executed_event.dart';
import 'package:notificare_in_app_messaging/src/events/notificare_action_failed_to_execute_event.dart';
import 'package:notificare_in_app_messaging/src/models/notificare_in_app_message.dart';

class NotificareInAppMessaging {
  NotificareInAppMessaging._();

  // Channels
  static const _channel = MethodChannel(
    're.notifica.iam.flutter/notificare_in_app_messaging',
    JSONMethodCodec(),
  );

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  static Future<bool> get hasMessagesSuppressed async {
    return await _channel.invokeMethod('hasMessagesSuppressed');
  }

  static Future<void> setMessagesSuppressed(
    bool suppressed, {
    bool? evaluateContext,
  }) async {
    await _channel.invokeMethod('setMessagesSuppressed', {
      "suppressed": suppressed,
      "evaluateContext": evaluateContext,
    });
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.iam.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name, const JSONMethodCodec());
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] =
          _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  static Stream<NotificareInAppMessage> get onMessagePresented {
    return _getEventStream('message_presented').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareInAppMessage.fromJson(json.cast());
    });
  }

  static Stream<NotificareInAppMessage> get onMessageFinishedPresenting {
    return _getEventStream('message_finished_presenting').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareInAppMessage.fromJson(json.cast());
    });
  }

  static Stream<NotificareInAppMessage> get onMessageFailedToPresent {
    return _getEventStream('message_failed_to_present').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareInAppMessage.fromJson(json.cast());
    });
  }

  static Stream<NotificareActionExecutedEvent> get onActionExecuted {
    return _getEventStream('action_executed').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionExecutedEvent.fromJson(json.cast());
    });
  }

  static Stream<NotificareActionFailedToExecuteEvent>
      get onActionFailedToExecute {
    return _getEventStream('action_failed_to_execute').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionFailedToExecuteEvent.fromJson(json.cast());
    });
  }
}
