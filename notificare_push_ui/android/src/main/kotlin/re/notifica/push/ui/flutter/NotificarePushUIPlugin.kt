package re.notifica.push.ui.flutter

import android.app.Activity
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import re.notifica.Notificare
import re.notifica.internal.NotificareLogger
import re.notifica.models.NotificareNotification
import re.notifica.push.ui.NotificarePushUI
import re.notifica.push.ui.ktx.pushUI

public class NotificarePushUIPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    NotificarePushUI.NotificationLifecycleListener {

    public companion object {
        internal const val NAMESPACE = "re.notifica.push.ui.flutter"
        private const val NOTIFICARE_ERROR = "notificare_error"
    }

    private var activity: Activity? = null

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "$NAMESPACE/notificare_push_ui", JSONMethodCodec.INSTANCE)
        channel.setMethodCallHandler(this)

        logger.hasDebugLoggingEnabled = Notificare.options?.debugLoggingEnabled ?: false

        NotificarePushUIPluginEventBroker.register(binding.binaryMessenger)

        Notificare.pushUI().addLifecycleListener(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "presentNotification" -> presentNotification(call, result)
            "presentAction" -> presentAction(call, result)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        Notificare.pushUI().removeLifecycleListener(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivityForConfigChanges() {}

    private fun presentNotification(call: MethodCall, result: Result) {
        val activity = activity ?: run {
            NotificareLogger.warning("Flutter attached activity was null. Cannot continue.")
            result.error(NOTIFICARE_ERROR, "Method called before an activity was attached.", null)
            return
        }

        val arguments = call.arguments<JSONObject>()
            ?: return result.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)

        val notification = NotificareNotification.fromJson(arguments)

        Notificare.pushUI().presentNotification(activity, notification)
        result.success(null)
    }

    private fun presentAction(call: MethodCall, result: Result) {
        val activity = activity ?: run {
            NotificareLogger.warning("Flutter attached activity was null. Cannot continue.")
            result.error(NOTIFICARE_ERROR, "Method called before an activity was attached.", null)
            return
        }

        val json: JSONObject = call.arguments()
            ?: return result.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)

        val notification = NotificareNotification.fromJson(json.getJSONObject("notification"))
        val action = NotificareNotification.Action.fromJson(json.getJSONObject("action"))

        Notificare.pushUI().presentAction(activity, notification, action)
        result.success(null)
    }

    // region NotificarePushUI.NotificationLifecycleListener

    override fun onNotificationWillPresent(notification: NotificareNotification) {
        NotificarePushUIPluginEventBroker.emit(
            NotificarePushUIPluginEventBroker.Event.NotificationWillPresent(
                notification = notification,
            )
        )
    }

    override fun onNotificationPresented(notification: NotificareNotification) {
        NotificarePushUIPluginEventBroker.emit(
            NotificarePushUIPluginEventBroker.Event.NotificationPresented(
                notification = notification,
            )
        )
    }

    override fun onNotificationFinishedPresenting(notification: NotificareNotification) {
        NotificarePushUIPluginEventBroker.emit(
            NotificarePushUIPluginEventBroker.Event.NotificationFinishedPresenting(
                notification = notification,
            )
        )
    }

    override fun onNotificationFailedToPresent(notification: NotificareNotification) {
        NotificarePushUIPluginEventBroker.emit(
            NotificarePushUIPluginEventBroker.Event.NotificationFailedToPresent(
                notification = notification,
            )
        )
    }

    override fun onNotificationUrlClicked(notification: NotificareNotification, uri: Uri) {
        NotificarePushUIPluginEventBroker.emit(
            NotificarePushUIPluginEventBroker.Event.NotificationUrlClicked(
                notification = notification,
                uri = uri,
            )
        )
    }

    override fun onActionWillExecute(notification: NotificareNotification, action: NotificareNotification.Action) {
        NotificarePushUIPluginEventBroker.emit(
            NotificarePushUIPluginEventBroker.Event.ActionWillExecute(
                notification = notification,
                action = action,
            )
        )
    }

    override fun onActionExecuted(notification: NotificareNotification, action: NotificareNotification.Action) {
        NotificarePushUIPluginEventBroker.emit(
            NotificarePushUIPluginEventBroker.Event.ActionExecuted(
                notification = notification,
                action = action,
            )
        )
    }

    override fun onActionFailedToExecute(
        notification: NotificareNotification,
        action: NotificareNotification.Action,
        error: Exception?
    ) {
        NotificarePushUIPluginEventBroker.emit(
            NotificarePushUIPluginEventBroker.Event.ActionFailedToExecute(
                notification = notification,
                action = action,
                error = error,
            )
        )
    }

    override fun onCustomActionReceived(
        notification: NotificareNotification,
        action: NotificareNotification.Action,
        uri: Uri
    ) {
        NotificarePushUIPluginEventBroker.emit(
            NotificarePushUIPluginEventBroker.Event.CustomActionReceived(
                notification = notification,
                action = action,
                uri = uri,
            )
        )
    }

    // endregion
}
