import 'package:flutter/services.dart';
import 'package:notificare_assets/src/models/notificare_asset.dart';

class NotificareAssets {
  NotificareAssets._();

  // Channels
  static const _channel = MethodChannel('re.notifica.assets.flutter/notificare_assets', JSONMethodCodec());

  // Methods
  static Future<List<NotificareAsset>> fetch({required String group}) async {
    final json = await _channel.invokeListMethod<Map<String, dynamic>>('fetch', group);
    return json!.map((e) => NotificareAsset.fromJson(e)).toList();
  }
}
