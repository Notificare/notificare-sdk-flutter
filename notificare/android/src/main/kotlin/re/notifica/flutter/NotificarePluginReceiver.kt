package re.notifica.flutter

import re.notifica.NotificareIntentReceiver
import re.notifica.flutter.events.NotificareEvent
import re.notifica.flutter.events.NotificareEventManager
import re.notifica.models.NotificareApplication
import re.notifica.models.NotificareDevice

class NotificarePluginReceiver : NotificareIntentReceiver() {

    override fun onDeviceRegistered(device: NotificareDevice) {
        NotificareEventManager.send(
            NotificareEvent.DeviceRegistered(device)
        )
    }

    override fun onReady(application: NotificareApplication) {
        NotificareEventManager.send(
            NotificareEvent.Ready(application)
        )
    }
}