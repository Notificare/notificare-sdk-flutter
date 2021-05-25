package re.notifica.flutter

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import org.json.JSONObject
import re.notifica.Notificare
import re.notifica.NotificareCallback
import re.notifica.flutter.events.NotificareEventManager
import re.notifica.models.NotificareApplication
import re.notifica.models.NotificareDoNotDisturb
import re.notifica.models.NotificareNotification
import re.notifica.models.NotificareUserData

class NotificarePlugin : FlutterPlugin {

    private lateinit var context: Context
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
                "isConfigured" -> getConfigured(result)
                "isReady" -> getReady(result)
                "getUseAdvancedLogging" -> getUseAdvancedLogging(call, result)
                "setUseAdvancedLogging" -> setUseAdvancedLogging(call, result)
                "configure" -> configure(call, result)
                "launch" -> launch(result)
                "unlaunch" -> unlaunch(result)
                "getApplication" -> getApplication(call, result)
                "fetchApplication" -> fetchApplication(call, result)
                "fetchNotification" -> fetchNotification(call, result)

                // Device Manager
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

    // region Notificare

    private fun getConfigured(result: Result) {
        result.success(Notificare.isConfigured)
    }

    private fun getReady(result: Result) {
        result.success(Notificare.isReady)
    }

    private fun getUseAdvancedLogging(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        result.success(Notificare.useAdvancedLogging)
    }

    private fun setUseAdvancedLogging(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        Notificare.useAdvancedLogging = call.arguments()
        result.success(null)
    }

    private fun configure(call: MethodCall, result: Result) {
        val applicationKey = call.argument<String>("applicationKey")
            ?: throw IllegalArgumentException("applicationKey cannot be null")

        val applicationSecret = call.argument<String>("applicationSecret")
            ?: throw IllegalArgumentException("applicationSecret cannot be null")

        Notificare.configure(context, applicationKey, applicationSecret)
        result.success(null)
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

    // region Device Manager

    private fun getCurrentDevice(pluginResult: Result) {
        pluginResult.success(Notificare.deviceManager.currentDevice?.toJson())
    }

    private fun register(call: MethodCall, pluginResult: Result) {
        val userId = call.argument<String?>("userId")
        val userName = call.argument<String?>("userName")

        Notificare.deviceManager.register(userId, userName, object : NotificareCallback<Unit> {
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
        Notificare.deviceManager.fetchTags(object : NotificareCallback<List<String>> {
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

        Notificare.deviceManager.addTag(tag, object : NotificareCallback<Unit> {
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

        Notificare.deviceManager.addTags(tags, object : NotificareCallback<Unit> {
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

        Notificare.deviceManager.removeTag(tag, object : NotificareCallback<Unit> {
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

        Notificare.deviceManager.removeTags(tags, object : NotificareCallback<Unit> {
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
        Notificare.deviceManager.clearTags(object : NotificareCallback<Unit> {
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
        result.success(Notificare.deviceManager.preferredLanguage)
    }

    private fun updatePreferredLanguage(call: MethodCall, pluginResult: Result) {
        val language = call.arguments<String?>()

        Notificare.deviceManager.updatePreferredLanguage(language, object : NotificareCallback<Unit> {
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
        Notificare.deviceManager.fetchDoNotDisturb(object : NotificareCallback<NotificareDoNotDisturb?> {
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

        Notificare.deviceManager.updateDoNotDisturb(dnd, object : NotificareCallback<Unit> {
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
        Notificare.deviceManager.clearDoNotDisturb(object : NotificareCallback<Unit> {
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
        Notificare.deviceManager.fetchUserData(object : NotificareCallback<NotificareUserData> {
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

        Notificare.deviceManager.updateUserData(userData, object : NotificareCallback<Unit> {
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

    internal companion object {
        const val DEFAULT_ERROR_CODE = "notificare_error"

        internal fun onMainThread(action: () -> Unit) = Handler(Looper.getMainLooper()).post { action() }
    }
}
