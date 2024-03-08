import Flutter
import UIKit
import NotificareKit
import NotificarePushUIKit

fileprivate let DEFAULT_ERROR_CODE = "notificare_error"
fileprivate let NAMESPACE = "re.notifica.push.ui.flutter"

public class SwiftNotificarePushUIPlugin: NSObject, FlutterPlugin {
    static let instance = SwiftNotificarePushUIPlugin()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        instance.register(with: registrar)
    }
    
    private let eventBroker = NotificarePushUIPluginEventBroker(namespace: NAMESPACE)

    private var rootViewController: UIViewController? {
        get {
            UIApplication.shared.delegate?.window??.rootViewController
        }
    }
    
    private func register(with registrar: FlutterPluginRegistrar) {
        // Events
        eventBroker.setup(registrar: registrar)
        
        // Delegate
        Notificare.shared.pushUI().delegate = self
        
        let channel = FlutterMethodChannel(name: "\(NAMESPACE)/notificare_push_ui", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec.sharedInstance())
        registrar.addMethodCallDelegate(self, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "presentNotification": presentNotification(call, result)
        case "presentAction": presentAction(call, result)
            
        // Unhandled
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    private func presentNotification(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let notification: NotificareNotification
        
        do {
            let json = call.arguments as! [String: Any]
            notification = try NotificareNotification.fromJson(json: json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }
        
        guard let rootViewController = rootViewController else {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: "Cannot present a notification with a nil root view controller.", details: nil))
            return
        }
        
        if notification.requiresViewController {
            let navigationController = createNavigationController()
            rootViewController.present(navigationController, animated: true) {
                Notificare.shared.pushUI().presentNotification(notification, in: navigationController)
                response(nil)
            }
        } else {
            Notificare.shared.pushUI().presentNotification(notification, in: rootViewController)
            response(nil)
        }
    }
    
    private func presentAction(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let notification: NotificareNotification
        let action: NotificareNotification.Action
        
        do {
            let json = call.arguments as! [String: Any]
            notification = try NotificareNotification.fromJson(json: json["notification"] as! [String: Any])
            action = try NotificareNotification.Action.fromJson(json: json["action"] as! [String: Any])
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }
        
        guard let rootViewController = rootViewController else {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: "Cannot present a notification with a nil root view controller.", details: nil))
            return
        }
        
        Notificare.shared.pushUI().presentAction(action, for: notification, in: rootViewController)
        response(nil)
    }
    
    private func createNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        let theme = Notificare.shared.options?.theme(for: navigationController)
        
        if let colorStr = theme?.backgroundColor {
            navigationController.view.backgroundColor = UIColor(hexString: colorStr)
        } else {
            if #available(iOS 13.0, *) {
                navigationController.view.backgroundColor = .systemBackground
            } else {
                navigationController.view.backgroundColor = .white
            }
        }

        return navigationController
    }
    
    @objc private func onCloseClicked() {
        guard let rootViewController = rootViewController else {
            return
        }
        
        rootViewController.dismiss(animated: true, completion: nil)
    }
}

extension NotificareNotification {
    var requiresViewController: Bool {
        get {
            if let type = NotificareNotification.NotificationType.init(rawValue: type) {
                switch type {
                case .alert, .none, .passbook, .rate, .urlScheme:
                    return false
                default:
                    break
                }
            }

            return true
        }
    }
}

extension SwiftNotificarePushUIPlugin: NotificarePushUIDelegate {
    public func notificare(_ notificarePushUI: NotificarePushUI, willPresentNotification notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushUIPluginEventBroker.OnNotificationWillPresent(
                notification: notification
            )
        )
    }
    
    public func notificare(_ notificarePushUI: NotificarePushUI, didPresentNotification notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushUIPluginEventBroker.OnNotificationPresented(
                notification: notification
            )
        )
    }
    
    public func notificare(_ notificarePushUI: NotificarePushUI, didFinishPresentingNotification notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushUIPluginEventBroker.OnNotificationFinishedPresenting(
                notification: notification
            )
        )
    }
    
    public func notificare(_ notificarePushUI: NotificarePushUI, didFailToPresentNotification notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushUIPluginEventBroker.OnNotificationFailedToPresent(
                notification: notification
            )
        )
    }
    
    public func notificare(_ notificarePushUI: NotificarePushUI, didClickURL url: URL, in notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushUIPluginEventBroker.OnNotificationUrlClicked(
                notification: notification,
                url: url
            )
        )
    }
    
    public func notificare(_ notificarePushUI: NotificarePushUI, willExecuteAction action: NotificareNotification.Action, for notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushUIPluginEventBroker.OnActionWillExecute(
                notification: notification,
                action: action
            )
        )
    }
    
    public func notificare(_ notificarePushUI: NotificarePushUI, didExecuteAction action: NotificareNotification.Action, for notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushUIPluginEventBroker.OnActionExecuted(
                notification: notification,
                action: action
            )
        )
    }
    
    public func notificare(_ notificarePushUI: NotificarePushUI, didNotExecuteAction action: NotificareNotification.Action, for notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushUIPluginEventBroker.OnActionNotExecuted(
                notification: notification,
                action: action
            )
        )
    }
    
    public func notificare(_ notificarePushUI: NotificarePushUI, didFailToExecuteAction action: NotificareNotification.Action, for notification: NotificareNotification, error: Error?) {
        eventBroker.emit(
            NotificarePushUIPluginEventBroker.OnActionFailedToExecute(
                notification: notification,
                action: action,
                error: error
            )
        )
    }
    
    public func notificare(_ notificarePushUI: NotificarePushUI, didReceiveCustomAction url: URL, in action: NotificareNotification.Action, for notification: NotificareNotification) {
        eventBroker.emit(
            NotificarePushUIPluginEventBroker.OnCustomActionReceived(
                notification: notification,
                action: action,
                url: url
            )
        )
    }
}
