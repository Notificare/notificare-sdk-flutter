//
//  NotificareEventManager.swift
//  notificare
//
//  Created by Helder Pinhal on 03/12/2020.
//

import Foundation

class NotificareEventManager {

    static let shared = NotificareEventManager()

    private var channels: [NotificareEventType: FlutterEventChannel] = [:]
    private var streams: [NotificareEventType: NotificareEventStream]

    private init() {
        var streams: [NotificareEventType: NotificareEventStream] = [:]

        NotificareEventType.allCases.forEach { type in
            streams[type] = NotificareEventStream(eventType: type)
        }

        self.streams = streams
    }

    func register(for registrar: FlutterPluginRegistrar) {
        streams.values.forEach { stream in
            if let channel = channels[stream.eventType] {
                channel.setStreamHandler(stream)
            } else {
                let channel = FlutterEventChannel(name: stream.name, binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec.sharedInstance())
                channel.setStreamHandler(stream)

                channels[stream.eventType] = channel
            }
        }
    }

    func unregister(for registrar: FlutterPluginRegistrar) {
        channels.values.forEach { channel in
            channel.setStreamHandler(nil)
        }
    }

    func send(_ event: NotificareEvent) {
        DispatchQueue.main.async { [weak self] in
            self?.streams[event.type]?.send(event)
        }
    }
}
