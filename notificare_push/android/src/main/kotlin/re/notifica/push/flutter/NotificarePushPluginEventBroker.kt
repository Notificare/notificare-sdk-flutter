package re.notifica.push.flutter

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import re.notifica.models.NotificareNotification
import re.notifica.push.models.NotificareSystemNotification
import re.notifica.push.models.NotificareUnknownNotification

internal object NotificarePushPluginEventBroker {

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
            NOTIFICATION_RECEIVED(id = "notification_received"),
            SYSTEM_NOTIFICATION_RECEIVED(id = "system_notification_received"),
            UNKNOWN_NOTIFICATION_RECEIVED(id = "unknown_notification_received"),
            NOTIFICATION_OPENED(id = "notification_opened"),
            NOTIFICATION_ACTION_OPENED(id = "notification_action_opened"),
            NOTIFICATION_SETTINGS_CHANGED(id = "notification_settings_changed"),

            // iOS-only events (declared to prevent missing stream errors)
            UNKNOWN_NOTIFICATION_OPENED(id = "unknown_notification_opened"),
            UNKNOWN_NOTIFICATION_ACTION_OPENED(id = "unknown_notification_action_opened"),
            SHOULD_OPEN_NOTIFICATION_SETTINGS(id = "should_open_notification_settings"),
            FAILED_TO_REGISTER_FOR_REMOTE_NOTIFICATIONS(id = "failed_to_register_for_remote_notifications"),
        }

        class NotificationReceived(
            notification: NotificareNotification
        ) : Event() {
            override val type = Type.NOTIFICATION_RECEIVED
            override val payload = notification.toJson()
        }

        class SystemNotificationReceived(
            notification: NotificareSystemNotification
        ) : Event() {
            override val type = Type.SYSTEM_NOTIFICATION_RECEIVED
            override val payload = notification.toJson()
        }

        class UnknownNotificationReceived(
            notification: NotificareUnknownNotification
        ) : Event() {
            override val type = Type.UNKNOWN_NOTIFICATION_RECEIVED
            override val payload = mapOf(
                "messageId" to notification.messageId,
                "messageType" to notification.messageType,
                "senderId" to notification.senderId,
                "collapseKey" to notification.collapseKey,
                "from" to notification.from,
                "to" to notification.to,
                "sentTime" to notification.sentTime,
                "ttl" to notification.ttl,
                "priority" to notification.priority,
                "originalPriority" to notification.originalPriority,
                "notification" to notification.notification?.let {
                    mapOf(
                        "title" to it.title,
                        "titleLocalizationKey" to it.titleLocalizationKey,
                        "titleLocalizationArgs" to it.titleLocalizationArgs,
                        "body" to it.body,
                        "bodyLocalizationKey" to it.bodyLocalizationKey,
                        "bodyLocalizationArgs" to it.bodyLocalizationArgs,
                        "icon" to it.icon,
                        "imageUrl" to it.imageUrl,
                        "sound" to it.sound,
                        "tag" to it.tag,
                        "color" to it.color,
                        "clickAction" to it.clickAction,
                        "channelId" to it.channelId,
                        "link" to it.link?.toString(),
                        "ticker" to it.ticker,
                        "sticky" to it.sticky,
                        "localOnly" to it.localOnly,
                        "defaultSound" to it.defaultSound,
                        "defaultVibrateSettings" to it.defaultVibrateSettings,
                        "defaultLightSettings" to it.defaultLightSettings,
                        "notificationPriority" to it.notificationPriority,
                        "visibility" to it.visibility,
                        "notificationCount" to it.notificationCount,
                        "eventTime" to it.eventTime,
                        "lightSettings" to it.lightSettings,
                        "vibrateSettings" to it.vibrateSettings,
                    )
                },
                "data" to notification.data,
            )
        }

        class NotificationOpened(
            notification: NotificareNotification
        ) : Event() {
            override val type = Type.NOTIFICATION_OPENED
            override val payload = notification.toJson()
        }

        class NotificationActionOpened(
            notification: NotificareNotification,
            action: NotificareNotification.Action,
        ) : Event() {
            override val type = Type.NOTIFICATION_ACTION_OPENED
            override val payload = mapOf(
                "notification" to notification.toJson(),
                "action" to action.toJson(),
            )
        }

        class NotificationSettingsChanged(
            allowedUI: Boolean,
        ) : Event() {
            override val type = Type.NOTIFICATION_SETTINGS_CHANGED
            override val payload = allowedUI
        }
    }


    class Stream(type: Event.Type) : EventChannel.StreamHandler {

        private var eventSink: EventChannel.EventSink? = null
        private val pendingEvents = mutableListOf<Event>()

        val name = "${NotificarePushPlugin.NAMESPACE}/events/${type.id}"

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
