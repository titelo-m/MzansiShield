import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://mzansishield-api.onrender.com/api';
  
  // This gives Render 60 seconds to wake up from sleep before giving up
  static const Duration _timeout = Duration(seconds: 60);

  static Future<Map<String, dynamic>> submitReport({
    required String target,
    required String type,
    required String description,
  }) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/reports'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'target': target,
            'type': type,
            'description': description,
          }),
        )
        .timeout(_timeout);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to submit report: ${response.statusCode}');
  }

  static Future<List<Map<String, dynamic>>> getAllReports() async {
    final response = await http
        .get(Uri.parse('$baseUrl/reports'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load reports: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> verifyReport(int id) async {
    final response = await http
        .post(Uri.parse('$baseUrl/reports/$id/verify'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to verify report: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> markFalseReport(int id) async {
    final response = await http
        .post(Uri.parse('$baseUrl/reports/$id/false'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to mark false: ${response.statusCode}');
  }

  static Future<Map<String, int>> getStats() async {
    final response = await http
        .get(Uri.parse('$baseUrl/reports/stats'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'totalReports': data['totalReports'] ?? 0,
        'verifiedReports': data['verifiedReports'] ?? 0,
      };
    }
    throw Exception('Failed to load stats: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> checkLink(String input) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/check'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'input': input}),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to check link: ${response.statusCode}');
  }

  static Future<List<Map<String, dynamic>>> getRecentChecks() async {
    final response = await http
        .get(Uri.parse('$baseUrl/check/recent'))
        .timeout(_timeout);
        
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load recent checks: ${response.statusCode}');
  }
}