import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String apiUrl = 'https://apps.fortnox.se/oauth-v1/token';
  static const String clientId = '7YFbHiTM1Avu';
  static const String clientSecret = '5fmmL6adDb';
  static const String redirectUri = 'easyscan://callback';

  Future<void> fetchTokens(String code) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: {
        'code': code,
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      await storeTokens(
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
        expiresIn:
            data['expires_in'], // assuming the response includes expires_in
      );
    } else {
      throw Exception('Failed to fetch tokens');
    }
  }

  Future<String> refreshAccessToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      await storeTokens(
        accessToken: data['access_token'],
        refreshToken: refreshToken,
        expiresIn: data['expires_in'],
      );
      return data['access_token'];
    } else {
      throw Exception('Failed to refresh access token');
    }
  }

  Future<void> storeTokens(
      {required String accessToken,
      required String refreshToken,
      required int expiresIn}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
    await prefs.setInt('accessTokenExpiry',
        DateTime.now().millisecondsSinceEpoch + expiresIn * 1000);
  }

  Future<String?> getStoredToken(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> removeToken(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<bool> isAccessTokenValid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? expiryTime = prefs.getInt('accessTokenExpiry');
    if (expiryTime == null) {
      return false;
    }
    return DateTime.now().millisecondsSinceEpoch < expiryTime;
  }

  Future<void> clearTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('accessTokenExpiry');
  }
}
