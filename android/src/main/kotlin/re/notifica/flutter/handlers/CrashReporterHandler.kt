package re.notifica.flutter.handlers

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import re.notifica.Notificare
import re.notifica.flutter.utils.onMainThread

class CrashReporterHandler : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
//            "getEnabled" -> getEnabled(result)
//            "setEnabled" -> setEnabled(call, result)
            else -> result.notImplemented()
        }
    }

//    private fun getEnabled(methodResult: MethodChannel.Result) {
//        methodResult.onMainThread().success(Notificare.crashReporter.enabled)
//    }
//
//    private fun setEnabled(call: MethodCall, methodResult: MethodChannel.Result) {
//        val enabled = call.arguments<Boolean>()
//
//        Notificare.crashReporter.enabled = enabled
//        methodResult.onMainThread().success(null)
//    }
}
