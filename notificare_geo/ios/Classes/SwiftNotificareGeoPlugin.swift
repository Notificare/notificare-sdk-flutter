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
        case "getMonitoredRegions": getMonitoredRegions(call, result)
        case "getEnteredRegions": getEnteredRegions(call, result)
        case "enableLocationUpdates": enableLocationUpdates(call, result)
        case "disableLocationUpdates": disableLocationUpdates(call, result)
        case "onLocationUpdatedCallback": onBackgroundCallback(call, result, callbackType: .locationUpdated)
        case "onRegionEnteredCallback": onBackgroundCallback(call, result, callbackType: .regionEntered)
        case "onRegionExitedCallback": onBackgroundCallback(call, result, callbackType: .regionExited)
        case "onBeaconEnteredCallback": onBackgroundCallback(call, result, callbackType: .beaconEntered)
        case "onBeaconExitedCallback": onBackgroundCallback(call, result, callbackType: .beaconExited)
        case "onBeaconsRangedCallback": onBackgroundCallback(call, result, callbackType: .beaconsRanged)
        case "onVisitCallback": onBackgroundCallback(call, result, callbackType: .visit)
        case "onHeadingUpdatedCallback": onBackgroundCallback(call, result, callbackType: .headingUpdated)

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

    private func getMonitoredRegions(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        do {
            let regions = try Notificare.shared.geo().monitoredRegions.map { region in
                try region.toJson()
            }

            response(regions)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
        }
    }

    private func getEnteredRegions(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        do {
            let regions = try Notificare.shared.geo().enteredRegions.map { region in
                try region.toJson()
            }

            response(regions)
        } catch {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: error.localizedDescription, details: nil))
        }
    }
    
    private func enableLocationUpdates(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.geo().enableLocationUpdates()
        response(nil)
    }
    
    private func disableLocationUpdates(_ call: FlutterMethodCall, _ response: @escaping FlutterResult) {
        Notificare.shared.geo().disableLocationUpdates()
        response(nil)
    }

    private func onBackgroundCallback(_ call: FlutterMethodCall, _ response: @escaping FlutterResult, callbackType: NotificareGeoPluginBackgroundService.CallbackType) {
        guard let arguments = call.arguments as? [String: Any] else {
            response(FlutterError(code: DEFAULT_ERROR_CODE, message: "Invalid request parameters.", details: nil))
            return
        }

        let callbackDispatcher = arguments["callbackDispatcher"] as! Int64
        let callback = arguments["callback"] as! Int64

        LocalStorage.setCallback(
            callbackType: callbackType,
            callbackDispatcher: callbackDispatcher,
            callback: callback
        )

        response(nil)
    }
}

extension SwiftNotificareGeoPlugin: NotificareGeoDelegate {
    public func notificare(_ notificareGeo: NotificareGeo, didUpdateLocations locations: [NotificareLocation]) {
        guard let location = locations.first else { return }

        if (NotificareGeoPluginBackgroundService.instance.shouldProcessAsBackgroundEvent()) {
            let event = NotificareGeoPluginBackgroundService.LocationUpdated(location: location)
            NotificareGeoPluginBackgroundService.instance.processAsBackgroundEvent(event: event)

            return
        }

        events.emit(
            NotificareGeoPluginEvents.OnLocationUpdated(location: location)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didEnter region: NotificareRegion) {
        if (NotificareGeoPluginBackgroundService.instance.shouldProcessAsBackgroundEvent()) {
            let event = NotificareGeoPluginBackgroundService.RegionEntered(region: region)
            NotificareGeoPluginBackgroundService.instance.processAsBackgroundEvent(event: event)

            return
        }

        events.emit(
            NotificareGeoPluginEvents.OnRegionEntered(region: region)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didExit region: NotificareRegion) {
        if (NotificareGeoPluginBackgroundService.instance.shouldProcessAsBackgroundEvent()) {
            let event = NotificareGeoPluginBackgroundService.RegionExited(region: region)
            NotificareGeoPluginBackgroundService.instance.processAsBackgroundEvent(event: event)

            return
        }

        events.emit(
            NotificareGeoPluginEvents.OnRegionExited(region: region)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didEnter beacon: NotificareBeacon) {
        if (NotificareGeoPluginBackgroundService.instance.shouldProcessAsBackgroundEvent()) {
            let event = NotificareGeoPluginBackgroundService.BeaconEntered(beacon: beacon)
            NotificareGeoPluginBackgroundService.instance.processAsBackgroundEvent(event: event)

            return
        }

        events.emit(
            NotificareGeoPluginEvents.OnBeaconEntered(beacon: beacon)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didExit beacon: NotificareBeacon) {
        if (NotificareGeoPluginBackgroundService.instance.shouldProcessAsBackgroundEvent()) {
            let event = NotificareGeoPluginBackgroundService.BeaconExited(beacon: beacon)
            NotificareGeoPluginBackgroundService.instance.processAsBackgroundEvent(event: event)

            return
        }

        events.emit(
            NotificareGeoPluginEvents.OnBeaconExited(beacon: beacon)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didRange beacons: [NotificareBeacon], in region: NotificareRegion) {
        if (NotificareGeoPluginBackgroundService.instance.shouldProcessAsBackgroundEvent()) {
            let event = NotificareGeoPluginBackgroundService.BeaconsRanged(beacons: beacons, region: region)
            NotificareGeoPluginBackgroundService.instance.processAsBackgroundEvent(event: event)

            return
        }

        events.emit(
            NotificareGeoPluginEvents.OnBeaconsRanged(beacons: beacons, in: region)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didVisit visit: NotificareVisit) {
        if (NotificareGeoPluginBackgroundService.instance.shouldProcessAsBackgroundEvent()) {
            let event = NotificareGeoPluginBackgroundService.Visit(visit: visit)
            NotificareGeoPluginBackgroundService.instance.processAsBackgroundEvent(event: event)

            return
        }

        events.emit(
            NotificareGeoPluginEvents.OnVisit(visit: visit)
        )
    }
    
    public func notificare(_ notificareGeo: NotificareGeo, didUpdateHeading heading: NotificareHeading) {
        if (NotificareGeoPluginBackgroundService.instance.shouldProcessAsBackgroundEvent()) {
            let event = NotificareGeoPluginBackgroundService.HeadingUpdated(heading: heading)
            NotificareGeoPluginBackgroundService.instance.processAsBackgroundEvent(event: event)

            return
        }

        events.emit(
            NotificareGeoPluginEvents.OnHeadingUpdated(heading: heading)
        )
    }
}
