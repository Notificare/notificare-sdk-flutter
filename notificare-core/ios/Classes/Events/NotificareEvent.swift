//
//  NotificareEvent.swift
//  notificare
//
//  Created by Helder Pinhal on 03/12/2020.
//

import Foundation
import NotificareKit

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

    init(application: NotificareApplication) {
        self.type = .ready
        self.payload = application.toDictionary()
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
