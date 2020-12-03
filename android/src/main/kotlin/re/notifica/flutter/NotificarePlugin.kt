package re.notifica.flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import re.notifica.flutter.events.NotificareEventManager
import re.notifica.flutter.handlers.CoreHandler
import re.notifica.flutter.handlers.CrashReporterHandler
import re.notifica.flutter.handlers.DeviceManagerHandler
import re.notifica.internal.NotificareUtils

class NotificarePlugin : FlutterPlugin {

    // Method channels
    private lateinit var channel: MethodChannel
    private lateinit var deviceManagerChannel: MethodChannel
    private lateinit var crashReporterChannel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "re.notifica.flutter/notificare")
        channel.setMethodCallHandler(CoreHandler(binding.applicationContext))

        deviceManagerChannel = MethodChannel(binding.binaryMessenger, "re.notifica.flutter/notificare/device-manager")
        deviceManagerChannel.setMethodCallHandler(DeviceManagerHandler())

        crashReporterChannel = MethodChannel(binding.binaryMessenger, "re.notifica.flutter/notificare/crash-reporter")
        crashReporterChannel.setMethodCallHandler(CrashReporterHandler())

        // Events
        NotificareEventManager.register(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        deviceManagerChannel.setMethodCallHandler(null)
        crashReporterChannel.setMethodCallHandler(null)

        // Events
        NotificareEventManager.unregister()
    }

    internal companion object {
        const val DEFAULT_ERROR_CODE = "notificare_error"

        val moshi = NotificareUtils.createMoshi()
    }
}
