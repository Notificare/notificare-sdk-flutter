package re.notifica.flutter.events

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec

internal object NotificareEventManager {

    private val channels = mutableMapOf<NotificareEvent.Type, EventChannel>()

    private val streams: Map<NotificareEvent.Type, NotificareEventStream> by lazy {
        NotificareEvent.Type.values().map {
            it to NotificareEventStream(it)
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

    fun send(event: NotificareEvent) {
        Handler(Looper.getMainLooper()).post {
            streams[event.type]?.emit(event)
        }
    }
}
