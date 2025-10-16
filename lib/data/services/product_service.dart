import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const _base = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final uri = Uri.parse('$_base/products');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('Failed to load products (${res.statusCode})');
    }
    final data = (jsonDecode(res.body) as List<dynamic>);
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  // optional: fetch by category (if you want server-side filtering)
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final uri = Uri.parse('$_base/products/category/$category');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('Failed to load products by category (${res.statusCode})');
    }
    final data = (jsonDecode(res.body) as List<dynamic>);
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }
}
