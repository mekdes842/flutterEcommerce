import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getProducts();
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getCategories();
});

final productsByCategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, category) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getProductsByCategory(category);
});

final productDetailsProvider =
    FutureProvider.family<Product, int>((ref, productId) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getProduct(productId);
});

final searchQueryProvider = StateProvider<String>((ref) => '');