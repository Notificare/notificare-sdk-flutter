import Flutter
import UIKit
import NotificareInboxKit

fileprivate let DEFAULT_ERROR_CODE = "notificare_error"

public class SwiftNotificareInboxPlugin: NSObject, FlutterPlugin {
    static let instance = SwiftNotificareInboxPlugin()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        instance.register(with: registrar)
    }
    
    
    private let events = NotificareInboxPluginEvents(packageId: "re.notifica.inbox.flutter")
    
    private func register(with registrar: FlutterPluginRegistrar) {
        // Delegate
        NotificareInbox.shared.delegate = self
        
        // Events
        events.setup(registrar: registrar)
        
        // Communication channel
        let channel = FlutterMethodChannel(
            name: "re.notifica.inbox.flutter/notificare_inbox",
            binaryMessenger: registrar.messenger(),
            codec: FlutterJSONMethodCodec.sharedInstance()
        )
        
        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "getItems": self.getItems(call, result)
            case "getBadge": self.getBadge(call, result)
            case "refresh": self.refresh(call, result)
            case "open": self.open(call, result)
            case "markAsRead": self.markAsRead(call, result)
            case "markAllAsRead": self.markAllAsRead(call, result)
            case "remove": self.remove(call, result)
            case "clear": self.clear(call, result)
                
            // Unhandled
            default: result(FlutterMethodNotImplemented)
            }
        }
    }

    private func getItems(_ call: FlutterMethodCall, _ response: FlutterResult) {
        do {
            let items = try NotificareInbox.shared.items.map { item in
                try item.toJson()
            }
            
            response(items)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
        }
    }
    
    private func getBadge(_ call: FlutterMethodCall, _ response: FlutterResult) {
        response(NotificareInbox.shared.badge)
    }
    
    private func refresh(_ call: FlutterMethodCall, _ response: FlutterResult) {
        NotificareInbox.shared.refresh()
        response(nil)
    }
    
    private func open(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let item: NotificareInboxItem

        do {
            let json = call.arguments as! [String: Any]
            item = try NotificareInboxItem.fromJson(json: json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }

        NotificareInbox.shared.open(item) { result in
            switch result {
            case let .success(notification):
                do {
                    let json = try notification.toJson()
                    response(json)
                } catch {
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func markAsRead(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let item: NotificareInboxItem

        do {
            let json = call.arguments as! [String: Any]
            item = try NotificareInboxItem.fromJson(json: json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }

        NotificareInbox.shared.markAsRead(item) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func markAllAsRead(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        NotificareInbox.shared.markAllAsRead { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func remove(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let item: NotificareInboxItem

        do {
            let json = call.arguments as! [String: Any]
            item = try NotificareInboxItem.fromJson(json: json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }

        NotificareInbox.shared.remove(item) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func clear(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        NotificareInbox.shared.clear { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
}

extension SwiftNotificareInboxPlugin: NotificareInboxDelegate {
    public func notificare(_ notificareInbox: NotificareInbox, didUpdateInbox items: [NotificareInboxItem]) {
        events.emit(
            NotificareInboxPluginEvents.OnInboxUpdated(items: items)
        )
    }
    
    public func notificare(_ notificareInbox: NotificareInbox, didUpdateBadge badge: Int) {
        events.emit(
            NotificareInboxPluginEvents.OnBadgeUpdated(badge: badge)
        )
    }
}
