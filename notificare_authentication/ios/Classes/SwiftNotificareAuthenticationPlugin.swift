import Flutter
import UIKit
import NotificareKit
import NotificareAuthenticationKit

private typealias FlutterDictionary = [String: Any?]
private let DEFAULT_ERROR_CODE = "notificare_error"

public class SwiftNotificareAuthenticationPlugin: NSObject, FlutterPlugin {
    
    private static let instance = SwiftNotificareAuthenticationPlugin()
    private let events = NotificareAuthenticationPluginEvents(packageId: "re.notifica.authentication.flutter")
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "re.notifica.authentication.flutter/notificare_authentication", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec.sharedInstance())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        instance.events.setup(registrar: registrar)
        
        // Listen to AppDelegate events.
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isLoggedIn": isLoggedIn(call, result)
        case "login": login(call, result)
        case "logout": logout(call, result)
        case "fetchUserDetails": fetchUserDetails(call, result)
        case "changePassword": changePassword(call, result)
        case "generatePushEmailAddress": generatePushEmailAddress(call, result)
        case "createAccount": createAccount(call, result)
        case "validateUser": validateUser(call, result)
        case "sendPasswordReset": sendPasswordReset(call, result)
        case "resetPassword": resetPassword(call, result)
        case "fetchUserPreferences": fetchUserPreferences(call, result)
        case "fetchUserSegments": fetchUserSegments(call, result)
        case "addUserSegment": addUserSegment(call, result)
        case "removeUserSegment": removeUserSegment(call, result)
        case "addUserSegmentToPreference": addUserSegmentToPreference(call, result)
        case "removeUserSegmentFromPreference": removeUserSegmentFromPreference(call, result)

        // Unhandled
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Methods
    
    private func isLoggedIn(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        response(Notificare.shared.authentication().isLoggedIn)
    }
    
    private func login(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let arguments = call.arguments as! FlutterDictionary
        
        let email = arguments["email"] as! String
        let password = arguments["password"] as! String
        
        Notificare.shared.authentication().login(email: email, password: password) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func logout(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.authentication().logout { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func fetchUserDetails(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.authentication().fetchUserDetails { result in
            switch result {
            case let .success(user):
                do {
                    let json = try user.toJson()
                    response(json)
                } catch {
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func changePassword(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let password = call.arguments as! String
                
        Notificare.shared.authentication().changePassword(password) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func generatePushEmailAddress(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.authentication().generatePushEmailAddress { result in
            switch result {
            case let .success(user):
                do {
                    let json = try user.toJson()
                    response(json)
                } catch {
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func createAccount(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let arguments = call.arguments as! FlutterDictionary
        
        let email = arguments["email"] as! String
        let password = arguments["password"] as! String
        let name = arguments["name"] as? String
        
        Notificare.shared.authentication().createAccount(email: email, password: password, name: name) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func validateUser(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let token = call.arguments as! String
                
        Notificare.shared.authentication().validateUser(token: token) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func sendPasswordReset(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let email = call.arguments as! String
                
        Notificare.shared.authentication().sendPasswordReset(email: email) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func resetPassword(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let arguments = call.arguments as! FlutterDictionary
        
        let password = arguments["password"] as! String
        let token = arguments["token"] as! String
                
        Notificare.shared.authentication().resetPassword(password, token: token) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func fetchUserPreferences(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.authentication().fetchUserPreferences { result in
            switch result {
            case let .success(preferences):
                do {
                    let json = try preferences.map { try $0.toJson() }
                    response(json)
                } catch {
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func fetchUserSegments(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.authentication().fetchUserSegments { result in
            switch result {
            case let .success(segments):
                do {
                    let json = try segments.map { try $0.toJson() }
                    response(json)
                } catch {
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func addUserSegment(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let segment: NotificareUserSegment
        
        do {
            let json = call.arguments as! [String: Any]
            segment = try NotificareUserSegment.fromJson(json: json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }
        
        Notificare.shared.authentication().addUserSegment(segment) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func removeUserSegment(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let segment: NotificareUserSegment
        
        do {
            let json = call.arguments as! [String: Any]
            segment = try NotificareUserSegment.fromJson(json: json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }
        
        Notificare.shared.authentication().removeUserSegment(segment) { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func addUserSegmentToPreference(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let preference: NotificareUserPreference
        let option: NotificareUserPreference.Option?
        let segment: NotificareUserSegment?
        
        do {
            let arguments = call.arguments as! FlutterDictionary
            
            preference = try NotificareUserPreference.fromJson(json: arguments["preference"] as! [String: Any])
            
            if let json = arguments["option"] as? [String: Any] {
                option = try NotificareUserPreference.Option.fromJson(json: json)
            } else {
                option = nil
            }
            
            if let json = arguments["segment"] as? [String: Any] {
                segment =  try NotificareUserSegment.fromJson(json: json)
            } else {
                segment = nil
            }
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }
        
        if (option == nil && segment == nil) || (option != nil && segment != nil) {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: "To execute this method, you must provide either a NotificareUser or a NotificarePreferenceOption.", details: nil))
            return
        }
        
        if let option = option {
            Notificare.shared.authentication().addUserSegmentToPreference(option: option, to: preference) { result in
                switch result {
                case .success:
                    response(nil)
                case let .failure(error):
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            }
        }
        
        if let segment = segment {
            Notificare.shared.authentication().addUserSegmentToPreference(segment, to: preference) { result in
                switch result {
                case .success:
                    response(nil)
                case let .failure(error):
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            }
        }
    }
    
    private func removeUserSegmentFromPreference(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let preference: NotificareUserPreference
        let option: NotificareUserPreference.Option?
        let segment: NotificareUserSegment?
        
        do {
            let arguments = call.arguments as! FlutterDictionary
            
            preference = try NotificareUserPreference.fromJson(json: arguments["preference"] as! [String: Any])
            
            if let json = arguments["option"] as? [String: Any] {
                option = try NotificareUserPreference.Option.fromJson(json: json)
            } else {
                option = nil
            }
            
            if let json = arguments["segment"] as? [String: Any] {
                segment =  try NotificareUserSegment.fromJson(json: json)
            } else {
                segment = nil
            }
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }
        
        if (option == nil && segment == nil) || (option != nil && segment != nil) {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: "To execute this method, you must provide either a NotificareUser or a NotificarePreferenceOption.", details: nil))
            return
        }
        
        if let option = option {
            Notificare.shared.authentication().removeUserSegmentFromPreference(option: option, from: preference) { result in
                switch result {
                case .success:
                    response(nil)
                case let .failure(error):
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            }
        }
        
        if let segment = segment {
            Notificare.shared.authentication().removeUserSegmentFromPreference(segment, from: preference) { result in
                switch result {
                case .success:
                    response(nil)
                case let .failure(error):
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            }
        }
    }
}

extension SwiftNotificareAuthenticationPlugin {
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let token = Notificare.shared.authentication().parsePasswordResetToken(url) {
            events.emit(NotificareAuthenticationPluginEvents.OnPasswordResetTokenReceived(token: token))
            return true
        }
        
        if let token = Notificare.shared.authentication().parseValidateUserToken(url) {
            events.emit(NotificareAuthenticationPluginEvents.OnValidateUserTokenReceived(token: token))
            return true
        }

        return false
    }
}
