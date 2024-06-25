import Flutter
import UIKit
import NotificareKit
import NotificarePushKit

fileprivate let DEFAULT_ERROR_CODE = "notificare_error"
fileprivate let NAMESPACE = "re.notifica.push.flutter"

public class SwiftNotificarePushPlugin: NSObject, FlutterPlugin {
    static let instance = SwiftNotificarePushPlugin()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        instance.register(with: registrar)
    }
    
    private let eventBroker = NotificarePushPluginEventBroker(namespace: NAMESPACE)
    
    private func register(with registrar: FlutterPluginRegistrar) {
        // Events
        eventBroker.setup(registrar: registrar)
        
        // Delegate
        Notificare.shared.push().delegate = self
        
        // NOTE: We need to have a blank implementation of the didReceiveRemoteNotification to allow the native
        // side to swizzle the method.
        registrar.addApplicationDelegate(self)
        
        // Communication channel
        let channel = FlutterMethodChannel(
            name: "\(NAMESPACE)/notificare_push",
            binaryMessenger: registrar.messenger(),
            codec: FlutterJSONMethodCodec.sharedInstance()
        )
        
        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "setAuthorizationOptions": self.setAuthorizationOptions(call, result)
            case "setCategoryOptions": self.setCategoryOptions(call, result)
            case "setPresentationOptions": self.setPresentationOptions(call, result)
            case "hasRemoteNotificationsEnabled": self.hasRemoteNotificationsEnabled(call, result)
            case "getTransport": self.getTransport(call, result)
            case "getSubscriptionId": self.getSubscriptionId(call, result)
            case "allowedUI": self.allowedUI(call, result)
            case "enableRemoteNotifications": self.enableRemoteNotifications(call, result)
            case "disableRemoteNotifications": self.disableRemoteNotifications(call, result)
                
            // Unhandled
            default: result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func setAuthorizationOptions(_ call: FlutterMethodCall, _ response: FlutterResult) {
        var authorizationOptions: UNAuthorizationOptions = []
        
        let options = call.arguments as! [String]
        options.forEach { option in
            if option == "alert" {
                authorizationOptions = [authorizationOptions, .alert]
            }
            
            if option == "badge" {
                authorizationOptions = [authorizationOptions, .badge]
            }
            
            if option == "sound" {
                authorizationOptions = [authorizationOptions, .sound]
            }
            
            if option == "carPlay" {
                authorizationOptions = [authorizationOptions, .carPlay]
            }
            
            if #available(iOS 12.0, *) {
                if option == "providesAppNotificationSettings" {
                    authorizationOptions = [authorizationOptions, .providesAppNotificationSettings]
                }
                
                if option == "provisional" {
                    authorizationOptions = [authorizationOptions, .provisional]
                }
                
                if option == "criticalAlert" {
                    authorizationOptions = [authorizationOptions, .criticalAlert]
                }
            }
            
            if #available(iOS 13.0, *) {
                if option == "announcement" {
                    authorizationOptions = [authorizationOptions, .announcement]
                }
            }
        }
        
        Notificare.shared.push().authorizationOptions = authorizationOptions
        response(nil)
    }
    
    private func setCategoryOptions(_ call: FlutterMethodCall, _ response: FlutterResult) {
        var categoryOptions: UNNotificationCategoryOptions = []
        
        let options = call.arguments as! [String]
        options.forEach { option in
            if option == "customDismissAction" {
                categoryOptions = [categoryOptions, .customDismissAction]
            }
            
            if option == "allowInCarPlay" {
                categoryOptions = [categoryOptions, .allowInCarPlay]
            }
            
            if #available(iOS 11.0, *) {
                if option == "hiddenPreviewsShowTitle" {
                    categoryOptions = [categoryOptions, .hiddenPreviewsShowTitle]
                }
                
                if option == "hiddenPreviewsShowSubtitle" {
                    categoryOptions = [categoryOptions, .hiddenPreviewsShowSubtitle]
                }
            }
            
            if #available(iOS 13.0, *) {
                if option == "allowAnnouncement" {
                    categoryOptions = [categoryOptions, .allowAnnouncement]
                }
            }
        }
        
        Notificare.shared.push().categoryOptions = categoryOptions
        response(nil)
    }
    
    private func setPresentationOptions(_ call: FlutterMethodCall, _ response: FlutterResult) {
        var presentationOptions: UNNotificationPresentationOptions = []
        
        let options = call.arguments as! [String]
        options.forEach { option in
            if #available(iOS 14.0, *) {
                if option == "banner" || option == "alert" {
                    presentationOptions = [presentationOptions, .banner]
                }
                
                if option == "list" {
                    presentationOptions = [presentationOptions, .list]
                }
            } else {
                if option == "alert" {
                    presentationOptions = [presentationOptions, .alert]
                }
            }
            
            if option == "badge" {
                presentationOptions = [presentationOptions, .badge]
            }
            
            if option == "sound" {
                presentationOptions = [presentationOptions, .sound]
            }
        }
        
        Notificare.shared.push().presentationOptions = presentationOptions
        response(nil)
    }
    
    private func hasRemoteNotificationsEnabled(_ call: FlutterMethodCall, _ response: FlutterResult) {
        response(Notificare.shared.push().hasRemoteNotificationsEnabled)
    }

    private func getTransport(_ call: FlutterMethodCall, _ response: FlutterResult) {
        response(Notificare.shared.push().transport?.rawValue)
    }

    private func getSubscriptionId(_ call: FlutterMethodCall, _ response: FlutterResult) {
        response(Notificare.shared.push().subscriptionId)
    }

    private func allowedUI(_ call: FlutterMethodCall, _ response: FlutterResult) {
        response(Notificare.shared.push().allowedUI)
    }
    
    private func enableRemoteNotifications(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.push().enableRemoteNotifications { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func disableRemoteNotifications(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.push().disableRemoteNotifications { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
}

extension SwiftNotificarePushPlugin: NotificarePushDelegate {
    public func notificare(_ notificarePush: NotificarePush, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        eventBroker.emit(
            NotificarePushPluginEventBroker.OnFailedToRegisterForRemoteNotifications(
                error: error
            )
        )
    }
    
    public func notificare(_ notificarePush: NotificarePush, didChangeNotificationSettings granted: Bool) {
        eventBroker.emit(
            NotificarePushPluginEventBroker.OnNotificationSettingsChanged(
                granted: granted
            )
        )
    }
    
    public func notificare(_ notificarePush: NotificarePush, didReceiveNotification notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushPluginEventBroker.OnNotificationReceived(
                notification: notification
            )
        )
    }
    
    public func notificare(_ notificarePush: NotificarePush, didReceiveNotification notification: NotificareNotification, deliveryMechanism: NotificareNotificationDeliveryMechanism) {
        eventBroker.emit(
            NotificarePushPluginEventBroker.OnNotificationReceived(
                notification: notification,
                deliveryMechanism: deliveryMechanism
            )
        )
    }
    
    public func notificare(_ notificarePush: NotificarePush, didReceiveSystemNotification notification: NotificareSystemNotification) {
        eventBroker.emit(
            NotificarePushPluginEventBroker.OnSystemNotificationReceived(
                notification: notification
            )
        )
    }
    
    public func notificare(_ notificarePush: NotificarePush, didReceiveUnknownNotification userInfo: [AnyHashable : Any]) {
        eventBroker.emit(
            NotificarePushPluginEventBroker.OnUnknownNotificationReceived(
                userInfo: userInfo
            )
        )
    }
    
    public func notificare(_ notificarePush: NotificarePush, shouldOpenSettings notification: NotificareNotification?) {
        eventBroker.emit(
            NotificarePushPluginEventBroker.OnShouldOpenNotificationSettings(
                notification: notification
            )
        )
    }
    
    public func notificare(_ notificarePush: NotificarePush, didOpenNotification notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushPluginEventBroker.OnNotificationOpened(
                notification: notification
            )
        )
    }

    public func notificare(_ notificarePush: NotificarePush, didOpenUnknownNotification userInfo: [AnyHashable : Any]) {
        eventBroker.emit(
            NotificarePushPluginEventBroker.OnUnknownNotificationOpened(
                notification: userInfo
            )
        )
    }
    
    public func notificare(_ notificarePush: NotificarePush, didOpenAction action: NotificareNotification.Action, for notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushPluginEventBroker.OnNotificationActionOpened(
                notification: notification,
                action: action
            )
        )
    }
    
    public func notificare(_ notificarePush: NotificarePush, didOpenUnknownAction action: String, for notification: [AnyHashable : Any], responseText: String?) {
        eventBroker.emit(
            NotificarePushPluginEventBroker.OnUnknownNotificationActionOpened(
                notification: notification,
                action: action,
                responseText: responseText
            )
        )
    }
}

extension SwiftNotificarePushPlugin: FlutterApplicationLifeCycleDelegate {
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        // This method is never called. The swizzling performed on the native side takes care of it.
        return true
    }
}
