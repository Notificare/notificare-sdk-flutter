import 'package:notificare/notificare.dart';
import 'package:http/http.dart' as http;

import '../utils/enviroment_variables.dart';

void registerDeviceWithUser(String accessToken) {
  _registerDevice(accessToken, 'PUT');
}

void registerDeviceAsAnonymous(String accessToken) {
  _registerDevice(accessToken, 'DELETE');
}

Future<String> getUserInboxResponse(String accessToken) async {
  final env = await parseEnvVariablesToMap(assetsFileName: '.env');

  if (env.isEmpty) {
    throw Exception('.env file is empty.');
  }

  final url = env['FETCH_INBOX_URL'] ??
      (throw Exception('Failed to load fetch inbox URL from .env.'));

  var headers = {'Authorization': 'Bearer $accessToken'};
  var request = http.Request('GET', Uri.parse(url));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (!_isValidResponseStatus(response.statusCode)) {
    throw Exception(response.reasonPhrase);
  }

  return response.stream.bytesToString();
}

Future<void> _registerDevice(String accessToken, String method) async {
  final device = await Notificare.device().currentDevice ??
      (throw Exception(
          'Notificare current device is null, cannot register device without ID.'));

  final env = await parseEnvVariablesToMap(assetsFileName: '.env');

  if (env.isEmpty) {
    throw Exception('.env file is empty.');
  }

  final url = env['REGISTER_DEVICE_URL'] ??
      (throw Exception('Failed to load register device URL from .env.'));

  var headers = {'Authorization': 'Bearer $accessToken'};
  var request = http.Request(method, Uri.parse('$url/${device.id}'));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (!_isValidResponseStatus(response.statusCode)) {
    throw Exception(response.reasonPhrase);
  }
}

bool _isValidResponseStatus(int code) {
  return code >= 200 && code <= 299;
}
