package re.notifica.geo.flutter.storage

import android.content.Context
import re.notifica.geo.flutter.NotificareGeoPluginBackgroundService

internal object NotificareGeoPluginStorage {
    private const val sharedPreferencesKey = "re.notifica.geo.flutter.callback_shared_preferences"
    private const val callbackDispatcherKey = "re.notifica.geo.flutter.callback_dispatcher"

    internal fun Context.getCallbackDispatcher(): Long {
        return getSharedPreferences(sharedPreferencesKey, Context.MODE_PRIVATE)
            .getLong(callbackDispatcherKey, 0)
    }

    internal fun Context.getCallback(callbackType: NotificareGeoPluginBackgroundService.BackgroundEvent.CallbackType): Long {
        return getSharedPreferences(sharedPreferencesKey, Context.MODE_PRIVATE)
            .getLong(callbackType.key, 0)
    }

    internal fun Context.updateCallback(
        callbackType: NotificareGeoPluginBackgroundService.BackgroundEvent.CallbackType,
        callbackDispatcher: Long,
        callback: Long
    ) {
        getSharedPreferences(sharedPreferencesKey, Context.MODE_PRIVATE)
            .edit()
            .putLong(callbackDispatcherKey, callbackDispatcher)
            .putLong(callbackType.key, callback)
            .apply()
    }
}
