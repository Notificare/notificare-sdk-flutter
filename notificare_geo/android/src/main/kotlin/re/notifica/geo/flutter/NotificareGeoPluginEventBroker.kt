package re.notifica.geo.flutter

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import re.notifica.geo.models.NotificareBeacon
import re.notifica.geo.models.NotificareLocation
import re.notifica.geo.models.NotificareRegion
import re.notifica.geo.models.toJson

internal object NotificareGeoPluginEventBroker {

    private val channels = mutableMapOf<Event.Type, EventChannel>()

    private val streams: Map<Event.Type, Stream> by lazy {
        Event.Type.values().map {
            it to Stream(it)
        }.toMap()
    }

    fun register(messenger: BinaryMessenger) {
        streams.forEach { (eventType, stream) ->
            val channel = channels[eventType]
                ?: EventChannel(messenger, stream.name, JSONMethodCodec.INSTANCE).also {
                    // Keep a copy of it.
                    channels[eventType] = it
                }

            channel.setStreamHandler(stream)
        }
    }

    fun unregister() {
        channels.forEach { it.value.setStreamHandler(null) }
    }

    fun emit(event: Event) {
        Handler(Looper.getMainLooper()).post {
            streams[event.type]?.emit(event)
        }
    }


    sealed class Event {

        abstract val type: Type
        abstract val payload: Any?

        enum class Type(val id: String) {
            LOCATION_UPDATED(id = "location_updated"),
            REGION_ENTERED(id = "region_entered"),
            REGION_EXITED(id = "region_exited"),
            BEACON_ENTERED(id = "beacon_entered"),
            BEACON_EXITED(id = "beacon_exited"),
            BEACONS_RANGED(id = "beacons_ranged"),

            // iOS-only events
            VISIT(id = "visit"),
            HEADING_UPDATED(id = "heading_updated"),
        }

        class LocationUpdated(
            location: NotificareLocation,
        ) : Event() {
            override val type = Type.LOCATION_UPDATED
            override val payload = location.toJson()
        }

        class RegionEntered(
            region: NotificareRegion,
        ) : Event() {
            override val type = Type.REGION_ENTERED
            override val payload = region.toJson()
        }

        class RegionExited(
            region: NotificareRegion,
        ) : Event() {
            override val type = Type.REGION_EXITED
            override val payload = region.toJson()
        }

        class BeaconEntered(
            beacon: NotificareBeacon,
        ) : Event() {
            override val type = Type.BEACON_ENTERED
            override val payload = beacon.toJson()
        }

        class BeaconExited(
            beacon: NotificareBeacon,
        ) : Event() {
            override val type = Type.BEACON_EXITED
            override val payload = beacon.toJson()
        }

        class BeaconsRanged(
            region: NotificareRegion,
            beacons: List<NotificareBeacon>,
        ) : Event() {
            override val type = Type.BEACONS_RANGED
            override val payload = mapOf(
                "region" to region.toJson(),
                "beacons" to beacons.map { it.toJson() }
            )
        }
    }


    class Stream(type: Event.Type) : EventChannel.StreamHandler {

        private var eventSink: EventChannel.EventSink? = null
        private val pendingEvents = mutableListOf<Event>()

        val name = "re.notifica.geo.flutter/events/${type.id}"

        fun emit(event: Event) {
            val eventSink = this.eventSink

            if (eventSink == null) {
                pendingEvents.add(event)
            } else {
                eventSink.success(event.payload)
            }
        }

        override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
            this.eventSink = eventSink

            if (eventSink != null) {
                pendingEvents.forEach(::emit)
                pendingEvents.clear()
            }
        }

        override fun onCancel(arguments: Any?) {
            this.eventSink = null
        }
    }
}
