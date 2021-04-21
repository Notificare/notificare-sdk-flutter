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
import re.notifica.NotificareCallback
import re.notifica.inbox.NotificareInbox
import re.notifica.inbox.flutter.events.NotificareEvent
import re.notifica.inbox.flutter.events.NotificareEventManager
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

        channel = MethodChannel(binding.binaryMessenger, "re.notifica.inbox.flutter/notificare_inbox", JSONMethodCodec.INSTANCE)
        channel.setMethodCallHandler(this)

        NotificareInbox.observableItems.observeForever(itemsObserver)
        NotificareInbox.observableBadge.observeForever(badgeObserver)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        NotificareInbox.observableItems.removeObserver(itemsObserver)
        NotificareInbox.observableBadge.removeObserver(badgeObserver)

        channel.setMethodCallHandler(null)

        NotificareEventManager.unregister()
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
                NotificareInbox.items.map { it.toJson() }
            )
        }
    }

    private fun getBadge(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        onMainThread {
            result.success(NotificareInbox.badge)
        }
    }

    private fun refresh(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        NotificareInbox.refresh()
        result.success(null)
    }

    private fun open(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: Result) {
        val item = NotificareInboxItem.fromJson(call.arguments())

        NotificareInbox.open(item, object : NotificareCallback<NotificareNotification> {
            override fun onSuccess(result: NotificareNotification) {
                pluginResult.success(result)
            }

            override fun onFailure(e: Exception) {
                pluginResult.error(NOTIFICARE_ERROR, e.localizedMessage, null)
            }
        })
    }

    private fun markAsRead(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: Result) {
        val item = NotificareInboxItem.fromJson(call.arguments())

        NotificareInbox.markAsRead(item, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                pluginResult.success(null)
            }

            override fun onFailure(e: Exception) {
                pluginResult.error(NOTIFICARE_ERROR, e.localizedMessage, null)
            }
        })
    }

    private fun markAllAsRead(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: Result) {
        NotificareInbox.markAllAsRead(object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                pluginResult.success(null)
            }

            override fun onFailure(e: Exception) {
                pluginResult.error(NOTIFICARE_ERROR, e.localizedMessage, null)
            }
        })
    }

    private fun remove(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: Result) {
        val item = NotificareInboxItem.fromJson(call.arguments())

        NotificareInbox.remove(item, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                pluginResult.success(null)
            }

            override fun onFailure(e: Exception) {
                pluginResult.error(NOTIFICARE_ERROR, e.localizedMessage, null)
            }
        })
    }

    private fun clear(@Suppress("UNUSED_PARAMETER") call: MethodCall, pluginResult: Result) {
        NotificareInbox.clear(object : NotificareCallback<Unit> {
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

        internal fun onMainThread(action: () -> Unit) = Handler(Looper.getMainLooper()).post { action() }
    }
}
