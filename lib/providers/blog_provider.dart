import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/models/blog.dart'; // Chỉnh lại theo đúng đường dẫn model Blog
import 'package:shoplite/repositories/blog_repository.dart'; // Chỉnh lại theo đúng đường dẫn repository Blog

// Khai báo provider để sử dụng BlogRepository
final blogRepositoryProvider = Provider<BlogRepository>((ref) {
  return BlogRepository();
});

// FutureProvider để lấy danh sách bài viết
final blogListProvider = FutureProvider<List<Blog>>((ref) async {
  final repository = ref.watch(blogRepositoryProvider);

  try {
    return await repository.fetchBlogs();
  } catch (e) {
    throw Exception('Lỗi khi tải danh sách bài viết: $e');
  }
});


