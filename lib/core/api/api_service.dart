import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  static Future<Map<String, dynamic>> submitReport({
    required String target,
    required String type,
    required String description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reports'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'target': target,
        'type': type,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to submit report: ${response.statusCode}');
  }

  static Future<List<Map<String, dynamic>>> getAllReports() async {
    final response = await http.get(Uri.parse('$baseUrl/reports'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to load reports: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> verifyReport(int id) async {
    final response = await http.post(Uri.parse('$baseUrl/reports/$id/verify'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to verify report: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> markFalseReport(int id) async {
    final response = await http.post(Uri.parse('$baseUrl/reports/$id/false'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to mark false: ${response.statusCode}');
  }

  static Future<Map<String, int>> getStats() async {
    final response = await http.get(Uri.parse('$baseUrl/reports/stats'));

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
    final response = await http.post(
      Uri.parse('$baseUrl/check'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'input': input}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to check link: ${response.statusCode}');
  }
}