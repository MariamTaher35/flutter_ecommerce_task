import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/categories_provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesStrip extends ConsumerWidget {
  const CategoriesStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCats = ref.watch(categoriesProvider);

    return SizedBox(
      height: 110, // matches your other category height
      child: asyncCats.when(
        data: (categories) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final selected = ref.watch(selectedCategoryProvider) == cat;
              return _CategoryCard(
                label: _formatLabel(cat),
                selected: selected,
                onTap: () {
                  ref.read(selectedCategoryProvider.notifier).state = cat;
                  // Optionally: trigger filtering of products by category
                },
              );
            },
          );
        },
        loading: () => _buildShimmer(),
        error: (err, st) => _buildError(context, ref, err.toString()),
      ),
    );
  }

  String _formatLabel(String raw) {
    // Example: transform "men's clothing" -> "Men's Clothing"
    return raw.splitMapJoin(RegExp(r'[_\s]+'),
        onMatch: (m) => ' ',
        onNonMatch: (n) => n).splitMapJoin('', onNonMatch: (s) => s); // minimal normalization
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 84,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Failed to load categories',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => ref.refresh(categoriesProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Small icon based on first letter for visual identity; replace with images if you have them
    final iconLetter = label.isNotEmpty ? label[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 92,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // simple circle with letter/icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  iconLetter,
                  style: TextStyle(
                    color: selected ? Theme.of(context).colorScheme.primary : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


