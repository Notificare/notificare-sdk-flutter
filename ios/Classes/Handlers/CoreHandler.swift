//
//  CoreHandler.swift
//  notificare
//
//  Created by Helder Pinhal on 01/12/2020.
//

import Foundation
import NotificareSDK

class CoreHandler {

    func handler(call: FlutterMethodCall, result: FlutterResult) {
        switch call.method {
        case "isConfigured": getConfigured(call, result)
        case "isReady": getReady(call, result)
        case "configure": configure(call, result)
        case "launch": launch(call, result)
        case "unlaunch": unlaunch(call, result)
        default: result(FlutterMethodNotImplemented)
        }
    }

    private func getConfigured(_ call: FlutterMethodCall, _ result: FlutterResult) {
        result(Notificare.shared.isConfigured)
    }

    private func getReady(_ call: FlutterMethodCall, _ result: FlutterResult) {
        result(Notificare.shared.isReady)
    }

    private func configure(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! FlutterDictionary

        Notificare.shared.configure(
            applicationKey: arguments["applicationKey"] as! String,
            applicationSecret: arguments["applicationKey"] as! String
        )

        result(nil)
    }

    private func launch(_ call: FlutterMethodCall, _ result: FlutterResult) {
        Notificare.shared.launch()
        result(nil)
    }

    private func unlaunch(_ call: FlutterMethodCall, _ result: FlutterResult) {
        Notificare.shared.unlaunch()
        result(nil)
    }
}
