import Flutter
import UIKit
import NotificareKit
import NotificareScannablesKit

private typealias FlutterDictionary = [String: Any?]
private let DEFAULT_ERROR_CODE = "notificare_error"

public class SwiftNotificareScannablesPlugin: NSObject, FlutterPlugin {
    private static let instance = SwiftNotificareScannablesPlugin()
    private let events = NotificareScannablesPluginEvents(packageId: "re.notifica.scannables.flutter")
    
    private var rootViewController: UIViewController? {
        get {
            UIApplication.shared.delegate?.window??.rootViewController
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "re.notifica.scannables.flutter/notificare_scannables", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec.sharedInstance())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        instance.events.setup(registrar: registrar)
        Notificare.shared.scannables().delegate = instance
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "canStartNfcScannableSession": canStartNfcScannableSession(call, result)
        case "startScannableSession": startScannableSession(call, result)
        case "startNfcScannableSession": startNfcScannableSession(call, result)
        case "startQrCodeScannableSession": startQrCodeScannableSession(call, result)
        case "fetch": fetch(call, result)

        // Unhandled
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Methods
    
    private func canStartNfcScannableSession(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        response(Notificare.shared.scannables().canStartNfcScannableSession)
    }
    
    private func startScannableSession(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        guard let rootViewController = rootViewController else {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: "Cannot start a scannable session with a nil root view controller.", details: nil))
            return
        }
        
        Notificare.shared.scannables().startScannableSession(controller: rootViewController)
        response(nil)
    }
    
    private func startNfcScannableSession(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.scannables().startNfcScannableSession()
        response(nil)
    }
    
    private func startQrCodeScannableSession(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        guard let rootViewController = rootViewController else {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: "Cannot start a scannable session with a nil root view controller.", details: nil))
            return
        }
        
        Notificare.shared.scannables().startQrCodeScannableSession(controller: rootViewController, modal: true)
        response(nil)
    }
    
    private func fetch(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let tag = call.arguments as! String
        
        Notificare.shared.scannables().fetch(tag: tag) { result in
            switch result {
            case let .success(scannable):
                do {
                    let json = try scannable.toJson()
                    response(json)
                } catch {
                    response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
                }
            case let .failure(error):
                response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
            }
        }
    }
}

extension SwiftNotificareScannablesPlugin: NotificareScannablesDelegate {
    public func notificare(_ notificareScannables: NotificareScannables, didDetectScannable scannable: NotificareScannable) {
        events.emit(NotificareScannablesPluginEvents.OnScannableDetected(scannable: scannable))
    }
    
    public func notificare(_ notificareScannables: NotificareScannables, didInvalidateScannerSession error: Error) {
        events.emit(NotificareScannablesPluginEvents.OnScannableSessionFailed(error: error))
    }
}
