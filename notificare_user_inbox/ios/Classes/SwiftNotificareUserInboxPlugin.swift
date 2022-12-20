import Flutter
import UIKit
import NotificareKit
import NotificareUserInboxKit

private typealias FlutterDictionary = [String: Any?]
private let DEFAULT_ERROR_CODE = "notificare_error"

public class SwiftNotificareUserInboxPlugin: NSObject, FlutterPlugin {
    
    static let instance = SwiftNotificareUserInboxPlugin()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "re.notifica.inbox.user.flutter/notificare_user_inbox", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec.sharedInstance())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "parseResponseFromJSON": parseResponseFromJSON(call, result)
        case "parseResponseFromString": parseResponseFromString(call, result)
        case "open": open(call, result)
        case "markAsRead": markAsRead(call, result)
        case "remove": remove(call, result)
            
            // Unhandled
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Methods
    
    private func parseResponseFromJSON(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let result: NotificareUserInboxResponse
        
        do {
            let json = call.arguments as! [String: Any]
            
            result = try Notificare.shared.userInbox().parseResponse(json: json)
            
            response(try result.toJson())
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
        }
    }
    
    private func parseResponseFromString(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let result: NotificareUserInboxResponse
        
        do {
            let json = call.arguments as! String
            
            result = try Notificare.shared.userInbox().parseResponse(string: json)
            
            response(try result.toJson())
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
        }
    }
    
    private func open(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let item: NotificareUserInboxItem
        
        do {
            let json = call.arguments as! [String: Any]
            item = try NotificareUserInboxItem.fromJson(json: json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }
        
        Notificare.shared.userInbox().open(item) { result in
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
        let item: NotificareUserInboxItem
        
        do {
            let json = call.arguments as! [String: Any]
            item = try NotificareUserInboxItem.fromJson(json: json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }
        
        Notificare.shared.userInbox().markAsRead(item) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func remove(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let item: NotificareUserInboxItem
        
        do {
            let json = call.arguments as! [String: Any]
            item = try NotificareUserInboxItem.fromJson(json: json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }
        
        Notificare.shared.userInbox().remove(item) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
}
