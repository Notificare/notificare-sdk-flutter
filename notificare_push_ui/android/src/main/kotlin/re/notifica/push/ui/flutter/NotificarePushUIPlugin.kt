package re.notifica.push.ui.flutter

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
import org.json.JSONObject
import re.notifica.NotificareLogger
import re.notifica.models.NotificareNotification
import re.notifica.push.ui.NotificarePushUI

class NotificarePushUIPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private var activity: Activity? = null

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "re.notifica.push.ui.flutter/notificare_push_ui", JSONMethodCodec.INSTANCE)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "presentNotification" -> presentNotification(call, result)
            "presentAction" -> presentAction(call, result)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
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

        val notification = NotificareNotification.fromJson(call.arguments())

        NotificarePushUI.presentNotification(activity, notification)
    }

    private fun presentAction(call: MethodCall, result: Result) {
        val activity = activity ?: run {
            NotificareLogger.warning("Flutter attached activity was null. Cannot continue.")
            result.error(NOTIFICARE_ERROR, "Method called before an activity was attached.", null)
            return
        }

        val json: JSONObject = call.arguments()
        val notification = NotificareNotification.fromJson(json.getJSONObject("notification"))
        val action = NotificareNotification.Action.fromJson(json.getJSONObject("action"))

        NotificarePushUI.presentAction(activity, notification, action)
    }

    companion object {
        private const val NOTIFICARE_ERROR = "notificare_error"
    }
}
