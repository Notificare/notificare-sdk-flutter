package re.notifica.assets.flutter

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import re.notifica.Notificare
import re.notifica.NotificareCallback
import re.notifica.assets.ktx.assets
import re.notifica.assets.models.NotificareAsset

class NotificareAssetsPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "re.notifica.assets.flutter/notificare_assets",
            JSONMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "fetch" -> fetch(call, result)
            else -> result.notImplemented()
        }
    }

    private fun fetch(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: MethodChannel.Result) {
        val group = call.arguments<String>() ?: return onMainThread {
            pluginResult.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)
        }

        Notificare.assets().fetch(group, object : NotificareCallback<List<NotificareAsset>> {
            override fun onSuccess(result: List<NotificareAsset>) {
                onMainThread {
                    pluginResult.success(result.map { it.toJson() })
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    internal companion object {
        internal const val NOTIFICARE_ERROR = "notificare_error"

        internal fun onMainThread(action: () -> Unit) {
            Handler(Looper.getMainLooper()).post { action() }
        }
    }
}
