package re.notifica.flutter

import android.content.Context
import re.notifica.NotificareIntentReceiver
import re.notifica.flutter.events.NotificareEvent
import re.notifica.flutter.events.NotificareEventManager
import re.notifica.models.NotificareApplication
import re.notifica.models.NotificareDevice

class NotificarePluginReceiver : NotificareIntentReceiver() {

    override fun onDeviceRegistered(context: Context, device: NotificareDevice) {
        NotificareEventManager.send(
            NotificareEvent.DeviceRegistered(device)
        )
    }

    override fun onReady(context: Context, application: NotificareApplication) {
        NotificareEventManager.send(
            NotificareEvent.Ready(application)
        )
    }
}
