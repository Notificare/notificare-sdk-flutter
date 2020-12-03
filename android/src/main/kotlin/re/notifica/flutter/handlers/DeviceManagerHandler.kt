package re.notifica.flutter.handlers

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import re.notifica.Notificare
import re.notifica.NotificareCallback
import re.notifica.callbacks.*
import re.notifica.flutter.NotificarePlugin
import re.notifica.flutter.models.NotificareDoNotDisturb
import re.notifica.flutter.models.toFlutterMap
import re.notifica.flutter.utils.onMainThread
import re.notifica.models.NotificareDoNotDisturb
import re.notifica.models.NotificareUserData

class DeviceManagerHandler : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
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
            else -> result.notImplemented()
        }
    }

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
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun fetchTags(methodResult: MethodChannel.Result) {
        Notificare.deviceManager.fetchTags(object : NotificareCallback<List<String>> {
            override fun onSuccess(result: List<String>) {
                methodResult.onMainThread().success(result)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
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
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
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
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
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
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
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
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun clearTags(methodResult: MethodChannel.Result) {
        Notificare.deviceManager.clearTags(object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
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
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun fetchDoNotDisturb(methodResult: MethodChannel.Result) {
        Notificare.deviceManager.fetchDoNotDisturb(object : NotificareCallback<NotificareDoNotDisturb?> {
            override fun onSuccess(result: NotificareDoNotDisturb?) {
                methodResult.onMainThread().success(result?.toFlutterMap())
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
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
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun clearDoNotDisturb(methodResult: MethodChannel.Result) {
        Notificare.deviceManager.clearDoNotDisturb(object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                methodResult.onMainThread().success(null)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }

    private fun fetchUserData(methodResult: MethodChannel.Result) {
        Notificare.deviceManager.fetchUserData(object : NotificareCallback<NotificareUserData?> {
            override fun onSuccess(result: NotificareUserData?) {
                methodResult.onMainThread().success(result)
            }

            override fun onFailure(e: Exception) {
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
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
                methodResult.onMainThread().error(NotificarePlugin.DEFAULT_ERROR_CODE, e.message, null)
            }
        })
    }
}
