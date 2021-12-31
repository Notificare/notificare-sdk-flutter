import 'package:flutter/services.dart';
import 'package:notificare_authentication/notificare_authentication.dart';
import 'package:notificare_authentication/src/models/notificare_user.dart';
import 'package:notificare_authentication/src/models/notificare_user_preference.dart';

class NotificareAuthentication {
  // Channels
  static const _channel =
      MethodChannel('re.notifica.authentication.flutter/notificare_authentication', JSONMethodCodec());

  // Events
  static final Map<String, EventChannel> _eventChannels = {};
  static final Map<String, Stream<dynamic>> _eventStreams = {};

  // Methods
  static Future<bool> get isLoggedIn async {
    return await _channel.invokeMethod('isLoggedIn');
  }

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    await _channel.invokeMethod('login', {
      'email': email,
      'password': password,
    });
  }

  static Future<void> logout() async {
    await _channel.invokeMethod('logout');
  }

  static Future<NotificareUser> fetchUserDetails() async {
    final json = await _channel.invokeMapMethod<String, dynamic>('fetchUserDetails');
    return NotificareUser.fromJson(json!);
  }

  static Future<void> changePassword(String password) async {
    await _channel.invokeMethod('changePassword', password);
  }

  static Future<NotificareUser> generatePushEmailAddress() async {
    final json = await _channel.invokeMapMethod<String, dynamic>('generatePushEmailAddress');
    return NotificareUser.fromJson(json!);
  }

  static Future<void> createAccount({
    required String email,
    required String password,
    String? name,
  }) async {
    await _channel.invokeMethod('createAccount', {
      'email': email,
      'password': password,
      'name': name,
    });
  }

  static Future<void> validateUser({required String token}) async {
    await _channel.invokeMethod('validateUser', token);
  }

  static Future<void> sendPasswordReset({required String email}) async {
    await _channel.invokeMethod('sendPasswordReset', email);
  }

  static Future<void> resetPassword(String password, {required String token}) async {
    await _channel.invokeMethod('resetPassword', {
      'password': password,
      'token': token,
    });
  }

  static Future<List<NotificareUserPreference>> fetchUserPreferences() async {
    final json = await _channel.invokeListMethod<Map<String, dynamic>>('fetchUserPreferences');
    return json!.map((e) => NotificareUserPreference.fromJson(e)).toList();
  }

  static Future<List<NotificareUserSegment>> fetchUserSegments() async {
    final json = await _channel.invokeListMethod<Map<String, dynamic>>('fetchUserSegments');
    return json!.map((e) => NotificareUserSegment.fromJson(e)).toList();
  }

  static Future<void> addUserSegment(NotificareUserSegment segment) async {
    await _channel.invokeMethod('addUserSegment', segment);
  }

  static Future<void> removeUserSegment(NotificareUserSegment segment) async {
    await _channel.invokeMethod('removeUserSegment', segment);
  }

  static Future<void> addUserSegmentToPreference({
    required NotificareUserPreference preference,
    NotificareUserSegment? segment,
    NotificareUserPreferenceOption? option,
  }) async {
    await _channel.invokeMethod('addUserSegmentToPreference', {
      'preference': preference,
      'segment': segment,
      'option': option,
    });
  }

  static Future<void> removeUserSegmentFromPreference({
    required NotificareUserPreference preference,
    NotificareUserSegment? segment,
    NotificareUserPreferenceOption? option,
  }) async {
    await _channel.invokeMethod('removeUserSegmentFromPreference', {
      'preference': preference,
      'segment': segment,
      'option': option,
    });
  }

  // Events
  static Stream<dynamic> _getEventStream(String eventType) {
    if (_eventChannels[eventType] == null) {
      final name = 're.notifica.authentication.flutter/events/$eventType';
      _eventChannels[eventType] = EventChannel(name, const JSONMethodCodec());
    }

    if (_eventStreams[eventType] == null) {
      _eventStreams[eventType] = _eventChannels[eventType]!.receiveBroadcastStream();
    }

    return _eventStreams[eventType]!;
  }

  static Stream<String> get onPasswordResetTokenReceived {
    return _getEventStream('password_reset_token_received').map((result) {
      return result;
    });
  }

  static Stream<String> get onValidateUserTokenReceived {
    return _getEventStream('validate_user_token_received').map((result) {
      return result;
    });
  }
}
