import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/product_service.dart';
import '../data/models/product.dart';
import 'categories_provider.dart';

final productServiceProvider = Provider<ProductService>((ref) => ProductService());


final productsProvider = FutureProvider<List<Product>>((ref) async {
  final svc = ref.read(productServiceProvider);
  return svc.fetchProducts();
});

final filteredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final selected = ref.watch(selectedCategoryProvider);
  final svc = ref.read(productServiceProvider);

  // If no category selected -> return all products
  if (selected == null) {
    return svc.fetchProducts();
  }

  // fakestoreapi expects category path; server-side filter is available
  try {
    return svc.fetchProductsByCategory(selected);
  } catch (_) {
    // fallback to fetching all and filtering locally if server-side fails
    final all = await svc.fetchProducts();
    return all.where((p) => p.category == selected).toList();
  }
});
