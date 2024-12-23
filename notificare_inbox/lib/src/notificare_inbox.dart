import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_inbox/src/models/notificare_inbox_item.dart';

class NotificareInbox {
  NotificareInbox._();

  // Channels
  static const _channel = MethodChannel(
    're.notifica.inbox.flutter/notificare_inbox',
    JSONMethodCodec(),
  );

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  /// Returns a list of all [NotificareInboxItem], sorted by the timestamp.
  static Future<List<NotificareInboxItem>> get items async {
    final json =
        await _channel.invokeListMethod<Map<String, dynamic>>('getItems');
    return json!.map((e) => NotificareInboxItem.fromJson(e)).toList();
  }

  /// Returns The current badge count, representing the number of unread inbox
  /// items.
  static Future<int> get badge async {
    return await _channel.invokeMethod('getBadge');
  }

  /// Refreshes the inbox data, ensuring the items and badge count reflect the
  /// latest server state.
  static Future<void> refresh() async {
    await _channel.invokeMethod('refresh');
  }

  /// Opens a specified inbox item, marking it as read and returning the
  /// associated notification.
  ///
  /// - `item`: The [NotificareInboxItem] to open.
  /// 
  /// Returns the [NotificareNotification] associated with the inbox item.
  static Future<NotificareNotification> open(NotificareInboxItem item) async {
    final json =
        await _channel.invokeMapMethod<String, dynamic>('open', item.toJson());
    return NotificareNotification.fromJson(json!);
  }

  /// Marks the specified inbox item as read.
  ///
  /// - `item`: The [NotificareInboxItem] to mark as read.
  static Future<void> markAsRead(NotificareInboxItem item) async {
    await _channel.invokeMethod('markAsRead', item.toJson());
  }

  /// Marks all inbox items as read.
  static Future<void> markAllAsRead() async {
    await _channel.invokeMethod('markAllAsRead');
  }

  /// Permanently removes the specified inbox item from the inbox.
  ///
  /// - `item`: The [NotificareInboxItem] to remove.
  static Future<void> remove(NotificareInboxItem item) async {
    await _channel.invokeMethod('remove', item.toJson());
  }

  /// Clears all inbox items, permanently deleting them from the inbox.
  static Future<void> clear() async {
    await _channel.invokeMethod('clear');
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.inbox.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name, JSONMethodCodec());
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] =
          _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  /// Called when the inbox is successfully updated.
  ///
  /// It will provide an updated list of [NotificareInboxItem].
  static Stream<List<NotificareInboxItem>> get onInboxUpdated {
    return _getEventStream('inbox_updated').map((result) {
      final List<dynamic> items = result;

      return items.map((item) {
        final Map json = item;
        return NotificareInboxItem.fromJson(json.cast());
      }).toList();
    });
  }

  /// Called when the unread message count badge is updated.
  ///
  /// It will provide an updated badge count, representing current the number of
  /// unread inbox items.
  static Stream<int> get onBadgeUpdated {
    return _getEventStream('badge_updated').map((result) {
      return result as int;
    });
  }
}
