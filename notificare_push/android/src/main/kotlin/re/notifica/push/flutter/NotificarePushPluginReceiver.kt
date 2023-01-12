package re.notifica.push.flutter

import android.content.Context
import re.notifica.models.NotificareNotification
import re.notifica.push.NotificarePushIntentReceiver
import re.notifica.push.models.NotificareNotificationDeliveryMechanism
import re.notifica.push.models.NotificareSystemNotification
import re.notifica.push.models.NotificareUnknownNotification

class NotificarePushPluginReceiver : NotificarePushIntentReceiver() {

    override fun onNotificationReceived(
        context: Context,
        notification: NotificareNotification,
        deliveryMechanism: NotificareNotificationDeliveryMechanism
    ) {
        // Continue emitting the legacy event to preserve backwards compatibility.
        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.NotificationReceived(
                notification = notification,
            )
        )

        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.NotificationInfoReceived(
                notification = notification,
                deliveryMechanism = deliveryMechanism
            )
        )
    }

    override fun onSystemNotificationReceived(context: Context, notification: NotificareSystemNotification) {
        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.SystemNotificationReceived(
                notification = notification,
            )
        )
    }

    override fun onUnknownNotificationReceived(context: Context, notification: NotificareUnknownNotification) {
        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.UnknownNotificationReceived(
                notification = notification,
            )
        )
    }

    override fun onNotificationOpened(context: Context, notification: NotificareNotification) {
        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.NotificationOpened(
                notification = notification,
            )
        )
    }

    override fun onActionOpened(
        context: Context,
        notification: NotificareNotification,
        action: NotificareNotification.Action,
    ) {
        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.NotificationActionOpened(
                notification = notification,
                action = action,
            )
        )
    }
}
