import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/models/product.dart';
import 'package:shoplite/repositories/product_repository.dart';

// Khai báo provider để sử dụng ProductRepository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// FutureProvider để lấy danh sách sản phẩm
final productListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);

  try {
    return await repository.fetchProducts();
  } catch (e) {
    throw Exception('Lỗi khi tải danh sách sản phẩm: $e');
  }
});
