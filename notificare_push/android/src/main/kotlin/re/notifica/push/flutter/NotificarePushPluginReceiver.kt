package re.notifica.push.flutter

import re.notifica.models.NotificareNotification
import re.notifica.push.NotificarePushIntentReceiver
import re.notifica.push.models.NotificareSystemNotification
import re.notifica.push.models.NotificareUnknownNotification

class NotificarePushPluginReceiver : NotificarePushIntentReceiver() {

    override fun onNotificationReceived(notification: NotificareNotification) {
        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.NotificationReceived(
                notification = notification,
            )
        )
    }

    override fun onSystemNotificationReceived(notification: NotificareSystemNotification) {
        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.SystemNotificationReceived(
                notification = notification,
            )
        )
    }

    override fun onUnknownNotificationReceived(notification: NotificareUnknownNotification) {
        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.UnknownNotificationReceived(
                notification = notification,
            )
        )
    }

    override fun onNotificationOpened(notification: NotificareNotification) {
        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.NotificationOpened(
                notification = notification,
            )
        )
    }

    override fun onActionOpened(notification: NotificareNotification, action: NotificareNotification.Action) {
        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.NotificationActionOpened(
                notification = notification,
                action = action,
            )
        )
    }
}
