// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_user_inbox_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareUserInboxResponse _$NotificareUserInboxResponseFromJson(Map json) => NotificareUserInboxResponse(
      count: json['count'] as int,
      unread: json['count'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => NotificareUserInboxItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$NotificareUserInboxResponseToJson(NotificareUserInboxResponse instance) => <String, dynamic>{
      'count': instance.count,
      'unread': instance.unread,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
