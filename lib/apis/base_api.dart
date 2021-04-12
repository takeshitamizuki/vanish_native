import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:vanish_native/utils/http_status_manage_util.dart';
import 'package:vanish_native/utils/shared_preferences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseApi {
  http.Client _client = new http.Client();

  Future<Response> get(String uri) async {
    String _cookieContext = await _getCookieContext();
    Map<String, String> headers = {'cookie': _cookieContext};

    var response = await _client.get(uri, headers: headers);

    _saveHttpStatusCode(response);

    return response;
  }

  Future<Response> post(String uri, [String body]) async {
    String _cookieContext = await _getCookieContext();
    String _csrcToken = await _getCsrfToken();

    Map<String, String> headers = {
      'cookie': _cookieContext,
      'x-csrf-token': _csrcToken,
      'Content-Type': 'application/json',
    };

    var response = await _client.post(uri, headers: headers, body: body);

    _saveHttpStatusCode(response);

    return response;
  }

  Future<Response> put(String uri, [String body]) async {
    String _cookieContext = await _getCookieContext();
    String _csrcToken = await _getCsrfToken();

    Map<String, String> headers = {
      'cookie': _cookieContext,
      'x-csrf-token': _csrcToken,
      'Content-Type': 'application/json',
    };

    var response = await _client.put(uri, headers: headers, body: body);

    _saveHttpStatusCode(response);

    return response;
  }

  Future<Response> patch(String uri, [String body]) async {
    String _cookieContext = await _getCookieContext();
    String _csrcToken = await _getCsrfToken();
    Map<String, String> headers = {
      'cookie': _cookieContext,
      'x-csrf-token': _csrcToken,
      'Content-Type': 'application/json',
    };

    var response = await _client.patch(uri, headers: headers, body: body);

    _saveHttpStatusCode(response);

    return response;
  }

  Future<Response> delete(String uri) async {
    String _cookieContext = await _getCookieContext();
    String _csrcToken = await _getCsrfToken();

    Map<String, String> headers = {
      'cookie': _cookieContext,
      'x-csrf-token': _csrcToken,
      'Content-Type': 'application/json',
    };

    var response = await _client.delete(uri, headers: headers);

    _saveHttpStatusCode(response);

    return response;
  }

  _saveHttpStatusCode(http.Response response) async {
    await HttpStatusManage.setHttpStatusCode(response.statusCode);
  }

  _getCookieContext() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return 'SESSION=${prefs.getString(SharedPreferencesKey.session)}; x-vanish-ctkn=${prefs.getString(SharedPreferencesKey.csrfToken)}';
  }

  _getCsrfToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferencesKey.csrfToken);
  }
}