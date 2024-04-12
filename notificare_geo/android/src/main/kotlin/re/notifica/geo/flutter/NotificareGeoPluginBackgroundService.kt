package re.notifica.geo.flutter

import android.content.Context
import android.os.Handler
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.view.FlutterCallbackInformation
import re.notifica.geo.flutter.storage.NotificareGeoPluginStorage.Companion.getCallback
import re.notifica.geo.flutter.storage.NotificareGeoPluginStorage.Companion.getCallbackDispatcher
import re.notifica.geo.models.NotificareBeacon
import re.notifica.geo.models.NotificareLocation
import re.notifica.geo.models.NotificareRegion
import re.notifica.geo.models.toJson
import java.util.LinkedList
import java.util.Queue
import java.util.concurrent.atomic.AtomicBoolean

class NotificareGeoPluginBackgroundService : MethodCallHandler {
    private lateinit var backgroundChannel: MethodChannel
    private lateinit var backgroundHandler: Handler

    private var backgroundFlutterEngine: FlutterEngine? = null
    private val isServiceReady = AtomicBoolean(false)

    internal companion object {
        private const val NOTIFICARE_ERROR = "notificare_error"
        private val queue: Queue<BackgroundEvent> = LinkedList()
        internal val isAttachedToActivity = AtomicBoolean(false)

        @Volatile
        private var instance: NotificareGeoPluginBackgroundService? = null

        internal fun shouldProcessAsBackgroundEvent(): Boolean {
            synchronized(this) {
                if (isAttachedToActivity.get()) return false
            }

            return true
        }

        internal fun processAsBackgroundEvent(context: Context, event: BackgroundEvent) {
            if (event.callback == 0L) return

            synchronized(this) {
                if (instance == null) {
                    val callbackDispatcher = context.getCallbackDispatcher().also {
                        if (it == 0L) return
                    }

                    ensureInstanceInitialized(context, callbackDispatcher)
                }

                enqueueEvent(event)
            }
        }

        private fun ensureInstanceInitialized(context: Context, callbackDispatcher: Long) {
            instance = NotificareGeoPluginBackgroundService().also {
                it.startBackgroundService(context, callbackDispatcher)
            }
        }

        private fun enqueueEvent(event: BackgroundEvent) {
            instance?.also {
                it.handleBackgroundEvent(event)
                return
            }

            queue.add(event)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "onBackgroundServiceInitialized" -> onBackgroundServiceInitialized()
            else -> result.notImplemented()
        }
    }

    private fun startBackgroundService(context: Context, callbackDispatcher: Long) {
        val flutterLoader = FlutterLoader()

        flutterLoader.startInitialization(context)
        flutterLoader.ensureInitializationComplete(context, null)

        if (backgroundFlutterEngine == null) {
            backgroundFlutterEngine = FlutterEngine(context)

            val callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(callbackDispatcher)
            if (callbackInfo == null) {
                Log.e(NOTIFICARE_ERROR, "Failed to get callback information for a given handle.")
                return
            }

            val args = DartExecutor.DartCallback(
                context.assets,
                flutterLoader.findAppBundlePath(),
                callbackInfo
            )

            backgroundFlutterEngine!!.dartExecutor.executeDartCallback(args)
        }

        backgroundChannel = MethodChannel(
            backgroundFlutterEngine!!.dartExecutor.binaryMessenger,
            "re.notifica.geo.flutter/notificare_geo_background",
            JSONMethodCodec.INSTANCE
        )

        backgroundHandler = Handler(context.mainLooper)
        backgroundChannel.setMethodCallHandler(this)
    }

    private fun onBackgroundServiceInitialized() {
        synchronized(isServiceReady) {
            while (!queue.isEmpty()) {
                val event = queue.remove()
                processBackgroundEvent(event)
            }

            isServiceReady.set(true)
        }
    }

    private fun handleBackgroundEvent(event: BackgroundEvent) {
        synchronized(isServiceReady) {
            if (!isServiceReady.get()) {
                queue.add(event)
            } else {
                processBackgroundEvent(event)
            }
        }
    }

    private fun processBackgroundEvent(event: BackgroundEvent) {
        backgroundHandler.post {
            backgroundChannel.invokeMethod(event.method.id, event.payload)
        }
    }

    internal sealed class BackgroundEvent {
        abstract val method: Method
        abstract val callback: Long
        abstract val payload: Map<String, Any>

        internal enum class Method(val id: String) {
            LOCATION_UPDATED(id = "location_updated"),
            REGION_ENTERED(id = "region_entered"),
            REGION_EXITED(id = "region_exited"),
            BEACON_ENTERED(id = "beacon_entered"),
            BEACON_EXITED(id = "beacon_exited"),
            BEACONS_RANGED(id = "beacons_ranged"),
        }

        internal enum class CallbackType(val key: String) {
            LOCATION_UPDATED(key = "location_updated_callback"),
            REGION_ENTERED(key = "region_entered_callback"),
            REGION_EXITED(key = "region_exited_callback"),
            BEACON_ENTERED(key = "beacon_entered_callback"),
            BEACON_EXITED(key = "beacon_exited_callback"),
            BEACONS_RANGED(key = "beacons_ranged_callback"),
        }

        internal class LocationUpdated(
            context: Context,
            location: NotificareLocation
        ) : BackgroundEvent() {
            override val method = Method.LOCATION_UPDATED
            override val callback = context.getCallback(CallbackType.LOCATION_UPDATED)
            override val payload = mapOf(
                "callback" to callback,
                "location" to location.toJson()
            )
        }

        internal class RegionEntered(
            context: Context,
            region: NotificareRegion
        ) : BackgroundEvent() {
            override val method = Method.REGION_ENTERED
            override val callback = context.getCallback(CallbackType.REGION_ENTERED)
            override val payload = mapOf(
                "callback" to callback,
                "region" to region.toJson()
            )
        }

        internal class RegionExited(
            context: Context,
            region: NotificareRegion
        ) : BackgroundEvent() {
            override val method = Method.REGION_EXITED
            override val callback = context.getCallback(CallbackType.REGION_EXITED)
            override val payload = mapOf(
                "callback" to callback,
                "region" to region.toJson()
            )
        }

        internal class BeaconEntered(
            context: Context,
            beacon: NotificareBeacon
        ) : BackgroundEvent() {
            override val method = Method.BEACON_ENTERED
            override val callback = context.getCallback(CallbackType.BEACON_ENTERED)
            override val payload = mapOf(
                "callback" to callback,
                "beacon" to beacon.toJson()
            )
        }

        internal class BeaconExited(
            context: Context,
            beacon: NotificareBeacon
        ) : BackgroundEvent() {
            override val method = Method.BEACON_EXITED
            override val callback = context.getCallback(CallbackType.BEACON_EXITED)
            override val payload = mapOf(
                "callback" to callback,
                "beacon" to beacon.toJson()
            )
        }

        internal class BeaconsRanged(
            context: Context,
            beacons: List<NotificareBeacon>,
            region: NotificareRegion
        ) : BackgroundEvent() {
            override val method = Method.BEACONS_RANGED
            override val callback = context.getCallback(CallbackType.BEACONS_RANGED)
            override val payload = mapOf(
                "callback" to callback,
                "beacons" to beacons.map { it.toJson() },
                "region" to region.toJson()
            )
        }
    }
}
