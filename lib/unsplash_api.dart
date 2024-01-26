import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashApi {
  static const String _baseUrl = 'https://api.unsplash.com';
  static const String _apiKey =
      'ZYtPHE19jmQ6FQfjunf9QXMeXf9xYro67Ll0YG4L22Q'; // Replace with your API key

  static Future<List<Map<String, dynamic>>> searchPhotos(String query,
      {int page = 1, int perPage = 10, String orderBy = 'relevant'}) async {
    final Map<String, dynamic> queryParams = {
      'query': query,
      'page': page.toString(),
      'per_page': perPage.toString(),
      'order_by': orderBy,
    };

    final Uri uri = Uri.parse('$_baseUrl/search/photos')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: {
      'Authorization': 'Client-ID $_apiKey',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      return results.map((result) => result as Map<String, dynamic>).toList();
    } else {
      throw Exception('UnsplashAPI: Failed to load photos');
    }
  }
}
