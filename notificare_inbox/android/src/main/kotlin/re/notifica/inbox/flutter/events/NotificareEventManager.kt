package re.notifica.inbox.flutter.events

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec

internal object NotificareEventManager {

    private val streams: Map<NotificareEvent.Type, NotificareEventStream> by lazy {
        NotificareEvent.Type.values().associate {
            it to NotificareEventStream(it)
        }
    }

    fun register(messenger: BinaryMessenger) {
        streams.values.forEach {
            val channel = EventChannel(messenger, it.name, JSONMethodCodec.INSTANCE)
            channel.setStreamHandler(it)
        }
    }

    fun send(event: NotificareEvent) {
        Handler(Looper.getMainLooper()).post {
            streams[event.type]?.emit(event)
        }
    }
}
