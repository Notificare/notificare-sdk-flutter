package re.notifica.geo.flutter

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import re.notifica.Notificare
import re.notifica.geo.NotificareGeo
import re.notifica.geo.ktx.geo
import re.notifica.geo.models.NotificareBeacon
import re.notifica.geo.models.NotificareLocation
import re.notifica.geo.models.NotificareRegion
import re.notifica.geo.models.toJson

class NotificareGeoPlugin : FlutterPlugin, MethodCallHandler, NotificareGeo.Listener {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "re.notifica.geo.flutter/notificare_geo",
            JSONMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)

        NotificareGeoPluginEventBroker.register(flutterPluginBinding.binaryMessenger)
        Notificare.geo().addListener(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)

        Notificare.geo().removeListener(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "hasLocationServicesEnabled" -> hasLocationServicesEnabled(call, result)
            "hasBluetoothEnabled" -> hasBluetoothEnabled(call, result)
            "getMonitoredRegions" -> getMonitoredRegions(call, result)
            "getEnteredRegions" -> getEnteredRegions(call, result)
            "enableLocationUpdates" -> enableLocationUpdates(call, result)
            "disableLocationUpdates" -> disableLocationUpdates(call, result)
            else -> result.notImplemented()
        }
    }

    private fun hasLocationServicesEnabled(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        response.success(Notificare.geo().hasLocationServicesEnabled)
    }

    private fun hasBluetoothEnabled(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        response.success(Notificare.geo().hasBluetoothEnabled)
    }

    private fun getMonitoredRegions(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        response.success(
            Notificare.geo().monitoredRegions.map { it.toJson() }
        )
    }

    private fun getEnteredRegions(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        response.success(
            Notificare.geo().enteredRegions.map { it.toJson() }
        )
    }

    private fun enableLocationUpdates(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        Notificare.geo().enableLocationUpdates()
        response.success(null)
    }

    private fun disableLocationUpdates(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        Notificare.geo().disableLocationUpdates()
        response.success(null)
    }

    // region NotificareGeo.Listener

    override fun onLocationUpdated(location: NotificareLocation) {
        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.LocationUpdated(location)
        )
    }

    override fun onRegionEntered(region: NotificareRegion) {
        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.RegionEntered(region)
        )
    }

    override fun onRegionExited(region: NotificareRegion) {
        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.RegionExited(region)
        )
    }

    override fun onBeaconEntered(beacon: NotificareBeacon) {
        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.BeaconEntered(beacon)
        )
    }

    override fun onBeaconExited(beacon: NotificareBeacon) {
        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.BeaconExited(beacon)
        )
    }

    override fun onBeaconsRanged(region: NotificareRegion, beacons: List<NotificareBeacon>) {
        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.BeaconsRanged(region, beacons)
        )
    }

    // endregion
}
