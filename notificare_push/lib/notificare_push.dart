import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:notificare/models/notificare_notification.dart';
import 'package:notificare_push/events/notification_action_opened_event.dart';
import 'package:notificare_push/models/notificare_system_notification.dart';

class NotificarePush {
  static const MethodChannel _channel =
      const MethodChannel('re.notifica.push.flutter/notificare_push', JSONMethodCodec());

  // Events
  static Map<String, EventChannel> _eventChannels = new Map();
  static Map<String, Stream<dynamic>> _eventStreams = new Map();

  static Future<void> setAuthorizationOptions(List<String> options) async {
    if (Platform.isIOS) {
      await _channel.invokeMapMethod('setAuthorizationOptions', options);
    } else {
      log(
        'Setting the authorization options has no effect on this platform.',
        time: DateTime.now(),
        name: 'Notificare',
      );
    }
  }

  static Future<void> setCategoryOptions(List<String> options) async {
    if (Platform.isIOS) {
      await _channel.invokeMapMethod('setCategoryOptions', options);
    } else {
      log(
        'Setting the category options has no effect on this platform.',
        time: DateTime.now(),
        name: 'Notificare',
      );
    }
  }

  static Future<void> setPresentationOptions(List<String> options) async {
    if (Platform.isIOS) {
      await _channel.invokeMapMethod('setPresentationOptions', options);
    } else {
      log(
        'Setting the presentation options has no effect on this platform.',
        time: DateTime.now(),
        name: 'Notificare',
      );
    }
  }

  static Future<void> enableRemoteNotifications() async {
    await _channel.invokeMapMethod('enableRemoteNotifications');
  }

  static Future<void> disableRemoteNotifications() async {
    await _channel.invokeMapMethod('disableRemoteNotifications');
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.push.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name, JSONMethodCodec());
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] = _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  static Stream<NotificareNotification> get onNotificationReceived {
    return _getEventStream('notification_received').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  static Stream<NotificareSystemNotification> get onSystemNotificationReceived {
    return _getEventStream('system_notification_received').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareSystemNotification.fromJson(json.cast());
    });
  }

  static Stream<Map<String, dynamic>> get onUnknownNotificationReceived {
    return _getEventStream('unknown_notification_received').map((result) {
      final Map<dynamic, dynamic> json = result;
      return json.cast();
    });
  }

  static Stream<NotificareNotification> get onNotificationOpened {
    return _getEventStream('notification_opened').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  static Stream<NotificationActionOpenedEvent> get onNotificationActionOpened {
    return _getEventStream('notification_action_opened').map((result) {
      final Map<dynamic, dynamic> notification = result['notification'];
      final Map<dynamic, dynamic> action = result['action'];

      return NotificationActionOpenedEvent(
        notification: NotificareNotification.fromJson(notification.cast()),
        action: NotificareNotificationAction.fromJson(action.cast()),
      );
    });
  }

  static Stream<bool>? get onNotificationSettingsChanged {
    if (Platform.isIOS) {
      return _getEventStream('notification_settings_changed').map((result) {
        return result as bool;
      });
    } else {
      return null;
    }
  }

  static Stream<NotificareNotification?>? get onShouldOpenNotificationSettings {
    if (Platform.isIOS) {
      return _getEventStream('should_open_notification_settings').map((result) {
        if (result == null) return null;

        final Map<dynamic, dynamic> json = result;
        return NotificareNotification.fromJson(json.cast());
      });
    } else {
      return null;
    }
  }

  static Stream<String>? get onFailedToRegisterForRemoteNotifications {
    if (Platform.isIOS) {
      return _getEventStream('failed_to_register_for_remote_notifications').map((result) {
        return result as String;
      });
    } else {
      return null;
    }
  }
}