import Flutter
import UIKit
import NotificareKit
import NotificareGeoKit

private typealias FlutterDictionary = [String: Any?]
private let DEFAULT_ERROR_CODE = "notificare_error"

public class SwiftNotificareGeoPlugin: NSObject, FlutterPlugin {
    
    private static let instance = SwiftNotificareGeoPlugin()
    private let events = NotificareGeoPluginEvents(packageId: "re.notifica.geo.flutter")
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "re.notifica.geo.flutter/notificare_geo", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec.sharedInstance())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        instance.events.setup(registrar: registrar)
        Notificare.shared.geo().delegate = instance
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "hasLocationServicesEnabled": hasLocationServicesEnabled(call, result)
        case "hasBluetoothEnabled": hasBluetoothEnabled(call, result)
        case "enableLocationUpdates": enableLocationUpdates(call, result)
        case "disableLocationUpdates": disableLocationUpdates(call, result)

        // Unhandled
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Methods
    
    private func hasLocationServicesEnabled(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        response(Notificare.shared.geo().hasLocationServicesEnabled)
    }
    
    private func hasBluetoothEnabled(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        response(Notificare.shared.geo().hasBluetoothEnabled)
    }
    
    private func enableLocationUpdates(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.geo().enableLocationUpdates()
        response(nil)
    }
    
    private func disableLocationUpdates(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.geo().disableLocationUpdates()
        response(nil)
    }
}

extension SwiftNotificareGeoPlugin: NotificareGeoDelegate {
    public func notificare(_ notificareGeo: NotificareGeo, didUpdateLocations locations: [NotificareLocation]) {
        guard let location = locations.first else { return }
        
        events.emit(
            NotificareGeoPluginEvents.OnLocationUpdated(location: location)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didEnter region: NotificareRegion) {
        events.emit(
            NotificareGeoPluginEvents.OnRegionEntered(region: region)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didExit region: NotificareRegion) {
        events.emit(
            NotificareGeoPluginEvents.OnRegionExited(region: region)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didEnter beacon: NotificareBeacon) {
        events.emit(
            NotificareGeoPluginEvents.OnBeaconEntered(beacon: beacon)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didExit beacon: NotificareBeacon) {
        events.emit(
            NotificareGeoPluginEvents.OnBeaconExited(beacon: beacon)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didRange beacons: [NotificareBeacon], in region: NotificareRegion) {
        events.emit(
            NotificareGeoPluginEvents.OnBeaconsRanged(beacons: beacons, in: region)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didVisit visit: NotificareVisit) {
        events.emit(
            NotificareGeoPluginEvents.OnVisit(visit: visit)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didUpdateHeading heading: NotificareHeading) {
        events.emit(
            NotificareGeoPluginEvents.OnHeadingUpdated(heading: heading)
        )
    }
}
