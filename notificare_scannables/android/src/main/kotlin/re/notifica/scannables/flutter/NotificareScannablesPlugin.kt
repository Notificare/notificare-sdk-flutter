package re.notifica.scannables.flutter

import android.app.Activity
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
import re.notifica.scannables.NotificareScannables
import re.notifica.scannables.ktx.scannables
import re.notifica.scannables.models.NotificareScannable
import re.notifica.scannables.models.toJson

class NotificareScannablesPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    NotificareScannables.ScannableSessionListener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "re.notifica.scannables.flutter/notificare_scannables",
            JSONMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)

        NotificareScannablesPluginEventBroker.register(flutterPluginBinding.binaryMessenger)
        Notificare.scannables().addListener(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)

        Notificare.scannables().removeListener(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "canStartNfcScannableSession" -> canStartNfcScannableSession(call, result)
            "startScannableSession" -> startScannableSession(call, result)
            "startNfcScannableSession" -> startNfcScannableSession(call, result)
            "startQrCodeScannableSession" -> startQrCodeScannableSession(call, result)
            "fetch" -> fetch(call, result)
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

    private fun canStartNfcScannableSession(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        response.success(Notificare.scannables().canStartNfcScannableSession)
    }

    private fun startScannableSession(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        val activity = activity ?: run {
            response.error(
                NOTIFICARE_ERROR,
                "Unable to start a scannable session before an activity is available.",
                null
            )

            return
        }

        Notificare.scannables().startScannableSession(activity)
        response.success(null)
    }

    private fun startNfcScannableSession(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        val activity = activity ?: run {
            response.error(
                NOTIFICARE_ERROR,
                "Unable to start a scannable session before an activity is available.",
                null
            )

            return
        }

        Notificare.scannables().startNfcScannableSession(activity)
        response.success(null)
    }

    private fun startQrCodeScannableSession(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        val activity = activity ?: run {
            response.error(
                NOTIFICARE_ERROR,
                "Unable to start a scannable session before an activity is available.",
                null
            )

            return
        }

        Notificare.scannables().startQrCodeScannableSession(activity)
        response.success(null)
    }

    private fun fetch(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        val tag = call.arguments<String>()

        Notificare.scannables().fetch(tag, object : NotificareCallback<NotificareScannable> {
            override fun onSuccess(result: NotificareScannable) {
                response.success(result.toJson())
            }

            override fun onFailure(e: Exception) {
                response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
            }
        })
    }

    // region NotificareScannables.ScannableSessionListener

    override fun onScannableDetected(scannable: NotificareScannable) {
        NotificareScannablesPluginEventBroker.emit(
            NotificareScannablesPluginEventBroker.Event.ScannableDetected(scannable)
        )
    }

    override fun onScannableSessionError(error: Exception) {
        NotificareScannablesPluginEventBroker.emit(
            NotificareScannablesPluginEventBroker.Event.ScannableSessionFailed(error)
        )
    }

    // endregion

    internal companion object {
        internal const val NOTIFICARE_ERROR = "notificare_error"
    }
}
