import Flutter
import UIKit
import NotificareKit
import NotificareAssetsKit

private typealias FlutterDictionary = [String: Any?]
private let DEFAULT_ERROR_CODE = "notificare_error"

public class SwiftNotificareAssetsPlugin: NSObject, FlutterPlugin {

    private static let instance = SwiftNotificareAssetsPlugin()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "re.notifica.assets.flutter/notificare_assets", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec.sharedInstance())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "fetch": fetch(call, result)
            
        // Unhandled
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Methods
    
    private func fetch(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        let group = call.arguments as! String
        
        Notificare.shared.assets().fetch(group: group) { result in
            switch result {
            case let .success(assets):
                do {
                    let json = try assets.map { try $0.toJson() }
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
