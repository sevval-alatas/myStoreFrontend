import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mystore_frontend/storage/token_storage.dart';

class ApiService {
  static const baseUrl = 'http://localhost:5000';

  /* -------------------- HEADERS -------------------- */

  static Future<Map<String, String>> _headers({String? token}) async {
    // Token parametresi verilmemişse storage'dan al
    final authToken = token ?? await TokenStorage.getToken();

    return {
      "Content-Type": "application/json",
      if (authToken != null) "Authorization": "Bearer $authToken",
    };
  }

  /* -------------------- GET -------------------- */

  static Future<dynamic> get(
    String path, {
    Map<String, String>? query,
    String? token,
  }) async {
    final uri = Uri.parse(baseUrl + path).replace(queryParameters: query);
    final headers = await _headers(token: token);

    print('GET Request: $uri');
    print('GET Headers: $headers');

    final response = await http.get(uri, headers: headers);

    print('GET Response Status: ${response.statusCode}');
    print('GET Response Body: ${response.body}');

    return _handleResponse(response);
  }

  /* -------------------- POST -------------------- */

  static Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final headers = await _headers(token: token);

    print('POST Request: $baseUrl$path');
    print('POST Headers: $headers');
    print('POST Body: ${jsonEncode(body)}');

    final response = await http.post(
      Uri.parse(baseUrl + path),
      headers: headers,
      body: jsonEncode(body),
    );

    print('POST Response Status: ${response.statusCode}');
    print('POST Response Body: ${response.body}');

    return _handleResponse(response);
  }

  /* -------------------- PUT -------------------- */

  static Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final headers = await _headers(token: token);

    final response = await http.put(
      Uri.parse(baseUrl + path),
      headers: headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /* -------------------- PATCH -------------------- */

  static Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final headers = await _headers(token: token);

    final response = await http.patch(
      Uri.parse(baseUrl + path),
      headers: headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  /* -------------------- DELETE -------------------- */

  static Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final headers = await _headers(token: token);

    final response = await http.delete(
      Uri.parse(baseUrl + path),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );

    return _handleResponse(response);
  }

  /* -------------------- RESPONSE HANDLER -------------------- */

  static dynamic _handleResponse(http.Response response) {
    print('=== RESPONSE HANDLER ===');
    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.body.isEmpty) {
      print('WARNING: Response body is empty!');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return null;
      } else {
        throw "Server returned ${response.statusCode} with empty body";
      }
    }

    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      print('Decoded: $decoded');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        // 401 Unauthorized durumu için özel mesaj
        if (response.statusCode == 401) {
          throw "Oturum süreniz dolmuş. Lütfen tekrar giriş yapın.";
        }
        throw decoded["message"] ?? decoded.toString();
      }
    } catch (e) {
      print('JSON Decode Error: $e');
      rethrow;
    }
  }
}
