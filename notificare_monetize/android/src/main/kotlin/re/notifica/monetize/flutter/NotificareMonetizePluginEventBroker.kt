package re.notifica.monetize.flutter

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import re.notifica.monetize.models.NotificareProduct
import re.notifica.monetize.models.NotificarePurchase

internal object NotificareMonetizePluginEventBroker {

    private val streams: Map<Event.Type, Stream> by lazy {
        Event.Type.values().associateWith { Stream(it) }
    }

    fun register(messenger: BinaryMessenger) {
        streams.values.forEach {
            val channel = EventChannel(messenger, it.name, JSONMethodCodec.INSTANCE)
            channel.setStreamHandler(it)
        }
    }

    fun emit(event: Event) {
        Handler(Looper.getMainLooper()).post {
            streams[event.type]?.emit(event)
        }
    }


    sealed class Event {

        abstract val type: Type
        abstract val payload: Any?

        enum class Type(val id: String) {
            PRODUCTS_UPDATED(id = "products_updated"),
            PURCHASES_UPDATED(id = "purchases_updated"),
            BILLING_SETUP_FINISHED(id = "billing_setup_finished"),
            BILLING_SETUP_FAILED(id = "billing_setup_failed"),
            PURCHASE_FINISHED(id = "purchase_finished"),
            PURCHASE_RESTORED(id = "purchase_restored"),
            PURCHASE_CANCELED(id = "purchase_canceled"),
            PURCHASE_FAILED(id = "purchase_failed"),
        }

        class ProductsUpdated(
            products: List<NotificareProduct>,
        ) : Event() {
            override val type = Type.PRODUCTS_UPDATED
            override val payload = products.map { it.toJson() }
        }

        class PurchasesUpdated(
            purchases: List<NotificarePurchase>,
        ) : Event() {
            override val type = Type.PURCHASES_UPDATED
            override val payload = purchases.map { it.toJson() }
        }

        class BillingSetupFinished : Event() {
            override val type: Type = Type.BILLING_SETUP_FINISHED
            override val payload: Nothing? = null
        }

        class BillingSetupFailed(
            code: Int,
            message: String,
        ) : Event() {
            override val type: Type = Type.BILLING_SETUP_FAILED
            override val payload = mapOf(
                "code" to code,
                "message" to message,
            )
        }

        class PurchaseFinished(
            purchase: NotificarePurchase,
        ) : Event() {
            override val type: Type = Type.PURCHASE_FINISHED
            override val payload = purchase.toJson()
        }

        class PurchaseRestored(
            purchase: NotificarePurchase,
        ) : Event() {
            override val type: Type = Type.PURCHASE_RESTORED
            override val payload = purchase.toJson()
        }

        class PurchaseCanceled : Event() {
            override val type: Type = Type.PURCHASE_CANCELED
            override val payload: Nothing? = null
        }

        class PurchaseFailed(
            code: Int,
            message: String,
        ) : Event() {
            override val type: Type = Type.PURCHASE_FAILED
            override val payload = mapOf(
                "code" to code,
                "message" to message,
            )
        }
    }


    class Stream(type: Event.Type) : EventChannel.StreamHandler {

        private var eventSink: EventChannel.EventSink? = null
        private val pendingEvents = mutableListOf<Event>()

        val name = "re.notifica.monetize.flutter/events/${type.id}"

        fun emit(event: Event) {
            val eventSink = this.eventSink

            if (eventSink == null) {
                pendingEvents.add(event)
            } else {
                eventSink.success(event.payload)
            }
        }

        override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
            this.eventSink = eventSink

            if (eventSink != null) {
                pendingEvents.forEach(::emit)
                pendingEvents.clear()
            }
        }

        override fun onCancel(arguments: Any?) {
            this.eventSink = null
        }
    }
}
