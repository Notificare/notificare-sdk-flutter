package re.notifica.push.ui.flutter

import android.net.Uri
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import re.notifica.models.NotificareNotification

internal object NotificarePushUIPluginEventBroker {

    private val streams: Map<Event.Type, Stream> by lazy {
        Event.Type.values().associate {
            it to Stream(it)
        }
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
            NOTIFICATION_WILL_PRESENT(id = "notification_will_present"),
            NOTIFICATION_PRESENTED(id = "notification_presented"),
            NOTIFICATION_FINISHED_PRESENTING(id = "notification_finished_presenting"),
            NOTIFICATION_FAILED_TO_PRESENT(id = "notification_failed_to_present"),
            NOTIFICATION_URL_CLICKED(id = "notification_url_clicked"),
            ACTION_WILL_EXECUTE(id = "action_will_execute"),
            ACTION_EXECUTED(id = "action_executed"),
            ACTION_NOT_EXECUTED(id = "action_not_executed"),
            ACTION_FAILED_TO_EXECUTE(id = "action_failed_to_execute"),
            CUSTOM_ACTION_RECEIVED(id = "custom_action_received"),
        }

        class NotificationWillPresent(
            notification: NotificareNotification
        ) : Event() {
            override val type = Type.NOTIFICATION_WILL_PRESENT
            override val payload = notification.toJson()
        }

        class NotificationPresented(
            notification: NotificareNotification
        ) : Event() {
            override val type = Type.NOTIFICATION_PRESENTED
            override val payload = notification.toJson()
        }

        class NotificationFinishedPresenting(
            notification: NotificareNotification
        ) : Event() {
            override val type = Type.NOTIFICATION_FINISHED_PRESENTING
            override val payload = notification.toJson()
        }

        class NotificationFailedToPresent(
            notification: NotificareNotification
        ) : Event() {
            override val type = Type.NOTIFICATION_FAILED_TO_PRESENT
            override val payload = notification.toJson()
        }

        class NotificationUrlClicked(
            notification: NotificareNotification,
            uri: Uri,
        ) : Event() {
            override val type = Type.NOTIFICATION_URL_CLICKED
            override val payload = mapOf(
                "notification" to notification.toJson(),
                "url" to uri.toString(),
            )
        }

        class ActionWillExecute(
            notification: NotificareNotification,
            action: NotificareNotification.Action,
        ) : Event() {
            override val type = Type.ACTION_WILL_EXECUTE
            override val payload = mapOf(
                "notification" to notification.toJson(),
                "action" to action.toJson(),
            )
        }

        class ActionExecuted(
            notification: NotificareNotification,
            action: NotificareNotification.Action,
        ) : Event() {
            override val type = Type.ACTION_EXECUTED
            override val payload = mapOf(
                "notification" to notification.toJson(),
                "action" to action.toJson(),
            )
        }

        @Suppress("unused")
        class ActionNotExecuted(
            notification: NotificareNotification,
            action: NotificareNotification.Action,
        ) : Event() {
            override val type = Type.ACTION_NOT_EXECUTED
            override val payload = mapOf(
                "notification" to notification.toJson(),
                "action" to action.toJson(),
            )
        }

        class ActionFailedToExecute(
            notification: NotificareNotification,
            action: NotificareNotification.Action,
            error: Exception?,
        ) : Event() {
            override val type = Type.ACTION_FAILED_TO_EXECUTE
            override val payload = mapOf(
                "notification" to notification.toJson(),
                "action" to action.toJson(),
                "error" to error?.message,
            )
        }

        class CustomActionReceived(
            notification: NotificareNotification,
            action: NotificareNotification.Action,
            uri: Uri,
        ) : Event() {
            override val type = Type.CUSTOM_ACTION_RECEIVED
            override val payload = mapOf(
                "notification" to notification.toJson(),
                "action" to action.toJson(),
                "uri" to uri.toString(),
            )
        }
    }


    class Stream(type: Event.Type) : EventChannel.StreamHandler {

        private var eventSink: EventChannel.EventSink? = null
        private val pendingEvents = mutableListOf<Event>()

        val name = "${NotificarePushUIPlugin.NAMESPACE}/events/${type.id}"

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
