package re.notifica.loyalty.flutter

import android.app.Activity
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import re.notifica.Notificare
import re.notifica.NotificareCallback
import re.notifica.loyalty.ktx.loyalty
import re.notifica.loyalty.models.NotificarePass

class NotificareLoyaltyPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "re.notifica.loyalty.flutter/notificare_loyalty",
            JSONMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "fetchPassBySerial" -> fetchPassBySerial(call, result)
            "fetchPassByBarcode" -> fetchPassByBarcode(call, result)
            "present" -> present(call, result)
            else -> result.notImplemented()
        }
    }

    // region ActivityAware

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivityForConfigChanges() {}

    // endregion

    private fun fetchPassBySerial(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        val serial = call.arguments<String>()

        Notificare.loyalty().fetchPassBySerial(serial, object : NotificareCallback<NotificarePass> {
            override fun onSuccess(result: NotificarePass) {
                onMainThread {
                    response.success(result.toJson())
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun fetchPassByBarcode(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        val barcode = call.arguments<String>()

        Notificare.loyalty().fetchPassByBarcode(barcode, object : NotificareCallback<NotificarePass> {
            override fun onSuccess(result: NotificarePass) {
                onMainThread {
                    response.success(result.toJson())
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun present(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        val pass = NotificarePass.fromJson(call.arguments())
        val activity = activity ?: run {
            response.error(NOTIFICARE_ERROR, "Cannot present a pass without an activity attached.", null)
            return
        }

        Notificare.loyalty().present(activity, pass)
        response.success(null)
    }

    internal companion object {
        internal const val NOTIFICARE_ERROR = "notificare_error"

        internal fun onMainThread(action: () -> Unit) = Handler(Looper.getMainLooper()).post { action() }
    }
}
