package re.notifica.iam.flutter

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import re.notifica.iam.models.NotificareInAppMessage

internal object NotificareInAppMessagingPluginEventBroker {

    private val streams: Map<Event.Type, Stream> by lazy {
        Event.Type.values().associateWith { Stream(it) }
    }

    fun register(messenger: BinaryMessenger) {
        streams.values.forEach {
            val channel = EventChannel(messenger, it.name, JSONMethodCodec.INSTANCE)
            channel.setStreamHandler(it)
        }
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
            MESSAGE_PRESENTED(id = "message_presented"),
            MESSAGE_FINISHED_PRESENTING(id = "message_finished_presenting"),
            MESSAGE_FAILED_TO_PRESENT(id = "message_failed_to_present"),
            ACTION_EXECUTED(id = "action_executed"),
            ACTION_FAILED_TO_EXECUTE(id = "action_failed_to_execute"),
        }

        class MessagePresented(
            message: NotificareInAppMessage,
        ) : Event() {
            override val type = Type.MESSAGE_PRESENTED
            override val payload = message.toJson()
        }

        class MessageFinishedPresenting(
            message: NotificareInAppMessage,
        ) : Event() {
            override val type = Type.MESSAGE_FINISHED_PRESENTING
            override val payload = message.toJson()
        }

        class MessageFailedToPresent(
            message: NotificareInAppMessage,
        ) : Event() {
            override val type = Type.MESSAGE_FAILED_TO_PRESENT
            override val payload = message.toJson()
        }

        class ActionExecuted(
            message: NotificareInAppMessage,
            action: NotificareInAppMessage.Action,
        ) : Event() {
            override val type = Type.ACTION_EXECUTED
            override val payload = mapOf(
                "message" to message.toJson(),
                "action" to action.toJson(),
            )
        }

        class ActionFailedToExecute(
            message: NotificareInAppMessage,
            action: NotificareInAppMessage.Action,
            error: Exception?,
        ) : Event() {
            override val type = Type.ACTION_FAILED_TO_EXECUTE
            override val payload = mapOf(
                "message" to message.toJson(),
                "action" to action.toJson(),
                "error" to error?.message,
            )
        }
    }


    class Stream(type: Event.Type) : EventChannel.StreamHandler {

        private var eventSink: EventChannel.EventSink? = null
        private val pendingEvents = mutableListOf<Event>()

        val name = "re.notifica.iam.flutter/events/${type.id}"

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
