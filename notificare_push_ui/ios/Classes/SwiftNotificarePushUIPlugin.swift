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
    
    private func register(with registrar: FlutterPluginRegistrar) {
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
        
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: "Cannot present a notification with a nil root view controller.", details: nil))
            return
        }
        
        if notification.requiresViewController {
            let navigationController = createNavigationController()
            rootViewController.present(navigationController, animated: true) {
                NotificarePushUI.shared.presentNotification(notification, in: navigationController)
                response(nil)
            }
        } else {
            NotificarePushUI.shared.presentNotification(notification, in: rootViewController)
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
        
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: "Cannot present a notification with a nil root view controller.", details: nil))
            return
        }
        
        NotificarePushUI.shared.presentAction(action, for: notification, in: rootViewController)
        response(nil)
    }
    
    private func createNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        let theme = Notificare.shared.options?.theme(for: navigationController)
        
        if let colorStr = theme?.backgroundColor {
            navigationController.view.backgroundColor = UIColor(hexString: colorStr)
        } else {
            navigationController.view.backgroundColor = .white
        }
        
        let closeButton: UIBarButtonItem
        if let closeButtonImage = NotificareLocalizable.image(resource: .close) {
            closeButton = UIBarButtonItem(image: closeButtonImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(onCloseClicked))
        } else {
            closeButton = UIBarButtonItem(title: NotificareLocalizable.string(resource: .closeButton),
                                          style: .plain,
                                          target: self,
                                          action: #selector(onCloseClicked))
        }
        
        if let colorStr = theme?.actionButtonTextColor {
            closeButton.tintColor = UIColor(hexString: colorStr)
        }
        
        navigationController.navigationItem.leftBarButtonItem = closeButton
        
        return navigationController
    }
    
    @objc private func onCloseClicked() {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
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
