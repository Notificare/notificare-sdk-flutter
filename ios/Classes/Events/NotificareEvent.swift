//
//  NotificareEvent.swift
//  notificare
//
//  Created by Helder Pinhal on 03/12/2020.
//

import Foundation
import NotificareSDK

enum NotificareEventType: String, CaseIterable {
    case ready
    case deviceRegistered = "device_registered"
}

protocol NotificareEvent {
    var type: NotificareEventType { get }
    var payload: Any? { get }
}

class NotificareEventOnReady: NotificareEvent {
    let type: NotificareEventType
    let payload: Any?

    init() {
        self.type = .ready
        self.payload = nil
    }
}

class NotificareEventOnDeviceRegistered: NotificareEvent {
    let type: NotificareEventType
    let payload: Any?

    init(device: NotificareDevice) {
        self.type = .deviceRegistered
        self.payload = device.toDictionary()
    }
}
