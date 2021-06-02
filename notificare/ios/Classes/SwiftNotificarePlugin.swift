import Flutter
import UIKit
import NotificareKit

typealias FlutterDictionary = [String: Any?]
let DEFAULT_ERROR_CODE = "notificare_error"

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
            case "isConfigured": self.getConfigured(call, result)
            case "isReady": self.getReady(call, result)
            case "getUseAdvancedLogging": self.getUseAdvancedLogging(call, result)
            case "setUseAdvancedLogging": self.setUseAdvancedLogging(call, result)
            case "configure": self.configure(call, result)
            case "launch": self.launch(call, result)
            case "unlaunch": self.unlaunch(call, result)
            case "getApplication": self.getApplication(call, result)
            case "fetchApplication": self.fetchApplication(call, result)
            case "fetchNotification": self.fetchNotification(call, result)

            // Notificare Device Manager
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
            
            // Unhandled
            default: result(FlutterMethodNotImplemented)
            }
        }
    }

    //    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    //
    //    }
    
    // MARK: - Notificare
    
    private func getConfigured(_ call: FlutterMethodCall, _ result: FlutterResult) {
        result(Notificare.shared.isConfigured)
    }

    private func getReady(_ call: FlutterMethodCall, _ result: FlutterResult) {
        result(Notificare.shared.isReady)
    }
    
    private func getUseAdvancedLogging(_ call: FlutterMethodCall, _ result: FlutterResult) {
        result(Notificare.shared.useAdvancedLogging)
    }
    
    private func setUseAdvancedLogging(_ call: FlutterMethodCall, _ result: FlutterResult) {
        Notificare.shared.useAdvancedLogging = call.arguments as! Bool
        result(nil)
    }

    private func configure(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! [String: Any?]

        Notificare.shared.configure(
            servicesInfo: NotificareServicesInfo(
                applicationKey: arguments["applicationKey"] as! String,
                applicationSecret: arguments["applicationKey"] as! String
            ),
            options: nil
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
            let json = try Notificare.shared.deviceManager.currentDevice?.toJson()
            response(json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
        }
    }

    private func register(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let arguments = call.arguments as! FlutterDictionary

        Notificare.shared.deviceManager.register(
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
        Notificare.shared.deviceManager.fetchTags { result in
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

        Notificare.shared.deviceManager.addTag(tag) { result in
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

        Notificare.shared.deviceManager.addTags(tags) { result in
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

        Notificare.shared.deviceManager.removeTag(tag) { result in
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

        Notificare.shared.deviceManager.removeTags(tags) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func clearTags(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.deviceManager.clearTags { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func getPreferredLanguage(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        response(Notificare.shared.deviceManager.preferredLanguage)
    }

    private func updatePreferredLanguage(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        let language = call.arguments as! String?

        Notificare.shared.deviceManager.updatePreferredLanguage(language) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func fetchDoNotDisturb(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.deviceManager.fetchDoNotDisturb { result in
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

        Notificare.shared.deviceManager.updateDoNotDisturb(dnd) { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func clearDoNotDisturb(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.deviceManager.clearDoNotDisturb { result in
            switch result {
            case .success:
                response(nil)
            case .failure(let error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }

    private func fetchUserData(_ call: FlutterMethodCall, _ response: @escaping  FlutterResult) {
        Notificare.shared.deviceManager.fetchUserData { result in
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

        Notificare.shared.deviceManager.updateUserData(userData) { result in
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
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        // Ensure Notificare is configured when the application is launched.
        Notificare.shared.configure()
        
        return true
    }
    
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
