package re.notifica.flutter.models

import re.notifica.flutter.NotificarePlugin
import re.notifica.models.*
import java.util.*

internal typealias FlutterMap = Map<String, Any?>

internal fun NotificareApplication.toFlutterMap(): FlutterMap = mapOf(
    "id" to id,
    "name" to name,
    "category" to category,
    "services" to services,
    "inboxConfig" to inboxConfig?.toFlutterMap(),
    "regionConfig" to regionConfig?.toFlutterMap(),
    "userDataFields" to userDataFields.map { it.toFlutterMap() },
    "actionCategories" to actionCategories.map { it.toFlutterMap() },
)

internal fun NotificareApplication.InboxConfig.toFlutterMap(): FlutterMap = mapOf(
    "useInbox" to useInbox,
    "autoBadge" to autoBadge,
)

internal fun NotificareApplication.RegionConfig.toFlutterMap(): FlutterMap = mapOf(
    "proximityUUID" to proximityUUID,
)

internal fun NotificareApplication.UserDataField.toFlutterMap(): FlutterMap = mapOf(
    "type" to type,
    "key" to key,
    "label" to label,
)

internal fun NotificareApplication.ActionCategory.toFlutterMap(): FlutterMap = mapOf(
    "type" to type,
    "name" to name,
    // TODO add remaining properties
)

internal fun NotificareDevice.toFlutterMap(): FlutterMap = mapOf(
    "id" to id,
    "userId" to userId,
    "userName" to userName,
    "timeZoneOffset" to timeZoneOffset,
    "osVersion" to osVersion,
    "sdkVersion" to sdkVersion,
    "appVersion" to appVersion,
    "deviceString" to deviceString,
    "language" to language,
    "region" to region,
    "transport" to NotificarePlugin.moshi.adapter(NotificareTransport::class.java).toJsonValue(transport),
    "dnd" to dnd?.toFlutterMap(),
    "userData" to userData,
    "lastRegistered" to NotificarePlugin.moshi.adapter(Date::class.java).toJsonValue(lastRegistered),
)

internal fun NotificareDoNotDisturb.toFlutterMap(): FlutterMap = mapOf(
    "start" to start.format(),
    "end" to end.format(),
)

internal fun NotificareDoNotDisturb(json: FlutterMap): NotificareDoNotDisturb {
    return NotificareDoNotDisturb(
        start = NotificareTime(json["start"] as String),
        end = NotificareTime(json["end"] as String),
    )
}
