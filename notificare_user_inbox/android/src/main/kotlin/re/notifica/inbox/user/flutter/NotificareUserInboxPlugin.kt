package re.notifica.inbox.user.flutter

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import re.notifica.Notificare
import re.notifica.NotificareCallback
import re.notifica.inbox.user.ktx.userInbox
import re.notifica.inbox.user.models.NotificareUserInboxItem
import re.notifica.models.NotificareNotification

class NotificareUserInboxPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            binding.binaryMessenger,
            "re.notifica.inbox.user.flutter/notificare_user_inbox",
            JSONMethodCodec.INSTANCE
        )

        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "parseResponseFromJSON" -> parseResponseFromJSON(call, result)
            "parseResponseFromString" -> parseResponseFromString(call, result)
            "open" -> open(call, result)
            "markAsRead" -> markAsRead(call, result)
            "remove" -> remove(call, result)
            else -> result.notImplemented()
        }
    }

    private fun parseResponseFromJSON(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        val json = call.arguments<JSONObject>() ?: return onMainThread {
            response.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)
        }

        val result = Notificare.userInbox().parseResponse(json)

        onMainThread {
            response.success(result.toJson())
        }
    }

    private fun parseResponseFromString(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        val json = call.arguments<String>() ?: return onMainThread {
            response.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)
        }

        val result = Notificare.userInbox().parseResponse(json)

        onMainThread {
            response.success(result.toJson())
        }
    }

    private fun open(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: Result) {
        val arguments = call.arguments<JSONObject>() ?: return onMainThread {
            pluginResult.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)
        }

        val item = NotificareUserInboxItem.fromJson(arguments)

        Notificare.userInbox().open(item, object : NotificareCallback<NotificareNotification> {
            override fun onSuccess(result: NotificareNotification) {
                onMainThread {
                    pluginResult.success(result.toJson())
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun markAsRead(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: Result) {
        val arguments = call.arguments<JSONObject>() ?: return onMainThread {
            pluginResult.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)
        }

        val item = NotificareUserInboxItem.fromJson(arguments)

        Notificare.userInbox().markAsRead(item, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                pluginResult.success(null)
            }

            override fun onFailure(e: Exception) {
                pluginResult.error(NOTIFICARE_ERROR, e.localizedMessage, null)
            }
        })
    }

    private fun remove(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: Result) {
        val arguments = call.arguments<JSONObject>() ?: return onMainThread {
            pluginResult.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)
        }

        val item = NotificareUserInboxItem.fromJson(arguments)

        Notificare.userInbox().remove(item, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                pluginResult.success(null)
            }

            override fun onFailure(e: Exception) {
                pluginResult.error(NOTIFICARE_ERROR, e.localizedMessage, null)
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
