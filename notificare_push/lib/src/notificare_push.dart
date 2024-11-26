import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_push/notificare_push.dart';

class NotificarePush {
  NotificarePush._();

  static const MethodChannel _channel = MethodChannel(
    're.notifica.push.flutter/notificare_push',
    JSONMethodCodec(),
  );

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  /// Defines the authorization options used when requesting push notification
  /// permissions.
  ///
  /// **Note**: This method is only supported on iOS.
  ///
  /// - `options`: The authorization options to be set.
  static Future<void> setAuthorizationOptions(List<String> options) async {
    if (Platform.isIOS) {
      await _channel.invokeMapMethod('setAuthorizationOptions', options);
    }
  }

  /// Defines the notification category options for custom notification actions.
  ///
  /// **Note**: This method is only supported on iOS.
  ///
  /// - `options`: The category options to be set
  static Future<void> setCategoryOptions(List<String> options) async {
    if (Platform.isIOS) {
      await _channel.invokeMapMethod('setCategoryOptions', options);
    }
  }

  /// Defines the presentation options for displaying notifications while the app
  /// is in the foreground.
  ///
  /// **Note**: This method is only supported on iOS.
  ///
  /// - `options`: The presentation options to be set.
  static Future<void> setPresentationOptions(List<String> options) async {
    if (Platform.isIOS) {
      await _channel.invokeMapMethod('setPresentationOptions', options);
    }
  }

  /// Indicates whether remote notifications are enabled.
  ///
  /// Returns `true` if remote notifications are enabled for the application, and
  /// `false` otherwise.
  static Future<bool> get hasRemoteNotificationsEnabled async {
    return await _channel.invokeMethod('hasRemoteNotificationsEnabled');
  }

  /// Provides the current push transport information.
  ///
  /// @returns The [NotificareTransport] assigned to the device.
  static Future<NotificareTransport?> get transport async {
    final json = await _channel.invokeMethod('getTransport');
    return json != null ? NotificareTransport.fromJson(json) : null;
  }

  /// Provides the current push subscription token.
  ///
  /// Returns the [NotificarePushSubscription] object containing the
  /// device's current push subscription token, or `null` if no token is available.
  static Future<NotificarePushSubscription?> get subscription async {
    final json = await _channel.invokeMethod('getSubscription');
    return json != null ? NotificarePushSubscription.fromJson(json) : null;
  }

  /// Indicates whether the device is capable of receiving remote notifications.
  ///
  /// This function returns `true` if the user has granted permission to receive
  /// push notifications and the device has successfully obtained a push token
  /// from the notification service. It reflects whether the app can present
  /// notifications as allowed by the system and user settings.
  ///
  /// Return `true` if the device can receive remote notifications, `false`
  /// otherwise.
  static Future<bool> get allowedUI async {
    return await _channel.invokeMethod('allowedUI');
  }

  /// Enables remote notifications.
  ///
  /// This function enables remote notifications for the application,
  /// allowing push notifications to be received.
  ///
  /// **Note**: Starting with Android 13 (API level 33), this function requires
  /// the developer to explicitly request the `POST_NOTIFICATIONS` permission from
  /// the user.
  static Future<void> enableRemoteNotifications() async {
    await _channel.invokeMapMethod('enableRemoteNotifications');
  }

  /// Disables remote notifications.
  ///
  /// This function disables remote notifications for the application, preventing
  /// push notifications from being received.
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
      _eventStreams[eventType] =
          _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  /// Called when a push notification is received.
  ///
  /// It will provide a [NotificareNotificationReceivedEvent] containing the
  /// [NotificareNotification] received and the
  /// [NotificareNotificationDeliveryMechanism] used for its delivery.
  static Stream<NotificareNotificationReceivedEvent>
      get onNotificationInfoReceived {
    return _getEventStream('notification_info_received').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotificationReceivedEvent.fromJson(json.cast());
    });
  }

  /// Called when a custom system notification is received.
  ///
  /// It will provide the [NotificareSystemNotification] received.
  static Stream<NotificareSystemNotification> get onSystemNotificationReceived {
    return _getEventStream('system_notification_received').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareSystemNotification.fromJson(json.cast());
    });
  }

  /// Called when an unknown notification is received.
  ///
  /// It will provide the unknown notification received.
  static Stream<Map<String, dynamic>> get onUnknownNotificationReceived {
    return _getEventStream('unknown_notification_received').map((result) {
      final Map<dynamic, dynamic> json = result;
      return json.cast();
    });
  }

  /// Called when a push notification is opened by the user.
  ///
  /// It will provide the [NotificareNotification] that was opened.
  static Stream<NotificareNotification> get onNotificationOpened {
    return _getEventStream('notification_opened').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  /// Called when an unknown push notification is opened by the user.
  ///
  /// It will provide the unknown notification that was opened.
  static Stream<Map<String, dynamic>> get onUnknownNotificationOpened {
    return _getEventStream('unknown_notification_opened').map((result) {
      final Map<dynamic, dynamic> json = result;
      return json.cast();
    });
  }

  /// Called when a push notification action is opened by the user.
  ///
  /// It will provide a [NotificareNotificationActionOpenedEvent] containing the
  /// [NotificareNotificationAction] opened by the user and the
  /// [NotificareNotification] containing it.
  static Stream<NotificareNotificationActionOpenedEvent>
      get onNotificationActionOpened {
    return _getEventStream('notification_action_opened').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotificationActionOpenedEvent.fromJson(json.cast());
    });
  }

  /// Called when an unknown push notification action is opened by the user.
  ///
  /// It will provide a [NotificareUnknownNotificationActionOpenedEvent]
  /// containing the action opened by the user and the unknown notification
  /// containing it. It will also provide a response text, if it exists.
  static Stream<NotificareUnknownNotificationActionOpenedEvent>
      get onUnknownNotificationActionOpened {
    return _getEventStream('unknown_notification_action_opened').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareUnknownNotificationActionOpenedEvent.fromJson(
        json.cast(),
      );
    });
  }

  /// Called when the notification settings are changed.
  ///
  /// It will provide a boolean indicating whether the app is permitted to
  /// display notifications. `true` if notifications are allowed, `false` if they
  /// are restricted by the user.
  static Stream<bool> get onNotificationSettingsChanged {
    return _getEventStream('notification_settings_changed').map((result) {
      return result as bool;
    });
  }

  /// Called when the device's push subscription changes.
  ///
  /// It will provide the updated [NotificarePushSubscription], or `null` if the
  /// subscription token is unavailable.
  static Stream<NotificarePushSubscription?> get onSubscriptionChanged {
    return _getEventStream('subscription_changed').map((result) {
      final Map<dynamic, dynamic>? json = result;
      return json != null
          ? NotificarePushSubscription.fromJson(json.cast())
          : null;
    });
  }

  /// Called when a notification prompts the app to open its settings screen.
  ///
  /// It will provide the [NotificareNotification] that prompted the app to open
  /// its settings screen.
  static Stream<NotificareNotification?> get onShouldOpenNotificationSettings {
    return _getEventStream('should_open_notification_settings').map((result) {
      if (result == null) return null;

      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  ///  Called when the app encounters an error during the registration process for
  ///  push notifications.
  ///
  /// It will provide the error that caused the registration to fail.
  static Stream<String> get onFailedToRegisterForRemoteNotifications {
    return _getEventStream('failed_to_register_for_remote_notifications')
        .map((result) {
      return result as String;
    });
  }
}
