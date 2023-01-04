import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_push/notificare_push.dart';
import 'package:notificare_push/src/events/notificare_notification_action_opened_event.dart';
import 'package:notificare_push/src/models/notificare_live_activity_update.dart';
import 'package:notificare_push/src/models/notificare_system_notification.dart';

class NotificarePush {
  NotificarePush._();

  static const MethodChannel _channel = MethodChannel('re.notifica.push.flutter/notificare_push', JSONMethodCodec());

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  static Future<void> setAuthorizationOptions(List<String> options) async {
    if (Platform.isIOS) {
      await _channel.invokeMapMethod('setAuthorizationOptions', options);
    }
  }

  static Future<void> setCategoryOptions(List<String> options) async {
    if (Platform.isIOS) {
      await _channel.invokeMapMethod('setCategoryOptions', options);
    }
  }

  static Future<void> setPresentationOptions(List<String> options) async {
    if (Platform.isIOS) {
      await _channel.invokeMapMethod('setPresentationOptions', options);
    }
  }

  static Future<bool> get hasRemoteNotificationsEnabled async {
    return await _channel.invokeMethod('hasRemoteNotificationsEnabled');
  }

  static Future<bool> get allowedUI async {
    return await _channel.invokeMethod('allowedUI');
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

  static Stream<Map<String, dynamic>> get onUnknownNotificationOpened {
    return _getEventStream('unknown_notification_opened').map((result) {
      final Map<dynamic, dynamic> json = result;
      return json.cast();
    });
  }

  static Stream<NotificareNotificationActionOpenedEvent> get onNotificationActionOpened {
    return _getEventStream('notification_action_opened').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotificationActionOpenedEvent.fromJson(json.cast());
    });
  }

  static Stream<NotificareUnknownNotificationActionOpenedEvent> get onUnknownNotificationActionOpened {
    return _getEventStream('unknown_notification_action_opened').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareUnknownNotificationActionOpenedEvent.fromJson(json.cast());
    });
  }

  static Stream<bool> get onNotificationSettingsChanged {
    return _getEventStream('notification_settings_changed').map((result) {
      return result as bool;
    });
  }

  static Stream<NotificareNotification?> get onShouldOpenNotificationSettings {
    return _getEventStream('should_open_notification_settings').map((result) {
      if (result == null) return null;

      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  static Stream<String> get onFailedToRegisterForRemoteNotifications {
    return _getEventStream('failed_to_register_for_remote_notifications').map((result) {
      return result as String;
    });
  }

  static Future<void> registerLiveActivity(
      {required String activityId, String? token, List<String>? topics}) async {
    final json = {
      "activityId": activityId,
      "token": token,
      "topics": topics,
    };

    await _channel.invokeMethod('registerLiveActivity', json);
  }

  static Future<void> endLiveActivity(String activityId) async {
    await _channel.invokeMethod('endLiveActivity', activityId);
  }

  static Stream<NotificareLiveActivityUpdate> get onLiveActivityUpdate {
    return _getEventStream('live_activity_update').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareLiveActivityUpdate.fromJson(json.cast());
    });
  }

  static Stream<String> get onTokenChanged {
    return _getEventStream('token_changed').map((token) {
      return token;
    });
  }
}
