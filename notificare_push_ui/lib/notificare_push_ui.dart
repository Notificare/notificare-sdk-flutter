import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare/models/notificare_notification.dart';
import 'package:notificare_push_ui/notificare_push_ui_events.dart';

class NotificarePushUI {
  static const MethodChannel _channel =
      const MethodChannel('re.notifica.push.ui.flutter/notificare_push_ui', JSONMethodCodec());

  // Events
  static Map<String, EventChannel> _eventChannels = new Map();
  static Map<String, Stream<dynamic>> _eventStreams = new Map();

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

  static Stream<NotificationUrlClickedEvent> get onNotificationUrlClicked {
    return _getEventStream('notification_url_clicked').map((result) {
      final Map<dynamic, dynamic> notification = result['notification'];
      final String url = result['url'] as String;

      return NotificationUrlClickedEvent(
        notification: NotificareNotification.fromJson(notification.cast()),
        url: url,
      );
    });
  }

  static Stream<ActionWillExecuteEvent> get onActionWillExecute {
    return _getEventStream('action_will_execute').map((result) {
      final Map<dynamic, dynamic> notification = result['notification'];
      final Map<dynamic, dynamic> action = result['action'];

      return ActionWillExecuteEvent(
        notification: NotificareNotification.fromJson(notification.cast()),
        action: NotificareNotificationAction.fromJson(action.cast()),
      );
    });
  }

  static Stream<ActionExecutedEvent> get onActionExecuted {
    return _getEventStream('action_executed').map((result) {
      final Map<dynamic, dynamic> notification = result['notification'];
      final Map<dynamic, dynamic> action = result['action'];

      return ActionExecutedEvent(
        notification: NotificareNotification.fromJson(notification.cast()),
        action: NotificareNotificationAction.fromJson(action.cast()),
      );
    });
  }

  static Stream<ActionNotExecutedEvent> get onActionNotExecuted {
    return _getEventStream('action_not_executed').map((result) {
      final Map<dynamic, dynamic> notification = result['notification'];
      final Map<dynamic, dynamic> action = result['action'];

      return ActionNotExecutedEvent(
        notification: NotificareNotification.fromJson(notification.cast()),
        action: NotificareNotificationAction.fromJson(action.cast()),
      );
    });
  }

  static Stream<ActionFailedToExecuteEvent> get onActionFailedToExecute {
    return _getEventStream('action_failed_to_execute').map((result) {
      final Map<dynamic, dynamic> notification = result['notification'];
      final Map<dynamic, dynamic> action = result['action'];
      final String? error = result['error'] != null ? result['error'] as String : null;

      return ActionFailedToExecuteEvent(
        notification: NotificareNotification.fromJson(notification.cast()),
        action: NotificareNotificationAction.fromJson(action.cast()),
        error: error,
      );
    });
  }

  static Stream<String> get onCustomActionReceived {
    return _getEventStream('custom_action_received').map((result) {
      return result as String;
    });
  }
}
