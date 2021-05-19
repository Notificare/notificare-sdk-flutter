package re.notifica.push.flutter

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import re.notifica.push.NotificarePush

class NotificarePushPlugin : FlutterPlugin, MethodCallHandler {

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
            "getRemoteNotificationsEnabled" -> getRemoteNotificationsEnabled(call, result)
            "enableRemoteNotifications" -> enableRemoteNotifications(call, result)
            "disableRemoteNotifications" -> disableRemoteNotifications(call, result)
            else -> result.notImplemented()
        }
    }

    private fun getRemoteNotificationsEnabled(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        result.success(NotificarePush.isRemoteNotificationsEnabled)
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
