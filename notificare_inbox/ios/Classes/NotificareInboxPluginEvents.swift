//
//  NotificareInboxPluginEvents.swift
//  notificare
//
//  Created by Helder Pinhal on 21/04/2021.
//

import NotificareInboxKit

class NotificareInboxPluginEvents {
    private let packageId: String
    
    private var channels: [EventType: FlutterEventChannel] = [:]
    private var streams: [EventType: Stream]
    
    init(packageId: String) {
        var streams: [EventType: Stream] = [:]
        EventType.allCases.forEach { type in
            streams[type] = Stream(packageId: packageId, type: type)
        }
        
        self.packageId = packageId
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

// NotificareInboxPluginEventsManager.Stream
extension NotificareInboxPluginEvents {
    class Stream: NSObject, FlutterStreamHandler {
        let type: EventType
        let name: String

        private var eventSink: FlutterEventSink?
        private var pendingEvents: [Event] = []

        init(packageId: String, type: EventType) {
            self.type = type
            self.name = "\(packageId)/events/\(type.rawValue)"
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

// NotificareInboxPluginEventsManager.Event
extension NotificareInboxPluginEvents {
    enum EventType: String, CaseIterable {
        case inboxUpdated = "inbox_updated"
        case badgeUpdated = "badge_updated"
    }
    
    struct Event {
        let type: EventType
        let payload: Any?
    }
}

extension NotificareInboxPluginEvents {
    static func OnInboxUpdated(items: [NotificareInboxItem]) -> Event {
        let asd = items.map({ try! $0.toJson() })
        
        return Event(
            type: .inboxUpdated,
            payload: asd
        )
    }
    
    static func OnBadgeUpdated(badge: Int) -> Event {
        Event(
            type: .badgeUpdated,
            payload: badge
        )
    }
}
