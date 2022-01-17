package re.notifica.authentication.flutter

import android.content.Intent
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONObject
import re.notifica.Notificare
import re.notifica.NotificareCallback
import re.notifica.authentication.ktx.authentication
import re.notifica.authentication.models.NotificareUser
import re.notifica.authentication.models.NotificareUserPreference
import re.notifica.authentication.models.NotificareUserSegment

class NotificareAuthenticationPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.NewIntentListener {

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "re.notifica.authentication.flutter/notificare_authentication",
            JSONMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)

        NotificareAuthenticationPluginEventBroker.register(flutterPluginBinding.binaryMessenger)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        NotificareAuthenticationPluginEventBroker.unregister()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isLoggedIn" -> isLoggedIn(call, result)
            "login" -> login(call, result)
            "logout" -> logout(call, result)
            "fetchUserDetails" -> fetchUserDetails(call, result)
            "changePassword" -> changePassword(call, result)
            "generatePushEmailAddress" -> generatePushEmailAddress(call, result)
            "createAccount" -> createAccount(call, result)
            "validateUser" -> validateUser(call, result)
            "sendPasswordReset" -> sendPasswordReset(call, result)
            "resetPassword" -> resetPassword(call, result)
            "fetchUserPreferences" -> fetchUserPreferences(call, result)
            "fetchUserSegments" -> fetchUserSegments(call, result)
            "addUserSegment" -> addUserSegment(call, result)
            "removeUserSegment" -> removeUserSegment(call, result)
            "addUserSegmentToPreference" -> addUserSegmentToPreference(call, result)
            "removeUserSegmentFromPreference" -> removeUserSegmentFromPreference(call, result)
            else -> result.notImplemented()
        }
    }

    // region ActivityAware

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addOnNewIntentListener(this)

        val intent = binding.activity.intent
        if (intent != null) onNewIntent(intent)
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}

    // endregion

    // region PluginRegistry.NewIntentListener

    override fun onNewIntent(intent: Intent): Boolean {
        val passwordResetToken = Notificare.authentication().parsePasswordResetToken(intent)
        if (passwordResetToken != null) {
            NotificareAuthenticationPluginEventBroker.emit(
                NotificareAuthenticationPluginEventBroker.Event.PasswordResetTokenReceived(passwordResetToken)
            )
            return true
        }

        val validateUserToken = Notificare.authentication().parseValidateUserToken(intent)
        if (validateUserToken != null) {
            NotificareAuthenticationPluginEventBroker.emit(
                NotificareAuthenticationPluginEventBroker.Event.ValidateUserTokenReceived(validateUserToken)
            )
            return true
        }

        return false
    }

    // endregion

    private fun isLoggedIn(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        onMainThread {
            response.success(Notificare.authentication().isLoggedIn)
        }
    }

    private fun login(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        val email = requireNotNull(call.argument<String>("email"))
        val password = requireNotNull(call.argument<String>("password"))

        Notificare.authentication().login(email, password, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    response.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun logout(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        Notificare.authentication().logout(object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    response.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun fetchUserDetails(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        Notificare.authentication().fetchUserDetails(object : NotificareCallback<NotificareUser> {
            override fun onSuccess(result: NotificareUser) {
                onMainThread {
                    response.success(result.toJson())
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun changePassword(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        val password = call.arguments<String>()

        Notificare.authentication().changePassword(password, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    response.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun generatePushEmailAddress(
        @Suppress("UNUSED_PARAMETER") call: MethodCall,
        response: MethodChannel.Result
    ) {
        Notificare.authentication().generatePushEmailAddress(object : NotificareCallback<NotificareUser> {
            override fun onSuccess(result: NotificareUser) {
                onMainThread {
                    response.success(result.toJson())
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun createAccount(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        val arguments = call.arguments<JSONObject>()

        val email = requireNotNull(call.argument<String>("email"))
        val password = requireNotNull(call.argument<String>("password"))
        val name = if (!arguments.isNull("name")) arguments.getString("name") else null

        Notificare.authentication().createAccount(email, password, name, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    response.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun validateUser(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        val token = call.arguments<String>()

        Notificare.authentication().validateUser(token, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    response.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun sendPasswordReset(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        val email = call.arguments<String>()

        Notificare.authentication().sendPasswordReset(email, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    response.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun resetPassword(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        val password = requireNotNull(call.argument<String>("password"))
        val token = requireNotNull(call.argument<String>("token"))

        Notificare.authentication().resetPassword(password, token, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    response.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun fetchUserPreferences(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        Notificare.authentication().fetchUserPreferences(object : NotificareCallback<List<NotificareUserPreference>> {
            override fun onSuccess(result: List<NotificareUserPreference>) {
                onMainThread {
                    response.success(result.map { it.toJson() })
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun fetchUserSegments(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        Notificare.authentication().fetchUserSegments(object : NotificareCallback<List<NotificareUserSegment>> {
            override fun onSuccess(result: List<NotificareUserSegment>) {
                onMainThread {
                    response.success(result.map { it.toJson() })
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun addUserSegment(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        val segment = NotificareUserSegment.fromJson(call.arguments())

        Notificare.authentication().addUserSegment(segment, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    response.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun removeUserSegment(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: MethodChannel.Result) {
        val segment = NotificareUserSegment.fromJson(call.arguments())

        Notificare.authentication().removeUserSegment(segment, object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                onMainThread {
                    response.success(null)
                }
            }

            override fun onFailure(e: Exception) {
                onMainThread {
                    response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                }
            }
        })
    }

    private fun addUserSegmentToPreference(
        @Suppress("UNUSED_PARAMETER") call: MethodCall,
        response: MethodChannel.Result
    ) {
        val arguments = call.arguments<JSONObject>()

        val preference = NotificareUserPreference.fromJson(requireNotNull(call.argument("preference")))

        val segment =
            if (!arguments.isNull("segment")) NotificareUserSegment.fromJson(arguments.getJSONObject("segment"))
            else null

        val option =
            if (!arguments.isNull("option")) NotificareUserPreference.Option.fromJson(arguments.getJSONObject("option"))
            else null

        if ((segment == null && option == null) || (segment != null && option != null)) {
            onMainThread {
                response.error(
                    NOTIFICARE_ERROR,
                    "To execute this method, you must provide either a NotificareUserSegment or a NotificarePreferenceOption.",
                    null
                )
            }

            return
        }

        if (segment != null) {
            Notificare.authentication()
                .addUserSegmentToPreference(segment, preference, object : NotificareCallback<Unit> {
                    override fun onSuccess(result: Unit) {
                        onMainThread {
                            response.success(null)
                        }
                    }

                    override fun onFailure(e: Exception) {
                        onMainThread {
                            response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                        }
                    }
                })
        } else if (option != null) {
            Notificare.authentication()
                .addUserSegmentToPreference(option, preference, object : NotificareCallback<Unit> {
                    override fun onSuccess(result: Unit) {
                        onMainThread {
                            response.success(null)
                        }
                    }

                    override fun onFailure(e: Exception) {
                        onMainThread {
                            response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                        }
                    }
                })
        }
    }

    private fun removeUserSegmentFromPreference(
        @Suppress("UNUSED_PARAMETER") call: MethodCall,
        response: MethodChannel.Result
    ) {
        val arguments = call.arguments<JSONObject>()

        val preference = NotificareUserPreference.fromJson(requireNotNull(call.argument("preference")))

        val segment =
            if (!arguments.isNull("segment")) NotificareUserSegment.fromJson(arguments.getJSONObject("segment"))
            else null

        val option =
            if (!arguments.isNull("option")) NotificareUserPreference.Option.fromJson(arguments.getJSONObject("option"))
            else null

        if ((segment == null && option == null) || (segment != null && option != null)) {
            onMainThread {
                response.error(
                    NOTIFICARE_ERROR,
                    "To execute this method, you must provide either a NotificareUserSegment or a NotificarePreferenceOption.",
                    null
                )
            }

            return
        }

        if (segment != null) {
            Notificare.authentication()
                .removeUserSegmentFromPreference(segment, preference, object : NotificareCallback<Unit> {
                    override fun onSuccess(result: Unit) {
                        onMainThread {
                            response.success(null)
                        }
                    }

                    override fun onFailure(e: Exception) {
                        onMainThread {
                            response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                        }
                    }
                })
        } else if (option != null) {
            Notificare.authentication()
                .removeUserSegmentFromPreference(option, preference, object : NotificareCallback<Unit> {
                    override fun onSuccess(result: Unit) {
                        onMainThread {
                            response.success(null)
                        }
                    }

                    override fun onFailure(e: Exception) {
                        onMainThread {
                            response.error(NOTIFICARE_ERROR, e.localizedMessage, null)
                        }
                    }
                })
        }
    }


    internal companion object {
        internal const val NOTIFICARE_ERROR = "notificare_error"

        internal fun onMainThread(action: () -> Unit) = Handler(Looper.getMainLooper()).post { action() }
    }
}
