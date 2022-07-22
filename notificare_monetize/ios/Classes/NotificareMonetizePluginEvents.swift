//
//  NotificareMonetizePluginEvents.swift
//  notificare_monetize
//
//  Created by Helder Pinhal on 22/07/2022.
//

import Foundation
import NotificareMonetizeKit

class NotificareMonetizePluginEvents {
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

// NotificareMonetizePluginEvents.Stream
extension NotificareMonetizePluginEvents {
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

// NotificareMonetizePluginEvents.Event
extension NotificareMonetizePluginEvents {
    enum EventType: String, CaseIterable {
        case productsUpdated = "products_updated"
        case purchasesUpdated = "purchases_updated"
        case billingSetupFinished = "billing_setup_finished"
        case billingSetupFailed = "billing_setup_failed"
        case purchaseFinished = "purchase_finished"
        case purchaseRestored = "purchase_restored"
        case purchaseCanceled = "purchase_canceled"
        case purchaseFailed = "purchase_failed"
    }
    
    struct Event {
        let type: EventType
        let payload: Any?
    }
}

extension NotificareMonetizePluginEvents {
    static func OnProductsUpdated(products: [NotificareProduct]) -> Event {
        return Event(
            type: .productsUpdated,
            payload: try! products.map { try $0.toJson() }
        )
    }
    
    static func OnPurchasesUpdated(purchases: [NotificarePurchase]) -> Event {
        return Event(
            type: .purchasesUpdated,
            payload: try! purchases.map { try $0.toJson() }
        )
    }
    
    static func OnPurchaseFinished(purchase: NotificarePurchase) -> Event {
        return Event(
            type: .purchaseFinished,
            payload: try! purchase.toJson()
        )
    }
    
    static func OnPurchaseRestored(purchase: NotificarePurchase) -> Event {
        return Event(
            type: .purchaseRestored,
            payload: try! purchase.toJson()
        )
    }
    
    static func OnPurchaseCanceled() -> Event {
        return Event(
            type: .purchaseCanceled,
            payload: nil
        )
    }
    
    static func OnPurchaseFailed(error: Error) -> Event {
        return Event(
            type: .purchaseFailed,
            payload: error.localizedDescription
        )
    }
}
