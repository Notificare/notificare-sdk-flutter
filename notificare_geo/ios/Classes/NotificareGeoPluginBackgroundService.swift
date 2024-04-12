//
//  NotificareGeoPluginBackgroundService.swift
//  notificare_geo
//
//  Created by Yevhenii Smirnov on 09/04/2024.
//

import NotificareKit
import NotificareGeoKit

fileprivate let DEFAULT_ERROR_CODE = "notificare_error"
fileprivate let NAMESPACE = "re.notifica.geo.flutter"

public class NotificareGeoPluginBackgroundService: NSObject, FlutterPlugin {
    internal static let instance = NotificareGeoPluginBackgroundService()
    
    private var registrar: FlutterPluginRegistrar?
    private var headlessRunner: FlutterEngine?
    private var callbackChannel: FlutterMethodChannel?
    
    private var isBackgroundStarting = false
    private var isInitialized = false
    private var pendingEvents: [BackgroundEvent] = []
    
    public static func register(with registrar: any FlutterPluginRegistrar) {
        instance.register(with: registrar)
    }
    
    private func register(with registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        
        if (callbackChannel == nil) {
            headlessRunner = FlutterEngine(name: "NotificareGeoIsolate", project: nil, allowHeadlessExecution: true)
            callbackChannel = FlutterMethodChannel(
                name: "\(NAMESPACE)/notificare_geo_background",
                binaryMessenger: headlessRunner!.binaryMessenger,
                codec: FlutterJSONMethodCodec.sharedInstance()
            )
        }
    }
    
