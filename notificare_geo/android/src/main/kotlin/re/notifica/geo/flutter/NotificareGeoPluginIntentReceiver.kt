package re.notifica.geo.flutter

import android.content.Context
import re.notifica.geo.NotificareGeoIntentReceiver
import re.notifica.geo.models.NotificareBeacon
import re.notifica.geo.models.NotificareLocation
import re.notifica.geo.models.NotificareRegion

internal class NotificareGeoPluginIntentReceiver : NotificareGeoIntentReceiver() {
    override fun onLocationUpdated(context: Context, location: NotificareLocation) {
        if (NotificareGeoPluginBackgroundService.shouldProcessAsBackgroundEvent()) {
            val event = NotificareGeoPluginBackgroundService.BackgroundEvent.LocationUpdated(context, location)
            NotificareGeoPluginBackgroundService.processAsBackgroundEvent(context, event)

            return
        }

        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.LocationUpdated(location)
        )
    }

    override fun onRegionEntered(context: Context, region: NotificareRegion) {
        if (NotificareGeoPluginBackgroundService.shouldProcessAsBackgroundEvent()) {
            val event = NotificareGeoPluginBackgroundService.BackgroundEvent.RegionEntered(context, region)
            NotificareGeoPluginBackgroundService.processAsBackgroundEvent(context, event)

            return
        }

        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.RegionEntered(region)
        )
    }

    override fun onRegionExited(context: Context, region: NotificareRegion) {
        if (NotificareGeoPluginBackgroundService.shouldProcessAsBackgroundEvent()) {
            val event = NotificareGeoPluginBackgroundService.BackgroundEvent.RegionExited(context, region)
            NotificareGeoPluginBackgroundService.processAsBackgroundEvent(context, event)

            return
        }

        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.RegionExited(region)
        )
    }

    override fun onBeaconEntered(context: Context, beacon: NotificareBeacon) {
        if (NotificareGeoPluginBackgroundService.shouldProcessAsBackgroundEvent()) {
            val event = NotificareGeoPluginBackgroundService.BackgroundEvent.BeaconEntered(context, beacon)
            NotificareGeoPluginBackgroundService.processAsBackgroundEvent(context, event)

            return
        }

        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.BeaconEntered(beacon)
        )
    }

    override fun onBeaconExited(context: Context, beacon: NotificareBeacon) {
        if (NotificareGeoPluginBackgroundService.shouldProcessAsBackgroundEvent()) {
            val event = NotificareGeoPluginBackgroundService.BackgroundEvent.BeaconExited(context, beacon)
            NotificareGeoPluginBackgroundService.processAsBackgroundEvent(context, event)

            return
        }

        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.BeaconExited(beacon)
        )
    }

    override fun onBeaconsRanged(context: Context, region: NotificareRegion, beacons: List<NotificareBeacon>) {
        if (NotificareGeoPluginBackgroundService.shouldProcessAsBackgroundEvent()) {
            val event = NotificareGeoPluginBackgroundService.BackgroundEvent.BeaconsRanged(context, beacons, region)
            NotificareGeoPluginBackgroundService.processAsBackgroundEvent(context, event)

            return
        }

        NotificareGeoPluginEventBroker.emit(
            NotificareGeoPluginEventBroker.Event.BeaconsRanged(region, beacons)
        )
    }
}
