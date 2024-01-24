import 'package:http/http.dart' as http;
import 'dart:convert';

class UnsplashApi {
  static const String apiUrl = 'https://api.unsplash.com';
  static const String apiKey = 'ZYtPHE19jmQ6FQfjunf9QXMeXf9xYro67Ll0YG4L22Q';

  static Future<List<Map<String, dynamic>>> searchImages(String query, String color) async {
    final response = await http.get(
      Uri.parse('$apiUrl/search/photos?query=$query&color=$color&client_id=$apiKey'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['results'];
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}