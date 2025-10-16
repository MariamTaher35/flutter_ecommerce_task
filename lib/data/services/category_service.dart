import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  static const _base = 'https://fakestoreapi.com';

  Future<List<String>> fetchCategories() async {
    final uri = Uri.parse('$_base/products/categories');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('Failed to load categories (${res.statusCode})');
    }
    final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }
}
