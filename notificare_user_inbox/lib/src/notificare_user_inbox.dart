import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_user_inbox/src/models/notificare_user_inbox_item.dart';
import 'package:notificare_user_inbox/src/models/notificare_user_inbox_response.dart';

class NotificareUserInbox {
  NotificareUserInbox._();

  // Channels
  static const _channel = MethodChannel('re.notifica.inbox.user.flutter/notificare_user_inbox', JSONMethodCodec());

  static Future<NotificareUserInboxResponse> parseResponseFromJSON(Map<String, dynamic> json) async {
    final result = await _channel.invokeMapMethod<String, dynamic>('parseResponseFromJSON', json);
    return NotificareUserInboxResponse.fromJson(result!);
  }

  static Future<NotificareUserInboxResponse> parseResponseFromString(String json) async {
    final result = await _channel.invokeMapMethod<String, dynamic>('parseResponseFromString', json);
    return NotificareUserInboxResponse.fromJson(result!);
  }

  static Future<NotificareNotification> open(NotificareUserInboxItem item) async {
    final result = await _channel.invokeMapMethod<String, dynamic>('open', item.toJson());
    return NotificareNotification.fromJson(result!);
  }

  static Future<void> markAsRead(NotificareUserInboxItem item) async {
    await _channel.invokeMethod('markAsRead', item.toJson());
  }

  static Future<void> remove(NotificareUserInboxItem item) async {
    await _channel.invokeMethod('remove', item.toJson());
  }
}
