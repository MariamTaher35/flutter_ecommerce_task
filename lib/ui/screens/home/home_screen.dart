
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_task/ui/widgets/banner.dart';
import 'package:flutter_task/ui/widgets/categories_strip.dart';
import 'package:flutter_task/ui/widgets/location_bar.dart';
import '../../../data/models/product.dart';
import '../../../state/products_provider.dart';
import '../../../state/cart_notifier.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 600 ? 3 : 2; // responsive grid

    return Scaffold(
      appBar: AppBar(
        // Constrain logo height so AppBar doesn't grow unexpectedly
        title: SizedBox(
          height: 40,
          child: Image.asset("assets/images/logo_container.png", fit: BoxFit.contain),
        ),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_rounded)),
        ],
      ),
      // Wrap with SafeArea so bottom insets (nav bars) are handled
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                LocationBar(onPressed: () {}),
                const SizedBox(height: 10),

                // --- HORIZONTAL BANNERS ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 300,
                        height: 180,
                        child: SaleBanner(),
                      ),
                      SizedBox(width: 12),
                      SizedBox(
                        width: 300,
                        height: 180,
                        child: SaleBanner(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // --- CATEGORIES HEADER + STRIP (from API) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Categories', style: Theme.of(context).textTheme.titleLarge),
                ),
                const SizedBox(height: 8),
                const CategoriesStrip(),
                const SizedBox(height: 16),

                // Products header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Products', style: Theme.of(context).textTheme.titleLarge),
                ),
                const SizedBox(height: 8),

                // Products grid (Riverpod-driven) - placed inside padding
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ProductsGrid(crossAxisCount: crossAxisCount),
                ),

                const SizedBox(height: 16), // extra bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ProductsGrid: ConsumerWidget that reads filteredProductsProvider and renders results.
/// Integrated with cartNotifierProvider for add-to-cart behavior.
class ProductsGrid extends ConsumerWidget {
  final int crossAxisCount;
  const ProductsGrid({super.key, required this.crossAxisCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(filteredProductsProvider);

    return asyncProducts.when(
      data: (products) {
        if (products.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('No products found.'),
            ),
          );
        }

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.63,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (ctx, idx) {
            final Product p = products[idx];
            return ProductCard(
              product: p,
              onAdd: () {
                // add to cart using Riverpod notifier
                ref.read(cartNotifierProvider.notifier).addToCart(p);

                // show short confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added "${p.title}" to cart'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () {
        // grey placeholders while loading
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.63,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (ctx, idx) => Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(color: Colors.grey.shade200),
          ),
        );
      },
      error: (err, st) {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text('Failed to load products', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 8),
              Text(err.toString(), style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.refresh(filteredProductsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      },
    );
  }
}
