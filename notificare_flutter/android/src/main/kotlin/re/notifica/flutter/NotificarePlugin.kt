package re.notifica.flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONArray
import org.json.JSONObject
import re.notifica.Notificare
import re.notifica.NotificareCallback
import re.notifica.flutter.events.NotificareEvent
import re.notifica.flutter.events.NotificareEventManager
import re.notifica.ktx.device
import re.notifica.ktx.events
import re.notifica.models.*

class NotificarePlugin : FlutterPlugin, ActivityAware, PluginRegistry.NewIntentListener {

    private lateinit var context: Context
    private lateinit var activity: Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        // Events
        NotificareEventManager.register(binding.binaryMessenger)

        Notificare.intentReceiver = NotificarePluginReceiver::class.java

        channel = MethodChannel(binding.binaryMessenger, "re.notifica.flutter/notificare", JSONMethodCodec.INSTANCE)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                // Notificare
                "isConfigured" -> isConfigured(result)
                "isReady" -> isReady(result)
                "launch" -> launch(result)
                "unlaunch" -> unlaunch(result)
                "getApplication" -> getApplication(call, result)
                "fetchApplication" -> fetchApplication(call, result)
                "fetchNotification" -> fetchNotification(call, result)

                // Device module
                "getCurrentDevice" -> getCurrentDevice(result)
                "register" -> register(call, result)
                "fetchTags" -> fetchTags(result)
                "addTag" -> addTag(call, result)
                "addTags" -> addTags(call, result)
                "removeTag" -> removeTag(call, result)
                "removeTags" -> removeTags(call, result)
                "clearTags" -> clearTags(result)
                "getPreferredLanguage" -> getPreferredLanguage(result)
                "updatePreferredLanguage" -> updatePreferredLanguage(call, result)
                "fetchDoNotDisturb" -> fetchDoNotDisturb(result)
                "updateDoNotDisturb" -> updateDoNotDisturb(call, result)
                "clearDoNotDisturb" -> clearDoNotDisturb(result)
                "fetchUserData" -> fetchUserData(result)
                "updateUserData" -> updateUserData(call, result)

                // Events module
                "logCustom" -> logCustom(call, result)

