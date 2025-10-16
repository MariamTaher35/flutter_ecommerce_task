import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/product.dart';
import '../../../state/cart_notifier.dart';


class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartNotifierProvider);
    final notifier = ref.read(cartNotifierProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        // Custom AppBar: Back icon, Title, Heart icon
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, color: Colors.black),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: cart.isEmpty ? const _EmptyCart() : _CartContent(cart: cart, notifier: notifier),

      // Fixed bottom summary + checkout button
      bottomNavigationBar: cart.isEmpty ? const SizedBox.shrink() : _CartSummaryBar(cart: cart, notifier: notifier, primaryColor: primaryColor),
    );
  }
}

class _CartContent extends StatelessWidget {
  final CartState cart;
  final CartNotifier notifier;
  const _CartContent({required this.cart, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Cart Items List
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cartItem = cart.items.values.elementAt(index);
                return _CartItemCard(
                  cartItem: cartItem,
                  onInc: () => notifier.changeQty(cartItem.product.id, cartItem.qty + 1),
                  onDec: () => notifier.changeQty(cartItem.product.id, cartItem.qty - 1),
                  onRemove: () => notifier.removeFromCart(cartItem.product.id),
                );
              },
            ),

            const SizedBox(height: 24),

            // 2. Shipping Information Card
            const _ShippingInfoSection(),

            const SizedBox(height: 24),

            // 3. Itemized Totals Section
            _ItemizedTotalSection(cart: cart),

            const SizedBox(height: 120), // Extra space for bottom bar clearance
          ],
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onInc;
  final VoidCallback onDec;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.cartItem,
    required this.onInc,
    required this.onDec,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final Product p = cartItem.product;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 120,
              height: 140,
              child: Image.network(
                p.image,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: Colors.grey.shade200, child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
                },
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image, color: Colors.grey)),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Text(
                  p.category,
                  style: theme.textTheme.labelSmall!.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),

                // Title
                Text(
                  p.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                // Qty controls
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _QtyButton(icon: Icons.remove, onPressed: cartItem.qty > 1 ? onDec : null),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('${cartItem.qty}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                    _QtyButton(icon: Icons.add, onPressed: onInc),
                  ],
                ),
              ],
            ),
          ),

          // Price and Heart Icon Column (Right side)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onRemove, // Use onRemove for the heart icon logic
                icon: const Icon(Icons.delete, color: Colors.grey, size: 24),
                splashRadius: 20,
              ),
              const SizedBox(height: 10),

              // Item Total Price
              Text(
                '\$${(p.price * cartItem.qty).toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QtyButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onPressed != null ? Colors.grey.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onPressed != null ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}

class _ShippingInfoSection extends StatelessWidget {
  const _ShippingInfoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.credit_card, size: 24, color: Color(0xFFE50019)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '**** **** **** 5124',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade700),
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemizedTotalSection extends StatelessWidget {
  final CartState cart;
  const _ItemizedTotalSection({required this.cart});

  Widget _buildTotalRow(String label, double amount, {bool isGrandTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isGrandTotal ? 20 : 16,
              fontWeight: isGrandTotal ? FontWeight.w800 : FontWeight.w500,
              color: isGrandTotal ? Colors.black : Colors.grey.shade600,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isGrandTotal ? 20 : 16,
              fontWeight: isGrandTotal ? FontWeight.w800 : FontWeight.w600,
              color: isGrandTotal ? Colors.black : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = cart.itemCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTotalRow('Total ($itemCount Items)', cart.subtotal),
        _buildTotalRow('Shipping Fee', cart.shippingFee),
        _buildTotalRow('Taxes', cart.taxes),

        const Divider(height: 24),

        _buildTotalRow('Grand Total', cart.grandTotal, isGrandTotal: true),
      ],
    );
  }
}


class _CartSummaryBar extends StatelessWidget {
  final CartState cart;
  final CartNotifier notifier;
  final Color primaryColor;
  const _CartSummaryBar({required this.cart, required this.notifier, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final grandTotal = cart.grandTotal;
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          // Grand Total info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Total', style: TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(
                  '\$${grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Checkout button
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Checkout'),
                      content: Text('Proceed to pay \$${grandTotal.toStringAsFixed(2)}? (Simulated)'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed (simulated)')));
                            Future.delayed(const Duration(milliseconds: 500), () => notifier.clear());
                          },
                          child: const Text('Confirm'),
                        )
                      ],
                    ),
                  );
                },
                child: const Text('Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 84, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Add products to your cart from the Home screen.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Browse Products'),
            ),
          ],
        ),
      ),
    );
  }
}
