import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_inbox/src/models/notificare_inbox_item.dart';

class NotificareInbox {
  NotificareInbox._();

  // Channels
  static const _channel = MethodChannel('re.notifica.inbox.flutter/notificare_inbox', JSONMethodCodec());

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  static Future<List<NotificareInboxItem>> get items async {
    final json = await _channel.invokeListMethod<Map<String, dynamic>>('getItems');
    return json!.map((e) => NotificareInboxItem.fromJson(e)).toList();
  }

  static Future<int> get badge async {
    return await _channel.invokeMethod('getBadge');
  }

  static Future<void> refresh() async {
    await _channel.invokeMethod('refresh');
  }

  static Future<NotificareNotification> open(NotificareInboxItem item) async {
    final json = await _channel.invokeMapMethod<String, dynamic>('open', item.toJson());
    return NotificareNotification.fromJson(json!);
  }

  static Future<void> markAsRead(NotificareInboxItem item) async {
    await _channel.invokeMethod('markAsRead', item.toJson());
  }

  static Future<void> markAllAsRead() async {
    await _channel.invokeMethod('markAllAsRead');
  }

  static Future<void> remove(NotificareInboxItem item) async {
    await _channel.invokeMethod('remove', item.toJson());
  }

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
      _eventStreams[eventType] = _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  static Stream<List<NotificareInboxItem>> get onInboxUpdated {
    return _getEventStream('inbox_updated').map((result) {
      final List<dynamic> items = result;

      return items.map((item) {
        final Map json = item;
        return NotificareInboxItem.fromJson(json.cast());
      }).toList();
    });
  }

  static Stream<int> get onBadgeUpdated {
    return _getEventStream('badge_updated').map((result) {
      return result as int;
    });
  }
}
