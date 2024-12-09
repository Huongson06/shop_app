import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/models/category.dart';
import 'package:shoplite/repositories/category_repository.dart';

// Khai báo provider để sử dụng CategoryRepository
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

// FutureProvider để lấy danh sách danh mục
final categoryListProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);

  try {
    return await repository.fetchCategories();
  } catch (e) {
    throw Exception('Lỗi khi tải danh sách danh mục: $e');
  }
});