    private func startBackgroundService() {
        guard let callbackDispatcher = LocalStorage.getCallbackDispatcher() else { return }
        guard let callback = FlutterCallbackCache.lookupCallbackInformation(callbackDispatcher) else { return }
        
        let entrypoint = callback.callbackName
        let uri = callback.callbackLibraryPath
        
        if (headlessRunner?.run(withEntrypoint: entrypoint, libraryURI: uri) != true) {
            isBackgroundStarting = false
            return
        }
        
        registrar?.addMethodCallDelegate(self, channel: callbackChannel!)
        
        callbackChannel?.setMethodCallHandler { (call, result) in
            switch call.method {
            case "onBackgroundServiceInitialized": self.onBackgroundServiceInitialized(call, result)
                
                // Unhandled
            default: result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func onBackgroundServiceInitialized(_ call: FlutterMethodCall, _ response: FlutterResult) {
        processPendingEvents()
        isInitialized = true
        
        response(nil)
    }
}

// Background process
extension NotificareGeoPluginBackgroundService {
    private var applicationState: UIApplication.State {
        return UIApplication.shared.applicationState
    }
    
    internal func shouldProcessAsBackgroundEvent() -> Bool {
        return applicationState != .active && applicationState != .inactive
    }
    
    internal func processAsBackgroundEvent(event: BackgroundEvent) {
        if (event.callback == nil || LocalStorage.getCallbackDispatcher() == nil) { return }
        
        if (!isBackgroundStarting) {
            isBackgroundStarting = true
            startBackgroundService()
        }
        
        processEvent(event: event)
    }
    
    private func processEvent(event: BackgroundEvent) {
        if (!isInitialized) {
            pendingEvents.append(event)
            
            return
        }
        
        callbackChannel?.invokeMethod(event.method.rawValue, arguments: event.payload)
    }
    
    private func processPendingEvents() {
        while !pendingEvents.isEmpty {
            let event = pendingEvents.removeFirst()
            
            callbackChannel?.invokeMethod(event.method.rawValue, arguments: event.payload)
        }
    }
}

// Background Event
extension NotificareGeoPluginBackgroundService {
    internal enum Method: String, CaseIterable {
        case locationUpdated = "location_updated"
        case regionEntered = "region_entered"
        case regionExited = "region_exited"
        case beaconEntered = "beacon_entered"
        case beaconExited = "beacon_exited"
        case beaconsRanged = "beacons_ranged"
        case visit = "visit"
        case headingUpdated = "heading_updated"
    }
    
    internal enum CallbackType: String, CaseIterable {
        case locationUpdated = "re.notifica.geo.flutter.location_updated_callback"
        case regionEntered = "re.notifica.geo.flutter.region_entered_callback"
        case regionExited = "re.notifica.geo.flutter.region_exited_callback"
        case beaconEntered = "re.notifica.geo.flutter.beacon_entered_callback"
        case beaconExited = "re.notifica.geo.flutter.beacon_exited_callback"
        case beaconsRanged = "re.notifica.geo.flutter.beacons_ranged_callback"
        case visit = "re.notifica.geo.flutter.visit_callback"
        case headingUpdated = "re.notifica.geo.flutter.heading_updated_callback"
    }
    
    internal struct BackgroundEvent {
        let method: Method
        let callback: Int64?
        let payload: [String : Any?]
    }
}

extension NotificareGeoPluginBackgroundService {
    internal static func LocationUpdated(location: NotificareLocation) -> BackgroundEvent {
        let callback = LocalStorage.getCallback(callbackType: .locationUpdated)
        
        return BackgroundEvent(
            method: .locationUpdated,
            callback: callback,
            payload: [
                "callback" : callback,
                "location" : try! location.toJson()
            ]
        )
    }
    
    internal static func RegionEntered(region: NotificareRegion) -> BackgroundEvent {
        let callback = LocalStorage.getCallback(callbackType: .regionEntered)
        
        return BackgroundEvent(
            method: .regionEntered,
            callback: callback,
            payload: [
                "callback" : callback,
                "region" : try! region.toJson()
            ]
        )
    }
    
    internal static func RegionExited(region: NotificareRegion) -> BackgroundEvent {
        let callback = LocalStorage.getCallback(callbackType: .regionExited)
        
        return BackgroundEvent(
            method: .regionExited,
            callback: callback,
            payload: [
                "callback" : callback,
                "region" : try! region.toJson()
            ]
        )
    }
    
    internal static func BeaconEntered(beacon: NotificareBeacon) -> BackgroundEvent {
        let callback = LocalStorage.getCallback(callbackType: .beaconEntered)
        
        return BackgroundEvent(
            method: .beaconEntered,
            callback: callback,
            payload: [
                "callback" : callback,
                "beacon" : try! beacon.toJson()
            ]
        )
    }
    
    internal static func BeaconExited(beacon: NotificareBeacon) -> BackgroundEvent {
        let callback = LocalStorage.getCallback(callbackType: .beaconExited)
        
        return BackgroundEvent(
            method: .beaconExited,
            callback: callback,
            payload: [
                "callback" : callback,
                "beacon" : try! beacon.toJson()
            ]
        )
    }
    
    internal static func BeaconsRanged(beacons: [NotificareBeacon], region: NotificareRegion) -> BackgroundEvent {
        let callback = LocalStorage.getCallback(callbackType: .beaconsRanged)
        
        return BackgroundEvent(
            method: .beaconsRanged,
            callback: callback,
            payload: [
                "callback" : callback,
                "beacons" : try! beacons.map { try $0.toJson() },
                "region" : try! region.toJson()
            ]
        )
    }
    
    internal static func Visit(visit: NotificareVisit) -> BackgroundEvent {
        let callback = LocalStorage.getCallback(callbackType: .visit)
        
        return BackgroundEvent(
            method: .visit,
            callback: callback,
            payload: [
                "callback" : callback,
                "visit" : try! visit.toJson()
            ]
        )
    }
    
    internal static func HeadingUpdated(heading: NotificareHeading) -> BackgroundEvent {
        let callback = LocalStorage.getCallback(callbackType: .headingUpdated)
        
        return BackgroundEvent(
            method: .headingUpdated,
            callback: callback,
            payload: [
                "callback" : callback,
                "heading" : try! heading.toJson()
            ]
        )
    }
}