                // Unhandled
                else -> result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)

        // Events
        NotificareEventManager.unregister()
    }

    // region ActivityAware

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        // Keep a reference to the current activity.
        activity = binding.activity

        // Listen to incoming intents.
        binding.addOnNewIntentListener(this)

        // Handle the initial intent, if any.
        val intent = binding.activity.intent
        if (intent != null) onNewIntent(intent)
    }

    override fun onDetachedFromActivity() {}

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    // endregion

    // region PluginRegistry.NewIntentListener

    override fun onNewIntent(intent: Intent): Boolean {
        // Try handling the test device intent.
        if (Notificare.handleTestDeviceIntent(intent)) return true

        // Try handling the dynamic link intent.
        if (Notificare.handleDynamicLinkIntent(activity, intent)) return true

        val url = intent.data?.toString()
        if (url != null) {
            NotificareEventManager.send(
                NotificareEvent.UrlOpened(url)
            )
        }

        return false
    }

    // endregion

    // region Notificare

    private fun isConfigured(result: Result) {
        result.success(Notificare.isConfigured)
    }

    private fun isReady(result: Result) {
        result.success(Notificare.isReady)
    }

    private fun launch(result: Result) {
        Notificare.launch()
        result.success(null)
    }

    private fun unlaunch(result: Result) {
        Notificare.unlaunch()
        result.success(null)
    }

    private fun getApplication(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        response.success(Notificare.application?.toJson())
    }

    private fun fetchApplication(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        Notificare.fetchApplication(object : NotificareCallback<NotificareApplication> {
            override fun onSuccess(result: NotificareApplication) {
                onMainThread {
                    response.success(result.toJson())
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun fetchNotification(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        val id = call.arguments<String>()

        Notificare.fetchNotification(id, object : NotificareCallback<NotificareNotification> {
            override fun onSuccess(result: NotificareNotification) {
                onMainThread {
                    response.success(result.toJson())
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    // endregion

    // region Notificare Device Manager

    private fun getCurrentDevice(pluginResult: Result) {
        pluginResult.success(Notificare.device().currentDevice?.toJson())
    }

    private fun register(call: MethodCall, pluginResult: Result) {
        val arguments = call.arguments<JSONObject>()

        val userId = if (!arguments.isNull("userId")) arguments.getString("userId") else null
        val userName = if (!arguments.isNull("userName")) arguments.getString("userName") else null

        Notificare.device().register(userId, userName, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    pluginResult.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun fetchTags(pluginResult: Result) {
        Notificare.device().fetchTags(object : NotificareCallback<List<String>> {
            override fun onSuccess(result: List<String>) {
                onMainThread {
                    pluginResult.success(result)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun addTag(call: MethodCall, pluginResult: Result) {
        val tag = call.arguments<String>()

        Notificare.device().addTag(tag, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    pluginResult.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun addTags(call: MethodCall, pluginResult: Result) {
        val json = call.arguments<JSONArray>()

        val tags = mutableListOf<String>()
        for (i in 0 until json.length()) {
            tags.add(json.getString(i))
        }

        Notificare.device().addTags(tags, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    pluginResult.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun removeTag(call: MethodCall, pluginResult: Result) {
        val tag = call.arguments<String>()

        Notificare.device().removeTag(tag, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    pluginResult.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun removeTags(call: MethodCall, pluginResult: Result) {
        val json = call.arguments<JSONArray>()

        val tags = mutableListOf<String>()
        for (i in 0 until json.length()) {
            tags.add(json.getString(i))
        }

        Notificare.device().removeTags(tags, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    pluginResult.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun clearTags(pluginResult: Result) {
        Notificare.device().clearTags(object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    pluginResult.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun getPreferredLanguage(result: Result) {
        result.success(Notificare.device().preferredLanguage)
    }

    private fun updatePreferredLanguage(call: MethodCall, pluginResult: Result) {
        val language = call.arguments<String?>()

        Notificare.device().updatePreferredLanguage(language, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    pluginResult.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun fetchDoNotDisturb(pluginResult: Result) {
        Notificare.device().fetchDoNotDisturb(object : NotificareCallback<NotificareDoNotDisturb?> {
            override fun onSuccess(result: NotificareDoNotDisturb?) {
                onMainThread {
                    pluginResult.success(result?.toJson())
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun updateDoNotDisturb(call: MethodCall, pluginResult: Result) {
        val dnd = NotificareDoNotDisturb.fromJson(call.arguments())

        Notificare.device().updateDoNotDisturb(dnd, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    pluginResult.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun clearDoNotDisturb(pluginResult: Result) {
        Notificare.device().clearDoNotDisturb(object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    pluginResult.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun fetchUserData(pluginResult: Result) {
        Notificare.device().fetchUserData(object : NotificareCallback<NotificareUserData> {
            override fun onSuccess(result: NotificareUserData) {
                onMainThread {
                    pluginResult.success(result)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    private fun updateUserData(call: MethodCall, pluginResult: Result) {
        val json = call.arguments<JSONObject>()
        val userData = mutableMapOf<String, String>()

        val iterator = json.keys()
        while (iterator.hasNext()) {
            val key = iterator.next()
            if (!json.isNull(key)) {
                userData[key] = json.getString(key)
            }
        }

        Notificare.device().updateUserData(userData, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    pluginResult.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    pluginResult.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    // endregion

    // region Notificare Events Manager

    private fun logCustom(call: MethodCall, response: Result) {
        val event: String
        val data: NotificareEventData?

        try {
            event = requireNotNull(call.argument<String>("event"))
            data = call.argument<JSONObject>("data")?.let { re.notifica.models.NotificareEvent.createData(it) }
        } catch (e: Exception) {
            onMainThread {
                response.error(DEFAULT_ERROR_CODE, e.message, null)
            }

            return
        }

        Notificare.events().logCustom(event, data, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    response.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(DEFAULT_ERROR_CODE, e.message, null)
                }
            }
        })
    }

    // endregion

    internal companion object {
        const val DEFAULT_ERROR_CODE = "notificare_error"

        internal fun onMainThread(action: () -> Unit) = Handler(Looper.getMainLooper()).post { action() }
    }
}
