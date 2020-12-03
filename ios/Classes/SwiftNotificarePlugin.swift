import Flutter
import UIKit
import NotificareSDK

typealias FlutterDictionary = [String: Any?]
let DEFAULT_ERROR_CODE = "notificare_error"

public class SwiftNotificarePlugin: NSObject, FlutterPlugin {

    static let instance = SwiftNotificarePlugin()

    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")

        return formatter
    }()

    private var channel: FlutterMethodChannel!
    private var deviceManagerChannel: FlutterMethodChannel!

    public static func register(with registrar: FlutterPluginRegistrar) {
        instance.channel = FlutterMethodChannel(name: "re.notifica.flutter/notificare", binaryMessenger: registrar.messenger())
        instance.channel.setMethodCallHandler(CoreHandler().handler)

        instance.deviceManagerChannel = FlutterMethodChannel(name: "re.notifica.flutter/notificare/device-manager", binaryMessenger: registrar.messenger())
        instance.deviceManagerChannel.setMethodCallHandler(DeviceManagerHandler().handler)

        // Events
        NotificareEventManager.shared.register(for: registrar)

        // Delegate
        Notificare.shared.delegate = instance
    }

    //    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    //
    //    }
}

extension SwiftNotificarePlugin: NotificareDelegate {

    public func notificare(_ notificare: Notificare, onReady application: NotificareApplication) {
        NotificareEventManager.shared.send(NotificareEventOnReady())
    }

    public func notificare(_ notificare: Notificare, didRegisterDevice device: NotificareDevice) {
        NotificareEventManager.shared.send(NotificareEventOnDeviceRegistered(device: device))
    }
}
