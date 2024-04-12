package re.notifica.geo.flutter

import android.content.Context
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
import re.notifica.Notificare
import re.notifica.geo.flutter.NotificareGeoPluginBackgroundService.BackgroundEvent.CallbackType
import re.notifica.geo.flutter.NotificareGeoPluginBackgroundService.Companion.isAttachedToActivity
import re.notifica.geo.flutter.storage.NotificareGeoPluginStorage.Companion.updateCallback
import re.notifica.geo.ktx.geo
import re.notifica.geo.models.toJson

class NotificareGeoPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    internal companion object {
        private const val NOTIFICARE_ERROR = "notificare_error"
    }

    private lateinit var channel: MethodChannel
    private var mContext: Context? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        mContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "re.notifica.geo.flutter/notificare_geo",
            JSONMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)

        NotificareGeoPluginEventBroker.register(flutterPluginBinding.binaryMessenger)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        mContext = null
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "hasLocationServicesEnabled" -> hasLocationServicesEnabled(call, result)
            "hasBluetoothEnabled" -> hasBluetoothEnabled(call, result)
            "getMonitoredRegions" -> getMonitoredRegions(call, result)
            "getEnteredRegions" -> getEnteredRegions(call, result)
            "enableLocationUpdates" -> enableLocationUpdates(call, result)
            "disableLocationUpdates" -> disableLocationUpdates(call, result)
            "onLocationUpdatedCallback" -> onBackgroundCallback(call, result, CallbackType.LOCATION_UPDATED)
            "onRegionEnteredCallback" -> onBackgroundCallback(call, result, CallbackType.REGION_ENTERED)
            "onRegionExitedCallback" -> onBackgroundCallback(call, result, CallbackType.REGION_EXITED)
            "onBeaconEnteredCallback" -> onBackgroundCallback(call, result, CallbackType.BEACON_ENTERED)
            "onBeaconExitedCallback" -> onBackgroundCallback(call, result, CallbackType.BEACON_EXITED)
            "onBeaconsRangedCallback" -> onBackgroundCallback(call, result, CallbackType.BEACONS_RANGED)

            // iOS-only events
            "onVisitCallback" -> result.success(null)
            "onHeadingUpdatedCallback" -> result.success(null)
            else -> result.notImplemented()
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        synchronized(isAttachedToActivity) {
            isAttachedToActivity.set(true)
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {
        synchronized(isAttachedToActivity) {
            isAttachedToActivity.set(false)
        }
    }

    private fun hasLocationServicesEnabled(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        response.success(Notificare.geo().hasLocationServicesEnabled)
    }

    private fun hasBluetoothEnabled(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        response.success(Notificare.geo().hasBluetoothEnabled)
    }

    private fun getMonitoredRegions(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        response.success(
            Notificare.geo().monitoredRegions.map { it.toJson() }
        )
    }

    private fun getEnteredRegions(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        response.success(
            Notificare.geo().enteredRegions.map { it.toJson() }
        )
    }

    private fun enableLocationUpdates(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        Notificare.geo().enableLocationUpdates()
        response.success(null)
    }

    private fun disableLocationUpdates(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        Notificare.geo().disableLocationUpdates()
        response.success(null)
    }

    private fun onBackgroundCallback(call: MethodCall, response: Result, callbackType: CallbackType) {
        val arguments = call.arguments<JSONObject>()
            ?: return response.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)

        val callbackDispatcher = arguments.getLong("callbackDispatcher")
        val callback = arguments.getLong("callback")

        val context = mContext
            ?: return response.error(
                NOTIFICARE_ERROR,
                "Unable to register background callback",
                null
            )

        context.updateCallback(
            callbackType = callbackType,
            callbackDispatcher = callbackDispatcher,
            callback = callback
        )

        response.success(null)
    }
}
