package re.notifica.flutter

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import re.notifica.Notificare
import re.notifica.NotificareCallback
import re.notifica.callbacks.*
import re.notifica.flutter.events.NotificareEventManager
import re.notifica.flutter.models.NotificareDoNotDisturb
import re.notifica.flutter.models.toFlutterMap
import re.notifica.flutter.utils.onMainThread
import re.notifica.internal.NotificareUtils
import re.notifica.models.NotificareDoNotDisturb
import re.notifica.models.NotificareUserData

class NotificarePlugin : FlutterPlugin {

    private lateinit var context: Context
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        // Events
        NotificareEventManager.register(binding.binaryMessenger)

        channel = MethodChannel(binding.binaryMessenger, "re.notifica.flutter/notificare")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                // Notificare
                "isConfigured" -> getConfigured(result)
                "isReady" -> getReady(result)
                "configure" -> configure(call, result)
                "launch" -> launch(result)
                "unlaunch" -> unlaunch(result)

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

    // endregion

    // region Device Manager

    private fun getCurrentDevice(result: MethodChannel.Result) {
        result.success(Notificare.deviceManager.currentDevice?.toFlutterMap())
    }

    private fun register(call: MethodCall, methodResult: MethodChannel.Result) {
        val userId = call.argument<String?>("userId")
        val userName = call.argument<String?>("userName")

        Notificare.deviceManager.register(userId, userName, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun fetchTags(methodResult: MethodChannel.Result) {
        Notificare.deviceManager.fetchTags(object : NotificareCallback<List<String>> {
            override fun onSuccess(result: List<String>) {
                methodResult.onMainThread().success(result)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun addTag(call: MethodCall, methodResult: MethodChannel.Result) {
        val tag = call.arguments<String>()

        Notificare.deviceManager.addTag(tag, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun addTags(call: MethodCall, methodResult: MethodChannel.Result) {
        val tags = call.arguments<List<String>>()

        Notificare.deviceManager.addTags(tags, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun removeTag(call: MethodCall, methodResult: MethodChannel.Result) {
        val tag = call.arguments<String>()

        Notificare.deviceManager.removeTag(tag, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun removeTags(call: MethodCall, methodResult: MethodChannel.Result) {
        val tags = call.arguments<List<String>>()

        Notificare.deviceManager.removeTags(tags, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun clearTags(methodResult: MethodChannel.Result) {
        Notificare.deviceManager.clearTags(object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun getPreferredLanguage(result: MethodChannel.Result) {
        result.success(Notificare.deviceManager.preferredLanguage)
    }

    private fun updatePreferredLanguage(call: MethodCall, methodResult: MethodChannel.Result) {
        val language = call.arguments<String?>()

        Notificare.deviceManager.updatePreferredLanguage(language, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun fetchDoNotDisturb(methodResult: MethodChannel.Result) {
        Notificare.deviceManager.fetchDoNotDisturb(object : NotificareCallback<NotificareDoNotDisturb?> {
            override fun onSuccess(result: NotificareDoNotDisturb?) {
                methodResult.onMainThread().success(result?.toFlutterMap())
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun updateDoNotDisturb(call: MethodCall, methodResult: MethodChannel.Result) {
        val dnd = NotificareDoNotDisturb(call.arguments())

        Notificare.deviceManager.updateDoNotDisturb(dnd, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun clearDoNotDisturb(methodResult: MethodChannel.Result) {
        Notificare.deviceManager.clearDoNotDisturb(object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun fetchUserData(methodResult: MethodChannel.Result) {
        Notificare.deviceManager.fetchUserData(object : NotificareCallback<NotificareUserData?> {
            override fun onSuccess(result: NotificareUserData?) {
                methodResult.onMainThread().success(result)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun updateUserData(call: MethodCall, methodResult: MethodChannel.Result) {
        val userData = call.arguments<Map<String, String>>()

        Notificare.deviceManager.updateUserData(userData, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    // endregion

    internal companion object {
        const val DEFAULT_ERROR_CODE = "notificare_error"

        val moshi = NotificareUtils.createMoshi()
    }
}
