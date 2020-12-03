package re.notifica.flutter.handlers

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import re.notifica.Notificare
import re.notifica.flutter.NotificareReceiver

internal class CoreHandler(
    private val context: Context,
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isConfigured" -> getConfigured(result)
            "isReady" -> getReady(result)
            "configure" -> configure(call, result)
            "launch" -> launch(result)
            "unlaunch" -> unlaunch(result)
            else -> result.notImplemented()
        }
    }

    private fun getConfigured(result: MethodChannel.Result) {
        result.success(Notificare.isConfigured)
    }

    private fun getReady(result: MethodChannel.Result) {
        result.success(Notificare.isReady)
    }

    private fun configure(call: MethodCall, result: MethodChannel.Result) {
        val applicationKey = call.argument<String>("applicationKey")
            ?: throw IllegalArgumentException("applicationKey cannot be null")

        val applicationSecret = call.argument<String>("applicationSecret")
            ?: throw IllegalArgumentException("applicationSecret cannot be null")

        Notificare.configure(context, applicationKey, applicationSecret)
        result.success(null)
    }

    private fun launch(result: MethodChannel.Result) {
        Notificare.intentReceiver = NotificareReceiver::class.java

        Notificare.launch()
        result.success(null)
    }

    private fun unlaunch(result: MethodChannel.Result) {
        Notificare.unlaunch()
        result.success(null)
    }
}
