import Flutter
import UIKit
import NotificareKit

private typealias FlutterDictionary = [String: Any?]
private let DEFAULT_ERROR_CODE = "notificare_error"

public class SwiftNotificarePlugin: NSObject, FlutterPlugin {

    static let instance = SwiftNotificarePlugin()

    private var channel: FlutterMethodChannel!

    public static func register(with registrar: FlutterPluginRegistrar) {
        instance.register(with: registrar)
    }
    
    private func register(with registrar: FlutterPluginRegistrar) {
        registrar.addApplicationDelegate(self)
        
        // Events
        NotificareEventManager.shared.register(for: registrar)

        // Delegate
        Notificare.shared.delegate = self
        
        // Communication channel
        channel = FlutterMethodChannel(name: "re.notifica.flutter/notificare", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec.sharedInstance())
        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            
            // Notificare
            case "isConfigured": self.isConfigured(call, result)
            case "isReady": self.isReady(call, result)
            case "launch": self.launch(call, result)
            case "unlaunch": self.unlaunch(call, result)
            case "getApplication": self.getApplication(call, result)
            case "fetchApplication": self.fetchApplication(call, result)
            case "fetchNotification": self.fetchNotification(call, result)

            // Notificare Device Module
            case "getCurrentDevice": self.getCurrentDevice(call, result)
            case "register": self.register(call, result)
            case "fetchTags": self.fetchTags(call, result)
            case "addTag": self.addTag(call, result)
            case "addTags": self.addTags(call, result)
            case "removeTag": self.removeTag(call, result)
            case "removeTags": self.removeTags(call, result)
            case "clearTags": self.clearTags(call, result)
            case "getPreferredLanguage": self.getPreferredLanguage(call, result)
            case "updatePreferredLanguage": self.updatePreferredLanguage(call, result)
            case "fetchDoNotDisturb": self.fetchDoNotDisturb(call, result)
            case "updateDoNotDisturb": self.updateDoNotDisturb(call, result)
            case "clearDoNotDisturb": self.clearDoNotDisturb(call, result)
            case "fetchUserData": self.fetchUserData(call, result)
            case "updateUserData": self.updateUserData(call, result)
            
            // Notificare Events Module
            case "logCustom": self.logCustom(call, result)
            
            // Unhandled
            default: result(FlutterMethodNotImplemented)
            }
        }
    }

    //    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    //
    //    }
    
    // MARK: - Notificare
    
    private func isConfigured(_ call: FlutterMethodCall, _ result: FlutterResult) {
        result(Notificare.shared.isConfigured)
    }

    private func isReady(_ call: FlutterMethodCall, _ result: FlutterResult) {
        result(Notificare.shared.isReady)
    }

    private func launch(_ call: FlutterMethodCall, _ result: FlutterResult) {
        Notificare.shared.launch()
        result(nil)
    }

    private func unlaunch(_ call: FlutterMethodCall, _ result: FlutterResult) {
        Notificare.shared.unlaunch()
        result(nil)
    }
    
    private func getApplication(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        do {
            let json = try Notificare.shared.application?.toJson()
            response(json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
        }
    }
    
    private func fetchApplication(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.fetchApplication { result in
            switch result {
            case let .success(application):
                do {
                    let json = try application.toJson()
                    response(json)
                } catch {
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func fetchNotification(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let id = call.arguments as! String
        
        Notificare.shared.fetchNotification(id) { result in
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

    // MARK: - Notificare Device Manager

    private func getCurrentDevice(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        do {
            let json = try Notificare.shared.device().currentDevice?.toJson()
            response(json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
        }
    }

    private func register(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let arguments = call.arguments as! FlutterDictionary

        Notificare.shared.device().register(
            userId: arguments["userId"] as? String,
            userName: arguments["userName"] as? String
        ) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func fetchTags(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.device().fetchTags { result in
            switch result {
            case .success(let tags):
                response(tags)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func addTag(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let tag = call.arguments as! String

        Notificare.shared.device().addTag(tag) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func addTags(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let tags = call.arguments as! [String]

        Notificare.shared.device().addTags(tags) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func removeTag(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let tag = call.arguments as! String

        Notificare.shared.device().removeTag(tag) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func removeTags(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let tags = call.arguments as! [String]

        Notificare.shared.device().removeTags(tags) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func clearTags(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.device().clearTags { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func getPreferredLanguage(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        response(Notificare.shared.device().preferredLanguage)
    }

    private func updatePreferredLanguage(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let language = call.arguments as! String?

        Notificare.shared.device().updatePreferredLanguage(language) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func fetchDoNotDisturb(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.device().fetchDoNotDisturb { result in
            switch result {
            case .success(let dnd):
                do {
                    let json = try dnd?.toJson()
                    response(json)
                } catch {
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func updateDoNotDisturb(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let dnd: NotificareDoNotDisturb

        do {
            let json = call.arguments as! [String: Any]
            dnd = try NotificareDoNotDisturb.fromJson(json: json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }

        Notificare.shared.device().updateDoNotDisturb(dnd) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func clearDoNotDisturb(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.device().clearDoNotDisturb { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func fetchUserData(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.device().fetchUserData { result in
            switch result {
            case .success(let userData):
                response(userData)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func updateUserData(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let userData = call.arguments as! [String: String]

        Notificare.shared.device().updateUserData(userData) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    // MARK: - Notificare Events Manager
    
    private func logCustom(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let arguments = call.arguments as! [String: Any]
        
        let eventName = arguments["event"] as! String
        let eventData = arguments["data"] as? [String: Any]
        
        Notificare.shared.events().logCustom(eventName, data: eventData) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
}

extension SwiftNotificarePlugin {
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if Notificare.shared.handleTestDeviceUrl(url) {
            return true
        }
        
        if Notificare.shared.handleDynamicLinkUrl(url) {
            return true
        }
        
        NotificareEventManager.shared.send(NotificareEventOnUrlOpened(url: url.absoluteString))
        return true
    }
    
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        guard let url = userActivity.webpageURL else {
            return false
        }
        
        return Notificare.shared.handleDynamicLinkUrl(url)
    }
}

extension SwiftNotificarePlugin: NotificareDelegate {

    public func notificare(_ notificare: Notificare, onReady application: NotificareApplication) {
        NotificareEventManager.shared.send(NotificareEventOnReady(application: application))
    }

    public func notificare(_ notificare: Notificare, didRegisterDevice device: NotificareDevice) {
        NotificareEventManager.shared.send(NotificareEventOnDeviceRegistered(device: device))
    }
}
