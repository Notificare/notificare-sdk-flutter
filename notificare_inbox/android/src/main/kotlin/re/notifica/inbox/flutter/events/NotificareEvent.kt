package re.notifica.inbox.flutter.events

import re.notifica.inbox.models.NotificareInboxItem
import re.notifica.inbox.models.toJson
import java.util.*

internal sealed class NotificareEvent {

    abstract val type: Type
    abstract val payload: Any?

    enum class Type(val id: String) {
        INBOX_UPDATED(id = "inbox_updated"),
        BADGE_UPDATED(id = "badge_updated"),
    }

    class InboxUpdated(
        items: SortedSet<NotificareInboxItem>
    ) : NotificareEvent() {
        override val type = Type.INBOX_UPDATED
        override val payload = items.map { it.toJson() }
    }

    class BadgeUpdated(
        badge: Int
    ) : NotificareEvent() {
        override val type = Type.BADGE_UPDATED
        override val payload = badge
    }
}
