import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare/models/notificare_notification.dart';

class NotificarePushUI {
  static const MethodChannel _channel =
      const MethodChannel('re.notifica.push.ui.flutter/notificare_push_ui', JSONMethodCodec());

  static Future<void> presentNotification(NotificareNotification notification) async {
    await _channel.invokeMethod('presentNotification', notification.toJson());
  }

  static Future<void> presentAction(NotificareNotification notification, NotificareNotificationAction action) async {
    await _channel.invokeMethod('presentAction', {
      'notification': notification.toJson(),
      'action': action.toJson(),
    });
  }
}
