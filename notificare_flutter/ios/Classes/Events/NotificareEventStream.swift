//
//  NotificareEventStream.swift
//  notificare
//
//  Created by Helder Pinhal on 03/12/2020.
//

import Foundation

class NotificareEventStream: NSObject, FlutterStreamHandler {

    let eventType: NotificareEventType
    let name: String

    private var eventSink: FlutterEventSink?
    private var pendingEvents: [NotificareEvent] = []

    init(eventType: NotificareEventType) {
        self.eventType = eventType
        self.name = "re.notifica.flutter/events/\(eventType.rawValue)"
    }

    func send(_ event: NotificareEvent) {
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
