package re.notifica.inbox.flutter.events

import io.flutter.plugin.common.EventChannel

internal class NotificareEventStream(type: NotificareEvent.Type) : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null
    private val pendingEvents = mutableListOf<NotificareEvent>()

    val name = "re.notifica.inbox.flutter/events/${type.id}"

    fun emit(event: NotificareEvent) {
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
