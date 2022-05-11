package re.notifica.push.flutter

import android.content.Intent
import androidx.annotation.NonNull
import androidx.lifecycle.Observer
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import re.notifica.Notificare
import re.notifica.push.ktx.push

class NotificarePushPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.NewIntentListener {

    companion object {
        internal const val NAMESPACE = "re.notifica.push.flutter"
    }

    private lateinit var channel: MethodChannel

    private val allowedUIObserver = Observer<Boolean> { allowedUI ->
        if (allowedUI == null) return@Observer

        NotificarePushPluginEventBroker.emit(
            NotificarePushPluginEventBroker.Event.NotificationSettingsChanged(
                allowedUI = allowedUI,
            )
        )
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Notificare.push().intentReceiver = NotificarePushPluginReceiver::class.java

        channel = MethodChannel(binding.binaryMessenger, "$NAMESPACE/notificare_push", JSONMethodCodec.INSTANCE)
        channel.setMethodCallHandler(this)

        NotificarePushPluginEventBroker.register(binding.binaryMessenger)

        Notificare.push().observableAllowedUI.observeForever(allowedUIObserver)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Notificare.push().observableAllowedUI.removeObserver(allowedUIObserver)

        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "hasRemoteNotificationsEnabled" -> hasRemoteNotificationsEnabled(call, result)
            "allowedUI" -> allowedUI(call, result)
            "enableRemoteNotifications" -> enableRemoteNotifications(call, result)
            "disableRemoteNotifications" -> disableRemoteNotifications(call, result)
            else -> result.notImplemented()
        }
    }

    // region ActivityAware

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addOnNewIntentListener(this)

        val intent = binding.activity.intent
        if (intent != null) onNewIntent(intent)
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}

    // endregion

    // region PluginRegistry.NewIntentListener

    override fun onNewIntent(intent: Intent): Boolean {
        return Notificare.push().handleTrampolineIntent(intent)
    }

    // endregion

    private fun hasRemoteNotificationsEnabled(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        result.success(Notificare.push().hasRemoteNotificationsEnabled)
    }

    private fun allowedUI(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        result.success(Notificare.push().allowedUI)
    }

    private fun enableRemoteNotifications(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        Notificare.push().enableRemoteNotifications()
        result.success(null)
    }

    private fun disableRemoteNotifications(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        Notificare.push().disableRemoteNotifications()
        result.success(null)
    }
}
