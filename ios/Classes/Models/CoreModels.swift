//
//  CoreModels.swift
//  notificare
//
//  Created by Helder Pinhal on 03/12/2020.
//

import Foundation
import NotificareSDK

extension NotificareDevice {

    func toDictionary() -> FlutterDictionary {
        return [
            "id": self.id,
            "userId": self.userId,
            "userName": self.userName,
            "timeZoneOffset": self.timeZoneOffset,
            "osVersion": self.osVersion,
            "sdkVersion": self.sdkVersion,
            "appVersion": self.appVersion,
            "deviceString": self.deviceString,
            "language": self.language,
            "region": self.region,
            "transport": self.transport.rawValue,
            "dnd": self.dnd?.toDictionary(),
            "userData": self.userData,
            "lastRegistered": SwiftNotificarePlugin.dateFormatter.string(from: self.lastRegistered),
        ]
    }
}

extension NotificareDoNotDisturb {

    init(dictionary: FlutterDictionary) throws {
        self.init(
            start: try NotificareTime(string: dictionary["start"] as! String),
            end: try NotificareTime(string: dictionary["end"] as! String)
        )
    }

    func toDictionary() -> [String: Any?] {
        return [
            "start": self.start.format(),
            "end": self.end.format(),
        ]
    }
}
