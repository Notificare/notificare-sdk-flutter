import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare/notificare.dart';
import 'package:notificare_push_ui/src/events/notificare_action_executed_event.dart';
import 'package:notificare_push_ui/src/events/notificare_action_failed_to_execute_event.dart';
import 'package:notificare_push_ui/src/events/notificare_action_not_executed_event.dart';
import 'package:notificare_push_ui/src/events/notificare_action_will_execute_event.dart';
import 'package:notificare_push_ui/src/events/notificare_custom_action_received_event.dart';
import 'package:notificare_push_ui/src/events/notificare_notification_url_clicked_event.dart';

class NotificarePushUI {
  NotificarePushUI._();

  static const MethodChannel _channel = MethodChannel(
    're.notifica.push.ui.flutter/notificare_push_ui',
    JSONMethodCodec(),
  );

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  /// Presents a notification to the user.
  ///
  /// This method launches the UI for displaying the provided
  /// [NotificareNotification].
  ///
  /// - notification` The [NotificareNotification] to present.
  static Future<void> presentNotification(
    NotificareNotification notification,
  ) async {
    await _channel.invokeMethod('presentNotification', notification.toJson());
  }

  /// Presents an action associated with a notification.
  ///
  /// This method presents the UI for executing a specific
  /// [NotificareNotificationAction] associated with the provided
  /// [NotificareNotification].
  ///
  /// - `notification`: The [NotificareNotification] to present.
  /// - `action`: The [NotificareNotificationAction] to execute.
  static Future<void> presentAction(
    NotificareNotification notification,
    NotificareNotificationAction action,
  ) async {
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
      _eventStreams[eventType] =
          _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  /// Called when a notification is about to be presented.
  ///
  /// This method is invoked before the notification is shown to the user.
  ///
  /// It will provide the [NotificareNotification] that will be presented.
  static Stream<NotificareNotification> get onNotificationWillPresent {
    return _getEventStream('notification_will_present').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  /// Called when a notification has been presented.
  ///
  /// This method is triggered when the notification has been shown to the user.
  ///
  /// It will provide the [NotificareNotification] that was presented.
  static Stream<NotificareNotification> get onNotificationPresented {
    return _getEventStream('notification_presented').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  /// Called when the presentation of a notification has finished.
  ///
  /// This method is invoked after the notification UI has been dismissed or the
  /// notification interaction has completed.
  ///
  /// It will provide the [NotificareNotification] that finished presenting.
  static Stream<NotificareNotification> get onNotificationFinishedPresenting {
    return _getEventStream('notification_finished_presenting').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  /// Called when a notification fails to present.
  ///
  /// This method is invoked if there is an error preventing the notification from
  /// being presented.
  ///
  /// It will provide the [NotificareNotification] that failed to present.
  static Stream<NotificareNotification> get onNotificationFailedToPresent {
    return _getEventStream('notification_failed_to_present').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotification.fromJson(json.cast());
    });
  }

  /// Called when a URL within a notification is clicked.
  ///
  /// This method is triggered when the user clicks a URL in the notification.
  ///
  /// It will provide a [NotificareNotificationUrlClickedEvent] containing the
  /// string URL and the [NotificareNotification] containing it.
  static Stream<NotificareNotificationUrlClickedEvent>
      get onNotificationUrlClicked {
    return _getEventStream('notification_url_clicked').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareNotificationUrlClickedEvent.fromJson(json.cast());
    });
  }

  /// Called when an action associated with a notification is about to execute.
  ///
  /// This method is invoked right before the action associated with a notification
  /// is executed.
  ///
  /// It will provide a [NotificareActionWillExecuteEvent] containing the
  /// [NotificareNotificationAction] that will be executed and the
  /// [NotificareNotification] containing it.
  static Stream<NotificareActionWillExecuteEvent> get onActionWillExecute {
    return _getEventStream('action_will_execute').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionWillExecuteEvent.fromJson(json.cast());
    });
  }

  /// Called when an action associated with a notification has been executed.
  ///
  /// This method is triggered after the action associated with the notification
  /// has been successfully executed.
  ///
  /// It will provide a [NotificareActionExecutedEvent] containing the
  /// [NotificareNotificationAction] that was executed and the
  /// [NotificareNotification] containing it.
  static Stream<NotificareActionExecutedEvent> get onActionExecuted {
    return _getEventStream('action_executed').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionExecutedEvent.fromJson(json.cast());
    });
  }

  /// Called when an action associated with a notification is available but has
  /// not been executed by the user.
  ///
  /// This method is triggered after the action associated with the notification
  /// has not been executed, caused by user interaction.
  ///
  /// It will provide a [NotificareActionNotExecutedEvent] containing the
  /// [NotificareNotificationAction] that was not executed and the
  /// [NotificareNotification] containing it.
  static Stream<NotificareActionNotExecutedEvent> get onActionNotExecuted {
    return _getEventStream('action_not_executed').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionNotExecutedEvent.fromJson(json.cast());
    });
  }

  /// Called when an action associated with a notification fails to execute.
  ///
  /// This method is triggered if an error occurs while trying to execute an
  /// action associated with the notification.
  ///
  /// It will provide a [NotificareActionFailedToExecuteEvent] containing the 
  /// [NotificareNotificationAction] that was failed to execute and the 
  /// [NotificareNotification] containing it. It may also contain the error that
  /// caused the failure.
  static Stream<NotificareActionFailedToExecuteEvent>
      get onActionFailedToExecute {
    return _getEventStream('action_failed_to_execute').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareActionFailedToExecuteEvent.fromJson(json.cast());
    });
  }

  /// Called when a custom action associated with a notification is received.
  ///
  /// This method is triggered when a custom action associated with the
  /// notification is received, such as a deep link or custom URL scheme.
  ///
  /// It will provide a [NotificareCustomActionReceivedEvent] containing the
  /// [NotificareNotificationAction] that triggered the custom action and the 
  /// [NotificareNotification] containing it. It also provides the URL
  /// representing the custom action.
  static Stream<NotificareCustomActionReceivedEvent>
      get onCustomActionReceived {
    return _getEventStream('custom_action_received').map((result) {
      final Map<dynamic, dynamic> json = result;
      return NotificareCustomActionReceivedEvent.fromJson(json.cast());
    });
  }
}
