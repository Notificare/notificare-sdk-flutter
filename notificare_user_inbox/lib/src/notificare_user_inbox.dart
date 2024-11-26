import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_user_inbox/src/models/notificare_user_inbox_item.dart';
import 'package:notificare_user_inbox/src/models/notificare_user_inbox_response.dart';

class NotificareUserInbox {
  NotificareUserInbox._();

  // Channels
  static const _channel = MethodChannel(
    're.notifica.inbox.user.flutter/notificare_user_inbox',
    JSONMethodCodec(),
  );

  /// Parses a JSON map to produce a [NotificareUserInboxResponse].
  ///
  /// This method takes a raw JSON map and converts it into a structured
  /// [NotificareUserInboxResponse].
  ///
  /// - `json`: The JSON Map representing the user inbox response.
  /// 
  /// Returns a [NotificareUserInboxResponse] object parsed from the provided 
  /// JSON map.
  static Future<NotificareUserInboxResponse> parseResponseFromJSON(
    Map<String, dynamic> json,
  ) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'parseResponseFromJSON',
      json,
    );
    return NotificareUserInboxResponse.fromJson(result!);
  }

  /// Parses a JSON string to produce a [NotificareUserInboxResponse].
  ///
  /// This method takes a raw JSON string and converts it into a structured
  /// [NotificareUserInboxResponse].
  ///
  /// - `json`: The JSON string representing the user inbox response.
  /// 
  /// Returns a [NotificareUserInboxResponse] object parsed from the provided 
  /// JSON string.
  static Future<NotificareUserInboxResponse> parseResponseFromString(
    String json,
  ) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'parseResponseFromString',
      json,
    );
    return NotificareUserInboxResponse.fromJson(result!);
  }

  /// Opens an inbox item and retrieves its associated notification.
  ///
  /// This function opens the provided [NotificareUserInboxItem] and returns the
  /// associated [NotificareNotification].
  /// This operation marks the item as read.
  ///
  /// - `item`: The [NotificareUserInboxItem] to be opened.
  /// 
  /// Returns the [NotificareNotification] associated with the opened inbox
  /// item.
  static Future<NotificareNotification> open(
    NotificareUserInboxItem item,
  ) async {
    final result =
        await _channel.invokeMapMethod<String, dynamic>('open', item.toJson());
    return NotificareNotification.fromJson(result!);
  }

  /// Marks an inbox item as read.
  ///
  /// This function updates the status of the provided [NotificareUserInboxItem]
  /// to read.
  ///
  /// - `item`: The [NotificareUserInboxItem] to mark as read.
  static Future<void> markAsRead(NotificareUserInboxItem item) async {
    await _channel.invokeMethod('markAsRead', item.toJson());
  }

  /// Removes an inbox item from the user's inbox.
  ///
  /// This function deletes the provided {@link NotificareUserInboxItem} from the
  /// user's inbox.
  ///
  /// - `item`: The [NotificareUserInboxItem] to be removed.
  static Future<void> remove(NotificareUserInboxItem item) async {
    await _channel.invokeMethod('remove', item.toJson());
  }
}
