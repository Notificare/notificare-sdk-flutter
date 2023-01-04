part of 'notificare_live_activity_update.dart';

NotificareLiveActivityUpdate _$NotificareLiveActivityUpdateFromJson(Map json) =>
    NotificareLiveActivityUpdate(
      activity: json["activity"] as String,
      title: json["title"] as String?,
      subtitle: json["subtitle"] as String?,
      message: json["message"] as String?,
      content: Map<String, dynamic>.from(json["content"] as Map),
      isFinal: json["final"] as bool,
      dismissalDate: const NotificareNullableIsoDateTimeConverter().fromJson(json['dismissalDate'] as String?),
      timestamp: const NotificareIsoDateTimeConverter().fromJson(json['timestamp'] as String),
    );

Map<String, dynamic> _$NotificareLiveActivityUpdateToJson(NotificareLiveActivityUpdate instance) =>
    <String, dynamic>{
      "activity": instance.activity,
      "title": instance.title,
      "subtitle": instance.subtitle,
      "message": instance.message,
      "content": instance.content,
      "final": instance.isFinal,
      'dismissalDate': const NotificareNullableIsoDateTimeConverter().toJson(instance.dismissalDate),
      "timestamp": const NotificareIsoDateTimeConverter().toJson(instance.timestamp),
    };
