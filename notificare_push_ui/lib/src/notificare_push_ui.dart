import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_push_ui/src/events/notificare_action_executed_event.dart';
import 'package:notificare_push_ui/src/events/notificare_action_failed_to_execute_event.dart';
import 'package:notificare_push_ui/src/events/notificare_action_not_executed_event.dart';
import 'package:notificare_push_ui/src/events/notificare_action_will_execute_event.dart';
import 'package:notificare_push_ui/src/events/notificare_custom_action_received_event.dart';
import 'package:notificare_push_ui/src/events/notificare_notification_url_clicked_event.dart';

class NotificarePushUI {
  NotificarePushUI._();

  static const MethodChannel _channel =
      MethodChannel('re.notifica.push.ui.flutter/notificare_push_ui', JSONMethodCodec());

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  static Future<void> presentNotification(NotificareNotification notification) async {
    await _channel.invokeMethod('presentNotification', notification.toJson());
  }

  static Future<void> presentAction(NotificareNotification notification, NotificareNotificationAction action) async {
    await _channel.invokeMethod('presentAction', {
      'notification': notification.toJson(),
      'action': action.toJson(),
    });
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.push.ui.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name, JSONMethodCodec());
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] = _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  static Stream<NotificareNotification> get onNotificationWillPresent {
    return _getEventStream('notification_will_present').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  static Stream<NotificareNotification> get onNotificationPresented {
    return _getEventStream('notification_presented').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  static Stream<NotificareNotification> get onNotificationFinishedPresenting {
    return _getEventStream('notification_finished_presenting').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  static Stream<NotificareNotification> get onNotificationFailedToPresent {
    return _getEventStream('notification_failed_to_present').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  static Stream<NotificareNotificationUrlClickedEvent> get onNotificationUrlClicked {
    return _getEventStream('notification_url_clicked').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotificationUrlClickedEvent.fromJson(json.cast());
    });
  }

  static Stream<NotificareActionWillExecuteEvent> get onActionWillExecute {
    return _getEventStream('action_will_execute').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionWillExecuteEvent.fromJson(json.cast());
    });
  }

  static Stream<NotificareActionExecutedEvent> get onActionExecuted {
    return _getEventStream('action_executed').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionExecutedEvent.fromJson(json.cast());
    });
  }

  static Stream<NotificareActionNotExecutedEvent> get onActionNotExecuted {
    return _getEventStream('action_not_executed').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionNotExecutedEvent.fromJson(json.cast());
    });
  }

  static Stream<NotificareActionFailedToExecuteEvent> get onActionFailedToExecute {
    return _getEventStream('action_failed_to_execute').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionFailedToExecuteEvent.fromJson(json.cast());
    });
  }

  static Stream<NotificareCustomActionReceivedEvent> get onCustomActionReceived {
    return _getEventStream('custom_action_received').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareCustomActionReceivedEvent.fromJson(json.cast());
    });
  }
}
