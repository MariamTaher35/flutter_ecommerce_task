import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/product.dart';

// --- MOCK DATA (Updated to use full Product constructor) ---
 /*Product mockProduct1 = Product(
  id: 1,
  title: "Puff Sleeved Blouse for Summer Wear",
  category: "Women's Collection",
  price: 16.99,
  description: "Lightweight and airy blouse perfect for warm weather.",
  image: "https://placehold.co/300x400/0D47A1/FFFFFF?text=Product+A",
  rating: {'rate': 4.5, 'count': 100},
);

 Product mockProduct2 = Product(
  id: 2,
  title: "Comfortable Printed T-Shirt",
  category: "Men's Casual Wear",
  price: 11.99,
  description: "Soft cotton t-shirt with a stylish graphic print.",
  image: "https://placehold.co/300x400/004D40/FFFFFF?text=Product+B",
  rating: {'rate': 4.2, 'count': 50},
);*/
// --- END MOCK DATA ---

/// Cart item model
class CartItem {
  final Product product;
  final int qty;
  CartItem({required this.product, required this.qty});
  CartItem copyWith({int? qty}) => CartItem(product: product, qty: qty ?? this.qty);
}

/// Cart state: map productId -> CartItem
class CartState {
  final Map<int, CartItem> items;
  const CartState({required this.items});

  double get subtotal {
    double sum = 0;
    for (final it in items.values) {
      sum += it.product.price * it.qty;
    }
    return sum;
  }

  // Mock fixed fee values for display
  double get shippingFee => 5.00;
  double get taxes => subtotal * 0.05; // 5% tax
  double get grandTotal => subtotal + shippingFee + taxes;

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.values.fold(0, (sum, item) => sum + item.qty);
}

class CartNotifier extends StateNotifier<CartState> {
  // Initialize with some mock data to show the populated UI
  CartNotifier() : super(CartState(items: {

  }));

  void addToCart(Product p, {int qty = 1}) {
    final m = Map<int, CartItem>.from(state.items);
    if (m.containsKey(p.id)) {
      final existing = m[p.id]!;
      m[p.id] = existing.copyWith(qty: existing.qty + qty);
    } else {
      m[p.id] = CartItem(product: p, qty: qty);
    }
    state = CartState(items: m);
  }

  void removeFromCart(int productId) {
    final m = Map<int, CartItem>.from(state.items);
    m.remove(productId);
    state = CartState(items: m);
  }

  void changeQty(int productId, int newQty) {
    final m = Map<int, CartItem>.from(state.items);
    if (!m.containsKey(productId)) return;
    if (newQty <= 0) {
      m.remove(productId);
    } else {
      m[productId] = m[productId]!.copyWith(qty: newQty);
    }
    state = CartState(items: m);
  }

  void clear() => state = const CartState(items: {});
}

/// Riverpod provider
final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>(
      (ref) => CartNotifier(),
);