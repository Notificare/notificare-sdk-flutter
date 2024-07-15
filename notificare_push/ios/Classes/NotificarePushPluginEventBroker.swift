//
//  NotificarePushPluginEventBroker.swift
//  notificare_push
//
//  Created by Helder Pinhal on 23/04/2021.
//

import NotificareKit
import NotificarePushKit

class NotificarePushPluginEventBroker {
    private let namespace: String
    
    private var channels: [EventType: FlutterEventChannel] = [:]
    private var streams: [EventType: Stream]
    
    init(namespace: String) {
        var streams: [EventType: Stream] = [:]
        EventType.allCases.forEach { type in
            streams[type] = Stream(namespace: namespace, type: type)
        }
        
        self.namespace = namespace
        self.streams = streams
    }
    
    func setup(registrar: FlutterPluginRegistrar) {
        streams.values.forEach { stream in
            if let channel = channels[stream.type] {
                channel.setStreamHandler(stream)
            } else {
                let channel = FlutterEventChannel(
                    name: stream.name,
                    binaryMessenger: registrar.messenger(),
                    codec: FlutterJSONMethodCodec.sharedInstance()
                )
                
                channel.setStreamHandler(stream)

                channels[stream.type] = channel
            }
        }
    }
    
    func cleanup() {
        channels.values.forEach { channel in
            channel.setStreamHandler(nil)
        }
    }
    
    func emit(_ event: Event) {
        DispatchQueue.main.async { [weak self] in
            self?.streams[event.type]?.send(event)
        }
    }
}

// NotificarePushPluginEventBroker.Stream
extension NotificarePushPluginEventBroker {
    class Stream: NSObject, FlutterStreamHandler {
        let type: EventType
        let name: String

        private var eventSink: FlutterEventSink?
        private var pendingEvents: [Event] = []

        init(namespace: String, type: EventType) {
            self.type = type
            self.name = "\(namespace)/events/\(type.rawValue)"
        }

        func send(_ event: Event) {
            if let sink = self.eventSink {
                sink(event.payload)
            } else {
                pendingEvents.append(event)
            }
        }

        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            self.eventSink = events

            if (self.eventSink != nil) {
                self.pendingEvents.forEach { send($0) }
                self.pendingEvents.removeAll()
            }

            return nil
        }

        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            self.eventSink = nil
            return nil
        }
    }
}

// NotificarePushPluginEventBroker.Event
extension NotificarePushPluginEventBroker {
    enum EventType: String, CaseIterable {
        case notificationInfoReceived = "notification_info_received"
        case systemNotificationReceived = "system_notification_received"
        case unknownNotificationReceived = "unknown_notification_received"
        case notificationOpened = "notification_opened"
        case unknownNotificationOpened = "unknown_notification_opened"
        case notificationActionOpened = "notification_action_opened"
        case unknownNotificationActionOpened = "unknown_notification_action_opened"
        case shouldOpenNotificationSettings = "should_open_notification_settings"
        case notificationSettingsChanged = "notification_settings_changed"
        case failedToRegisterForRemoteNotifications = "failed_to_register_for_remote_notifications"
    }
    
    struct Event {
        let type: EventType
        let payload: Any?
    }
}

extension NotificarePushPluginEventBroker {
    static func OnNotificationReceived(notification: NotificareNotification, deliveryMechanism: NotificareNotificationDeliveryMechanism) -> Event {
        return Event(
            type: .notificationInfoReceived,
            payload: [
                "notification": try! notification.toJson(),
                "deliveryMechanism": deliveryMechanism.rawValue
            ]
        )
    }
    
    static func OnSystemNotificationReceived(notification: NotificareSystemNotification) -> Event {
        return Event(
            type: .systemNotificationReceived,
            payload: try! notification.toJson()
        )
    }
    
    static func OnUnknownNotificationReceived(userInfo: [AnyHashable: Any]) -> Event {
        return Event(
            type: .unknownNotificationReceived,
            payload: userInfo.filter { $0.key is String } as! [String: Any]
        )
    }
    
    static func OnNotificationOpened(notification: NotificareNotification) -> Event {
        return Event(
            type: .notificationOpened,
            payload: try! notification.toJson()
        )
    }
    
    static func OnUnknownNotificationOpened(notification: [AnyHashable: Any]) -> Event {
        return Event(
            type: .unknownNotificationOpened,
            payload: notification.filter { $0.key is String } as! [String: Any]
        )
    }
    
    static func OnNotificationActionOpened(notification: NotificareNotification, action: NotificareNotification.Action) -> Event {
        return Event(
            type: .notificationActionOpened,
            payload: [
                "notification": try! notification.toJson(),
                "action": try! action.toJson()
            ]
        )
    }
    
    static func OnUnknownNotificationActionOpened(notification: [AnyHashable: Any], action: String, responseText: String?) -> Event {
        var payload: [String: Any] = [
            "notification": notification.filter { $0.key is String } as! [String: Any],
            "action": action,
        ]
        
        if let responseText = responseText {
            payload["responseText"] = responseText
        }
        
        return Event(
            type: .unknownNotificationActionOpened,
            payload: payload
        )
    }
    
    static func OnShouldOpenNotificationSettings(notification: NotificareNotification?) -> Event {
        return Event(
            type: .shouldOpenNotificationSettings,
            payload: try! notification?.toJson()
        )
    }
    
    static func OnNotificationSettingsChanged(granted: Bool) -> Event {
        return Event(
            type: .notificationSettingsChanged,
            payload: granted
        )
    }
    
    static func OnFailedToRegisterForRemoteNotifications(error: Error) -> Event {
        return Event(
            type: .failedToRegisterForRemoteNotifications,
            payload: error.localizedDescription
        )
    }
}
