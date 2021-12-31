//
//  NotificareScannablesPluginEventBroker.swift
//  notificare_scannables
//
//  Created by Helder Pinhal on 25/11/2021.
//

import Foundation
import NotificareScannablesKit

class NotificareScannablesPluginEvents {
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

// NotificareScannablesPluginEvents.Stream
extension NotificareScannablesPluginEvents {
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

// NotificareScannablesPluginEvents.Event
extension NotificareScannablesPluginEvents {
    enum EventType: String, CaseIterable {
        case scannableDetected = "scannable_detected"
        case scannableSessionFailed = "scannable_session_failed"
    }
    
    struct Event {
        let type: EventType
        let payload: Any?
    }
}

extension NotificareScannablesPluginEvents {
    static func OnScannableDetected(scannable: NotificareScannable) -> Event {
        return Event(
            type: .scannableDetected,
            payload: try! scannable.toJson()
        )
    }
    
    static func OnScannableSessionFailed(error: Error) -> Event {
        Event(
            type: .scannableSessionFailed,
            payload: error.localizedDescription
        )
    }
}
