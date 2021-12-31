package re.notifica.scannables.flutter

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import re.notifica.scannables.models.NotificareScannable
import re.notifica.scannables.models.toJson

internal object NotificareScannablesPluginEventBroker {

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
            SCANNABLE_DETECTED(id = "scannable_detected"),
            SCANNABLE_SESSION_FAILED(id = "scannable_session_failed"),
        }

        class ScannableDetected(
            scannable: NotificareScannable,
        ) : Event() {
            override val type = Type.SCANNABLE_DETECTED
            override val payload = scannable.toJson()
        }

        class ScannableSessionFailed(
            error: Exception,
        ) : Event() {
            override val type = Type.SCANNABLE_SESSION_FAILED
            override val payload = error.localizedMessage
        }
    }


    class Stream(type: Event.Type) : EventChannel.StreamHandler {

        private var eventSink: EventChannel.EventSink? = null
        private val pendingEvents = mutableListOf<Event>()

        val name = "re.notifica.scannables.flutter/events/${type.id}"

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
