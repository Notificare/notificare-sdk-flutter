import Flutter
import UIKit
import NotificareKit
import NotificareInAppMessagingKit

private typealias FlutterDictionary = [String: Any?]
private let DEFAULT_ERROR_CODE = "notificare_error"

public class SwiftNotificareInAppMessagingPlugin: NSObject, FlutterPlugin {
    private static let instance = SwiftNotificareInAppMessagingPlugin()
    private let events = NotificareInAppMessagingPluginEvents(packageId: "re.notifica.iam.flutter")

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "re.notifica.iam.flutter/notificare_in_app_messaging", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec.sharedInstance())
        registrar.addMethodCallDelegate(instance, channel: channel)

        instance.events.setup(registrar: registrar)
        Notificare.shared.inAppMessaging().delegate = instance
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "hasMessagesSuppressed": hasMessagesSuppressed(call, result)
        case "setMessagesSuppressed": setMessagesSuppressed(call, result)

        // Unhandled
        default: result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Methods

    private func hasMessagesSuppressed(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        response(Notificare.shared.inAppMessaging().hasMessagesSuppressed)
    }

    private func setMessagesSuppressed(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        guard let suppressed = call.arguments as? Bool else {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: "Invalid request parameters.", details: nil))
            return
        }

        Notificare.shared.inAppMessaging().hasMessagesSuppressed = suppressed
        response(nil)
    }
}

extension SwiftNotificareInAppMessagingPlugin: NotificareInAppMessagingDelegate {
    public func notificare(_ notificare: NotificareInAppMessaging, didPresentMessage message: NotificareInAppMessage) {
        events.emit(NotificareInAppMessagingPluginEvents.OnMessagePresented(message: message))
    }

    public func notificare(_ notificare: NotificareInAppMessaging, didFinishPresentingMessage message: NotificareInAppMessage) {
        events.emit(NotificareInAppMessagingPluginEvents.OnMessageFinishedPresenting(message: message))
    }

    public func notificare(_ notificare: NotificareInAppMessaging, didFailToPresentMessage message: NotificareInAppMessage) {
        events.emit(NotificareInAppMessagingPluginEvents.OnMessageFailedToPresent(message: message))
    }

    public func notificare(_ notificare: NotificareInAppMessaging, didExecuteAction action: NotificareInAppMessage.Action, for message: NotificareInAppMessage) {
        events.emit(NotificareInAppMessagingPluginEvents.OnActionExecuted(message: message, action: action))
    }

    public func notificare(_ notificare: NotificareInAppMessaging, didFailToExecuteAction action: NotificareInAppMessage.Action, for message: NotificareInAppMessage, error: Error?) {
        events.emit(NotificareInAppMessagingPluginEvents.OnActionFailedToExecute(message: message, action: action, error: error))
    }
}
