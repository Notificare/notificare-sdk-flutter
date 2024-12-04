import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare_in_app_messaging/src/events/notificare_action_executed_event.dart';
import 'package:notificare_in_app_messaging/src/events/notificare_action_failed_to_execute_event.dart';
import 'package:notificare_in_app_messaging/src/models/notificare_in_app_message.dart';

class NotificareInAppMessaging {
  NotificareInAppMessaging._();

  // Channels
  static const _channel = MethodChannel(
    're.notifica.iam.flutter/notificare_in_app_messaging',
    JSONMethodCodec(),
  );

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  /// Indicates whether in-app messages are currently suppressed.
  ///
  /// Returns `true` if message dispatching and the presentation of in-app
  /// messages are temporarily suppressed and `false` if in-app messages are
  /// allowed to be presented.
  static Future<bool> get hasMessagesSuppressed async {
    return await _channel.invokeMethod('hasMessagesSuppressed');
  }

  /// Sets the message suppression state.
  ///
  /// When messages are suppressed, in-app messages will not be presented to the
  /// user. By default, stopping the in-app message suppression does not
  /// re-evaluate the foreground context.
  ///
  /// To trigger a new context evaluation after stopping in-app message
  /// suppression, set the `evaluateContext` parameter to `true`.
  ///
  /// - `suppressed`: Set to `true` to suppress in-app messages, or `false` to
  /// stop suppressing them.
  /// - `evaluateContext`: Set to `true` to re-evaluate the foreground context
  /// when stopping in-app message suppression.
  static Future<void> setMessagesSuppressed(
    bool suppressed, {
    bool? evaluateContext,
  }) async {
    await _channel.invokeMethod('setMessagesSuppressed', {
      "suppressed": suppressed,
      "evaluateContext": evaluateContext,
    });
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.iam.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name, const JSONMethodCodec());
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] =
          _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  /// Called when an in-app message is successfully presented to the user.
  ///
  /// It will provide the [NotificareInAppMessage] that was presented.
  static Stream<NotificareInAppMessage> get onMessagePresented {
    return _getEventStream('message_presented').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareInAppMessage.fromJson(json.cast());
    });
  }

  /// Called when the presentation of an in-app message has finished.
  ///
  /// This method is invoked after the message is no longer visible to the user.
  ///
  /// It will provide the [NotificareInAppMessage] that finished presenting.
  static Stream<NotificareInAppMessage> get onMessageFinishedPresenting {
    return _getEventStream('message_finished_presenting').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareInAppMessage.fromJson(json.cast());
    });
  }

  /// Called when an in-app message failed to present.
  ///
  /// It will provide the [NotificareInAppMessage] that failed to present.
  static Stream<NotificareInAppMessage> get onMessageFailedToPresent {
    return _getEventStream('message_failed_to_present').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareInAppMessage.fromJson(json.cast());
    });
  }

  /// Called when an action is successfully executed for an in-app message.
  ///
  /// It will provide a [NotificareActionExecutedEvent] containing the
  /// [NotificareInAppMessageAction] that was executed and the
  /// [NotificareInAppMessage] for which the action was executed.
  ///
  static Stream<NotificareActionExecutedEvent> get onActionExecuted {
    return _getEventStream('action_executed').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionExecutedEvent.fromJson(json.cast());
    });
  }

  /// Called when an action execution failed for an in-app message.
  ///
  /// This method is triggered when an error occurs while attempting to execute
  /// an action.
  ///
  /// It will provide a [NotificareActionFailedToExecuteEvent] containing the
  /// [NotificareInAppMessageAction] that failed to execute and the
  /// [NotificareInAppMessage] for which the action was attempted.
  static Stream<NotificareActionFailedToExecuteEvent>
      get onActionFailedToExecute {
    return _getEventStream('action_failed_to_execute').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionFailedToExecuteEvent.fromJson(json.cast());
    });
  }
}
