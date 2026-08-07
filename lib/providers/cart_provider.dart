import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/storage_service.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  final StorageService _storageService = StorageService();

  CartNotifier() : super([]) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final cartItems = await _storageService.loadCart();
    state = cartItems;
  }

  Future<void> _saveCart() async {
    await _storageService.saveCart(state);
  }

  void addToCart(Product product) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);
    if (existingIndex != -1) {
      state = [
        ...state.sublist(0, existingIndex),
        state[existingIndex].copyWith(quantity: state[existingIndex].quantity + 1),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, CartItem(product: product)];
    }
    _saveCart();
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
    _saveCart();
  }

  void updateQuantity(int productId, int newQuantity) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (newQuantity <= 0) {
        removeFromCart(productId);
      } else {
        state = [
          ...state.sublist(0, index),
          state[index].copyWith(quantity: newQuantity),
          ...state.sublist(index + 1),
        ];
        _saveCart();
      }
    }
  }

  void clearCart() {
    state = [];
    _saveCart();
  }

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => state.fold(0.0, (sum, item) => sum + item.totalPrice);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalItemsProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});

final cartTotalPriceProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, item) => sum + item.totalPrice);
});