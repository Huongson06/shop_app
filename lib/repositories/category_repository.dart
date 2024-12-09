import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shoplite/constants/apilist.dart';
import 'package:shoplite/models/category.dart';

class CategoryRepository {
  final String apiurl = api_ge_category_list; // Đường dẫn API lấy danh mục (thay bằng endpoint thật)

  // Fetch danh sách danh mục từ API
  Future<List<Category>> fetchCategories() async {
    try {
      // Gọi API để lấy danh sách danh mục
      final response = await http.get(
        Uri.parse(apiurl),
        headers: {
          // Thêm headers nếu cần thiết, ví dụ: token
          // "Authorization": "Bearer your_token",
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Kiểm tra mã trạng thái từ API
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Kiểm tra nếu dữ liệu danh mục có tồn tại và là một danh sách
        if (data['data'] != null && data['data']['categories'] is List) {
          List<dynamic> categoryData = data['data']['categories'];
          List<Category> categories = categoryData
              .map((json) => Category.fromJson(json))
              .toList();

          print('Categories: $categories');
          return categories;
        } else {
          throw Exception('Danh mục không có trong dữ liệu hoặc không đúng định dạng.');
        }
      } else {
        // Trả về lỗi nếu không có mã trạng thái 200
        print('Error Response: ${response.body}');
        throw Exception(
            'Không thể tải danh sách danh mục. Mã trạng thái: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Lỗi khi tải danh mục: $e');
    }
  }
}
