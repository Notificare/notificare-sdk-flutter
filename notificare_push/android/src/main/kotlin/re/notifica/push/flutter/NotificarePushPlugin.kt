package re.notifica.push.flutter

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import re.notifica.push.NotificarePush

class NotificarePushPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.NewIntentListener {

    companion object {
        internal const val NAMESPACE = "re.notifica.push.flutter"
    }

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        NotificarePush.intentReceiver = NotificarePushPluginReceiver::class.java

        channel = MethodChannel(binding.binaryMessenger, "$NAMESPACE/notificare_push", JSONMethodCodec.INSTANCE)
        channel.setMethodCallHandler(this)

        NotificarePushPluginEventBroker.register(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        NotificarePushPluginEventBroker.unregister()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "isRemoteNotificationsEnabled" -> isRemoteNotificationsEnabled(call, result)
            "getAllowedUI" -> getAllowedUI(call, result)
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
        return NotificarePush.handleTrampolineIntent(intent)
    }

    // endregion

    private fun isRemoteNotificationsEnabled(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        result.success(NotificarePush.isRemoteNotificationsEnabled)
    }

    private fun getAllowedUI(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        result.success(NotificarePush.allowedUI)
    }

    private fun enableRemoteNotifications(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        NotificarePush.enableRemoteNotifications()
        result.success(null)
    }

    private fun disableRemoteNotifications(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        NotificarePush.disableRemoteNotifications()
        result.success(null)
    }
}
