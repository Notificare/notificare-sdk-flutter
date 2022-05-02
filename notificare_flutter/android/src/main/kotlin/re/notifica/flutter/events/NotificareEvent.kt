package re.notifica.flutter.events

import re.notifica.models.NotificareApplication
import re.notifica.models.NotificareDevice

internal sealed class NotificareEvent {

    abstract val type: Type
    abstract val payload: Any?

    enum class Type(val id: String) {
        READY(id = "ready"),
        UNLAUNCHED(id = "unlaunched"),
        DEVICE_REGISTERED(id = "device_registered"),
        URL_OPENED(id = "url_opened"),
    }

    class Ready(
        application: NotificareApplication
    ) : NotificareEvent() {
        override val type = Type.READY
        override val payload = application.toJson()
    }

    class Unlaunched : NotificareEvent() {
        override val type = Type.UNLAUNCHED
        override val payload: Nothing? = null
    }

    class DeviceRegistered(
        device: NotificareDevice
    ) : NotificareEvent() {
        override val type = Type.DEVICE_REGISTERED
        override val payload = device.toJson()
    }

    class UrlOpened(
        url: String,
    ) : NotificareEvent() {
        override val type = Type.URL_OPENED
        override val payload = url
    }
}
