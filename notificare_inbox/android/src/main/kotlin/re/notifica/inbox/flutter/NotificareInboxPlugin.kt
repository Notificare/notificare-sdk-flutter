package re.notifica.inbox.flutter

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import androidx.lifecycle.Observer
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import re.notifica.Notificare
import re.notifica.NotificareCallback
import re.notifica.inbox.flutter.events.NotificareEvent
import re.notifica.inbox.flutter.events.NotificareEventManager
import re.notifica.inbox.ktx.inbox
import re.notifica.inbox.models.NotificareInboxItem
import re.notifica.models.NotificareNotification
import java.util.*

class NotificareInboxPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    private val itemsObserver = Observer<SortedSet<NotificareInboxItem>> { items ->
        if (items == null) return@Observer

        NotificareEventManager.send(
            NotificareEvent.InboxUpdated(items)
        )
    }

    private val badgeObserver = Observer<Int> { badge ->
        if (badge == null) return@Observer

        NotificareEventManager.send(
            NotificareEvent.BadgeUpdated(badge)
        )
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        NotificareEventManager.register(binding.binaryMessenger)

        channel = MethodChannel(
            binding.binaryMessenger,
            "re.notifica.inbox.flutter/notificare_inbox",
            JSONMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)

        Notificare.inbox().observableItems.observeForever(itemsObserver)
        Notificare.inbox().observableBadge.observeForever(badgeObserver)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Notificare.inbox().observableItems.removeObserver(itemsObserver)
        Notificare.inbox().observableBadge.removeObserver(badgeObserver)

        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getItems" -> getItems(call, result)
            "getBadge" -> getBadge(call, result)
            "refresh" -> refresh(call, result)
            "open" -> open(call, result)
            "markAsRead" -> markAsRead(call, result)
            "markAllAsRead" -> markAllAsRead(call, result)
            "remove" -> remove(call, result)
            "clear" -> clear(call, result)
            else -> result.notImplemented()
        }
    }

    private fun getItems(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        onMainThread {
            result.success(
                Notificare.inbox().items.map { it.toJson() }
            )
        }
    }

    private fun getBadge(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        onMainThread {
            result.success(Notificare.inbox().badge)
        }
    }

    private fun refresh(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        Notificare.inbox().refresh()
        result.success(null)
    }

    private fun open(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: Result) {
        val arguments = call.arguments<JSONObject>() ?: return onMainThread {
            pluginResult.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)
        }

        val item = NotificareInboxItem.fromJson(arguments)

        Notificare.inbox().open(item, object : NotificareCallback<NotificareNotification> {
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

        val item = NotificareInboxItem.fromJson(arguments)

        Notificare.inbox().markAsRead(item, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                pluginResult.success(null)
            }

            override fun onFailure(e: Exception) {
                pluginResult.error(NOTIFICARE_ERROR, e.localizedMessage, null)
            }
        })
    }

    private fun markAllAsRead(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: Result) {
        Notificare.inbox().markAllAsRead(object : NotificareCallback<Unit> {
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

        val item = NotificareInboxItem.fromJson(arguments)

        Notificare.inbox().remove(item, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                pluginResult.success(null)
            }

            override fun onFailure(e: Exception) {
                pluginResult.error(NOTIFICARE_ERROR, e.localizedMessage, null)
            }
        })
    }

    private fun clear(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: Result) {
        Notificare.inbox().clear(object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                pluginResult.success(null)
            }

            override fun onFailure(e: Exception) {
                pluginResult.error(NOTIFICARE_ERROR, e.localizedMessage, null)
            }
        })
    }

    companion object {
        internal const val NOTIFICARE_ERROR = "notificare_error"

        internal fun onMainThread(action: () -> Unit) {
            Handler(Looper.getMainLooper()).post { action() }
        }
    }
}
