//
//  LocalStorage.swift
//  notificare_geo
//
//  Created by Yevhenii Smirnov on 12/04/2024.
//

private let CALLBACK_DISPATCHER_KEY = "re.notifica.geo.flutter.callback_dispatcher"

import Foundation

internal class LocalStorage {
    static internal func setCallback(callbackType: NotificareGeoPluginBackgroundService.CallbackType, callbackDispatcher: Int64, callback: Int64) {
        UserDefaults.standard.setValue(callbackDispatcher, forKey: CALLBACK_DISPATCHER_KEY)
        UserDefaults.standard.setValue(callback, forKey: callbackType.rawValue)
    }
    
    static internal func getCallbackDispatcher() -> Int64? {
        if let dispatcher = UserDefaults.standard.object(forKey: CALLBACK_DISPATCHER_KEY) as? NSNumber {
            return dispatcher.int64Value
        }
        
        return nil
    }
    
    static internal func getCallback(callbackType: NotificareGeoPluginBackgroundService.CallbackType) -> Int64? {
        if let callback = UserDefaults.standard.object(forKey: callbackType.rawValue) as? NSNumber {
            return callback.int64Value
        }
        
        return nil
    }
}
