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
    case unlaunched
    case deviceRegistered = "device_registered"
    case urlOpened = "url_opened"
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
        self.payload = try! application.toJson()
    }
}

class NotificareEventOnUnlaunched: NotificareEvent {
    let type: NotificareEventType
    let payload: Any?

    init() {
        self.type = .unlaunched
        self.payload = nil
    }
}

class NotificareEventOnDeviceRegistered: NotificareEvent {
    let type: NotificareEventType
    let payload: Any?

    init(device: NotificareDevice) {
        self.type = .deviceRegistered
        self.payload = try! device.toJson()
    }
}

class NotificareEventOnUrlOpened: NotificareEvent {
    let type: NotificareEventType
    let payload: Any?

    init(url: String) {
        self.type = .urlOpened
        self.payload = url
    }
}
