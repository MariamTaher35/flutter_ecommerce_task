import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product? product; // for real API data
  final String? title;
  final String? price;
  final String? imageUrl;
  final VoidCallback? onAdd;

  const ProductCard({
    super.key,
    this.product,
    this.title,
    this.price,
    this.imageUrl,
    this.onAdd,
  });

  // Mock constructor for Day 1 static view
  factory ProductCard.mock() => const ProductCard(
    title: 'Product Name',
    price: '\$99',
    imageUrl: 'assets/images/banner1.png',
  );

  @override
  Widget build(BuildContext context) {
    final String displayTitle = product?.title ?? title ?? '';
    final String displayPrice =
    product != null ? '\$${product!.price.toStringAsFixed(2)}' : (price ?? '');
    final String displayImage = product?.image ?? imageUrl ?? '';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // Make the image take available flexible space while keeping square aspect
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: displayImage.startsWith('http')
                  ? CachedNetworkImage(
                imageUrl: displayImage,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey.shade200),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              )
                  : Image.asset(displayImage, fit: BoxFit.cover),
            ),
          ),

          // Details area - allow this to flex/shrink if needed
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title: limit lines and allow it to shrink
                Text(
                  displayTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),

                // Price + add button row: keep minimal height
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      displayPrice,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Material(
                        type: MaterialType.transparency,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: onAdd,
                          icon: const Icon(Icons.add_shopping_cart_outlined),
                          tooltip: 'Add to cart',
                          splashRadius: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

