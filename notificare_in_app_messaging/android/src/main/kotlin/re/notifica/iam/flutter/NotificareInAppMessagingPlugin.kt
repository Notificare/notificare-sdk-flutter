package re.notifica.iam.flutter

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import re.notifica.Notificare
import re.notifica.iam.NotificareInAppMessaging
import re.notifica.iam.ktx.inAppMessaging
import re.notifica.iam.models.NotificareInAppMessage

class NotificareInAppMessagingPlugin : FlutterPlugin, MethodChannel.MethodCallHandler,
    NotificareInAppMessaging.MessageLifecycleListener {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            binding.binaryMessenger,
            "re.notifica.iam.flutter/notificare_in_app_messaging",
            JSONMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)

        NotificareInAppMessagingPluginEventBroker.register(binding.binaryMessenger)
        Notificare.inAppMessaging().addLifecycleListener(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Notificare.inAppMessaging().removeLifecycleListener(this)

        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "hasMessagesSuppressed" -> hasMessagesSuppressed(call, result)
            "setMessagesSuppressed" -> setMessagesSuppressed(call, result)
            else -> result.notImplemented()
        }
    }

    private fun hasMessagesSuppressed(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: MethodChannel.Result) {
        result.success(Notificare.inAppMessaging().hasMessagesSuppressed)
    }

    private fun setMessagesSuppressed(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments<JSONObject>()
            ?: return result.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)

        val suppressed = arguments.getBoolean("suppressed")
        val evaluateContext =
            if (!arguments.isNull("evaluateContext")) {
                arguments.getBoolean("evaluateContext")
            } else {
                false
            }

        Notificare.inAppMessaging().setMessagesSuppressed(suppressed, evaluateContext)

        result.success(null)
    }

    // region NotificareInAppMessaging.MessageLifecycleListener

    override fun onMessagePresented(message: NotificareInAppMessage) {
        NotificareInAppMessagingPluginEventBroker.emit(
            NotificareInAppMessagingPluginEventBroker.Event.MessagePresented(message)
        )
    }

    override fun onMessageFinishedPresenting(message: NotificareInAppMessage) {
        NotificareInAppMessagingPluginEventBroker.emit(
            NotificareInAppMessagingPluginEventBroker.Event.MessageFinishedPresenting(message)
        )
    }

    override fun onMessageFailedToPresent(message: NotificareInAppMessage) {
        NotificareInAppMessagingPluginEventBroker.emit(
            NotificareInAppMessagingPluginEventBroker.Event.MessageFailedToPresent(message)
        )
    }

    override fun onActionExecuted(message: NotificareInAppMessage, action: NotificareInAppMessage.Action) {
        NotificareInAppMessagingPluginEventBroker.emit(
            NotificareInAppMessagingPluginEventBroker.Event.ActionExecuted(message, action)
        )
    }

    override fun onActionFailedToExecute(
        message: NotificareInAppMessage,
        action: NotificareInAppMessage.Action,
        error: Exception?
    ) {
        NotificareInAppMessagingPluginEventBroker.emit(
            NotificareInAppMessagingPluginEventBroker.Event.ActionFailedToExecute(message, action, error)
        )
    }

    // endregion

    companion object {
        internal const val NOTIFICARE_ERROR = "notificare_error"
    }
}
