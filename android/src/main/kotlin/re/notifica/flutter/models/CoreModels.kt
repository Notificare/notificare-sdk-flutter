package re.notifica.flutter.models

import re.notifica.flutter.NotificarePlugin
import re.notifica.models.NotificareDevice
import re.notifica.models.NotificareDoNotDisturb
import re.notifica.models.NotificareTime
import re.notifica.models.NotificareTransport
import java.util.*

internal typealias FlutterMap = Map<String, Any?>

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
