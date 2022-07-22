import Flutter
import UIKit
import NotificareKit
import NotificareMonetizeKit

private typealias FlutterDictionary = [String: Any?]
private let DEFAULT_ERROR_CODE = "notificare_error"

public class SwiftNotificareMonetizePlugin: NSObject, FlutterPlugin {
    private static let instance = SwiftNotificareMonetizePlugin()
    private let events = NotificareMonetizePluginEvents(packageId: "re.notifica.monetize.flutter")
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "re.notifica.monetize.flutter/notificare_monetize", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec.sharedInstance())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        instance.events.setup(registrar: registrar)
        Notificare.shared.monetize().delegate = instance
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "refresh": refresh(call, result)
        case "startPurchaseFlow": startPurchaseFlow(call, result)

        // Unhandled
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Methods
    
    private func refresh(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.monetize().refresh { result in
            switch result {
            case .success:
                response(nil)
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
    
    private func startPurchaseFlow(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let product: NotificareProduct

        do {
            let json = call.arguments as! [String: Any]
            product = try NotificareProduct.fromJson(json: json)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            return
        }
        
        Notificare.shared.monetize().startPurchaseFlow(for: product)
        response(nil)
    }
}

extension SwiftNotificareMonetizePlugin: NotificareMonetizeDelegate {
    public func notificare(_ notificareMonetize: NotificareMonetize, didUpdateProducts products: [NotificareProduct]) {
        events.emit(NotificareMonetizePluginEvents.OnProductsUpdated(products: products))
    }
    
    public func notificare(_ notificareMonetize: NotificareMonetize, didUpdatePurchases purchases: [NotificarePurchase]) {
        events.emit(NotificareMonetizePluginEvents.OnPurchasesUpdated(purchases: purchases))
    }
    
    public func notificare(_ notificareMonetize: NotificareMonetize, didFinishPurchase purchase: NotificarePurchase) {
        events.emit(NotificareMonetizePluginEvents.OnPurchaseFinished(purchase: purchase))
    }
    
    public func notificare(_ notificareMonetize: NotificareMonetize, didRestorePurchase purchase: NotificarePurchase) {
        events.emit(NotificareMonetizePluginEvents.OnPurchaseRestored(purchase: purchase))
    }
    
    public func notificareDidCancelPurchase(_ notificareMonetize: NotificareMonetize) {
        events.emit(NotificareMonetizePluginEvents.OnPurchaseCanceled())
    }
    
    public func notificare(_ notificareMonetize: NotificareMonetize, didFailToPurchase error: Error) {
        events.emit(NotificareMonetizePluginEvents.OnPurchaseFailed(error: error))
    }
}
