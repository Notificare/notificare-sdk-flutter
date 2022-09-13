package re.notifica.monetize.flutter

import android.app.Activity
import androidx.annotation.NonNull
import androidx.lifecycle.Observer

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
import re.notifica.NotificareCallback
import re.notifica.monetize.NotificareMonetize
import re.notifica.monetize.ktx.monetize
import re.notifica.monetize.models.NotificareProduct
import re.notifica.monetize.models.NotificarePurchase

public class NotificareMonetizePlugin : FlutterPlugin, MethodCallHandler, ActivityAware, NotificareMonetize.Listener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    private val productsObserver = Observer<List<NotificareProduct>> { products ->
        if (products == null) return@Observer

        NotificareMonetizePluginEventBroker.emit(
            NotificareMonetizePluginEventBroker.Event.ProductsUpdated(products)
        )
    }

    private val purchasesObserver = Observer<List<NotificarePurchase>> { purchases ->
        if (purchases == null) return@Observer

        NotificareMonetizePluginEventBroker.emit(
            NotificareMonetizePluginEventBroker.Event.PurchasesUpdated(purchases)
        )
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "re.notifica.monetize.flutter/notificare_monetize",
            JSONMethodCodec.INSTANCE
        )
        channel.setMethodCallHandler(this)

        NotificareMonetizePluginEventBroker.register(flutterPluginBinding.binaryMessenger)
        Notificare.monetize().addListener(this)

        Notificare.monetize().observableProducts.observeForever(productsObserver)
        Notificare.monetize().observablePurchases.observeForever(purchasesObserver)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Notificare.monetize().observableProducts.removeObserver(productsObserver)
        Notificare.monetize().observablePurchases.removeObserver(purchasesObserver)

        Notificare.monetize().removeListener(this)

        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getProducts" -> getProducts(call, result)
            "getPurchases" -> getPurchases(call, result)
            "refresh" -> refresh(call, result)
            "startPurchaseFlow" -> startPurchaseFlow(call, result)
            else -> result.notImplemented()
        }
    }

    // region ActivityAware

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivityForConfigChanges() {}

    // endregion

    private fun getProducts(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        try {
            val products = Notificare.monetize().products.map { it.toJson() }
            response.success(products)
        } catch (e: Exception) {
            response.error(NOTIFICARE_ERROR, e.message, null)
        }
    }

    private fun getPurchases(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        try {
            val purchases = Notificare.monetize().purchases.map { it.toJson() }
            response.success(purchases)
        } catch (e: Exception) {
            response.error(NOTIFICARE_ERROR, e.message, null)
        }
    }

    private fun refresh(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        Notificare.monetize().refresh(object : NotificareCallback<Unit> {
            override fun onSuccess(result: Unit) {
                response.success(null)
            }

            override fun onFailure(e: Exception) {
                response.error(NOTIFICARE_ERROR, e.message, null)
            }
        })
    }

    private fun startPurchaseFlow(@Suppress("UNUSED_PARAMETER") call: MethodCall, response: Result) {
        val arguments = call.arguments<JSONObject>()
            ?: return response.error(NOTIFICARE_ERROR, "Invalid request arguments.", null)

        val product: NotificareProduct = try {
            NotificareProduct.fromJson(arguments)
        } catch (e: Exception) {
            return response.error(NOTIFICARE_ERROR, e.message, null)
        }

        val activity = activity
            ?: return response.error(
                NOTIFICARE_ERROR,
                "Unable to start a purchase before an activity is available.",
                null
            )

        Notificare.monetize().startPurchaseFlow(activity, product)
    }

    // region NotificareMonetize.Listener

    override fun onBillingSetupFinished() {
        NotificareMonetizePluginEventBroker.emit(
            NotificareMonetizePluginEventBroker.Event.BillingSetupFinished()
        )
    }

    override fun onBillingSetupFailed(code: Int, message: String) {
        NotificareMonetizePluginEventBroker.emit(
            NotificareMonetizePluginEventBroker.Event.BillingSetupFailed(code, message)
        )
    }

    override fun onPurchaseFinished(purchase: NotificarePurchase) {
        NotificareMonetizePluginEventBroker.emit(
            NotificareMonetizePluginEventBroker.Event.PurchaseFinished(purchase)
        )
    }

    override fun onPurchaseRestored(purchase: NotificarePurchase) {
        NotificareMonetizePluginEventBroker.emit(
            NotificareMonetizePluginEventBroker.Event.PurchaseRestored(purchase)
        )
    }

    override fun onPurchaseCanceled() {
        NotificareMonetizePluginEventBroker.emit(
            NotificareMonetizePluginEventBroker.Event.PurchaseCanceled()
        )
    }

    override fun onPurchaseFailed(code: Int, message: String) {
        NotificareMonetizePluginEventBroker.emit(
            NotificareMonetizePluginEventBroker.Event.PurchaseFailed(code, message)
        )
    }

    // endregion

    internal companion object {
        internal const val NOTIFICARE_ERROR = "notificare_error"
    }
}
