package re.notifica.flutter.utils

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel

internal fun MethodChannel.Result.onMainThread(): MethodChannel.Result {
    return if (this is ResultOnMainThread) {
        this
    } else {
        ResultOnMainThread(this)
    }
}

internal class ResultOnMainThread(
    private val original: MethodChannel.Result,
) : MethodChannel.Result {

    private val handler: Handler by lazy {
        Handler(Looper.getMainLooper())
    }

    override fun success(result: Any?) {
        handler.post {
            original.success(result)
        }
    }

    override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
        handler.post {
            original.error(errorCode, errorMessage, errorDetails)
        }
    }

    override fun notImplemented() {
        handler.post {
            original.notImplemented()
        }
    }
}
