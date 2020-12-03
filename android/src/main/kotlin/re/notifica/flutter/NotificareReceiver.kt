package re.notifica.flutter

import re.notifica.app.NotificareIntentReceiver
import re.notifica.flutter.events.NotificareEvent
import re.notifica.flutter.events.NotificareEventManager
import re.notifica.models.NotificareDevice

class NotificareReceiver : NotificareIntentReceiver() {

    override fun onDeviceRegistered(device: NotificareDevice) {
        NotificareEventManager.send(
            NotificareEvent.DeviceRegistered(device)
        )
    }

    override fun onReady() {
        NotificareEventManager.send(
            NotificareEvent.Ready
        )
    }
}
