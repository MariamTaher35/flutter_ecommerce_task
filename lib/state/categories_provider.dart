import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/category_service.dart';

// Service provider (so it can be mocked/overridden in tests)
final categoryServiceProvider = Provider<CategoryService>((ref) {
  return CategoryService();
});

// Async provider for categories list
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final svc = ref.read(categoryServiceProvider);
  return svc.fetchCategories();
});

// Selected category state (simple StateProvider)
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
