import 'package:flutter/services.dart';
import 'package:notificare/models/notificare_device.dart';
import 'package:notificare/models/notificare_do_not_disturb.dart';

class NotificareDeviceManager {
  final MethodChannel _channel;

  NotificareDeviceManager(this._channel);

  Future<NotificareDevice> get currentDevice async {
    final json = await _channel.invokeMethod<Map>('getCurrentDevice');
    return json != null ? NotificareDevice.fromJson(json) : null;
  }

  Future<String> get preferredLanguage async {
    return _channel.invokeMethod('getPreferredLanguage');
  }

  Future<void> updatePreferredLanguage(String language) async {
    await _channel.invokeMethod('updatePreferredLanguage', language);
  }

  Future<void> register(String userId, String userName) async {
    await _channel.invokeMethod('register', {'userId': userId, 'userName': userName});
  }

  Future<List<String>> fetchTags() async {
    return _channel.invokeListMethod('fetchTags');
  }

  Future<void> addTag(String tag) async {
    await _channel.invokeMethod('addTag', tag);
  }

  Future<void> addTags(List<String> tags) async {
    await _channel.invokeMethod('addTags', tags);
  }

  Future<void> removeTag(String tag) async {
    await _channel.invokeMethod('removeTag', tag);
  }

  Future<void> removeTags(List<String> tags) async {
    await _channel.invokeMethod('removeTags', tags);
  }

  Future<void> clearTags() async {
    await _channel.invokeMethod('clearTags');
  }

  Future<NotificareDoNotDisturb> fetchDoNotDisturb() async {
    final json = await _channel.invokeMapMethod('fetchDoNotDisturb');
    return json != null ? NotificareDoNotDisturb.fromJson(json.cast<String, dynamic>()) : null;
  }

  Future<void> updateDoNotDisturb(NotificareDoNotDisturb dnd) async {
    await _channel.invokeMethod('updateDoNotDisturb', dnd.toJson());
  }

  Future<void> clearDoNotDisturb() async {
    await _channel.invokeMethod('clearDoNotDisturb');
  }

  Future<Map<String, String>> fetchUserData() async {
    final json = await _channel.invokeMapMethod('fetchUserData');
    return json?.cast<String, String>();
  }

  Future<void> updateUserData(Map<String, String> userData) async {
    await _channel.invokeMethod('updateUserData', userData);
  }
}
