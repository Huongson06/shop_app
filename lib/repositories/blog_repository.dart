import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shoplite/constants/apilist.dart'; // Chỉnh lại theo đúng đường dẫn API của bạn
import 'package:shoplite/models/blog.dart'; // Chỉnh lại theo đúng đường dẫn model Blog

class BlogRepository {
  final String apiUrl = api_ge_blog_list;

  // Fetch danh sách blog từ API
  Future<List<Blog>> fetchBlogs() async {
    try {
      // Gọi API để lấy danh sách bài viết
      final response = await http.get(
        Uri.parse(apiUrl),
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

        // Kiểm tra nếu dữ liệu blog có tồn tại và là một danh sách
        if (data['data'] != null && data['data']['blogs'] is List) {
          List<dynamic> blogData = data['data']['blogs'];
          List<Blog> blogs = blogData
              .map((json) => Blog.fromJson(json))
              .toList();

          print('Blogs: $blogs');
          return blogs;
        } else {
          throw Exception('Bài viết không có trong dữ liệu hoặc không đúng định dạng.');
        }
      } else {
        // Trả về lỗi nếu không có mã trạng thái 200
        print('Error Response: ${response.body}');
        throw Exception('Không thể tải danh sách bài viết. Mã trạng thái: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Lỗi khi tải bài viết: $e');
    }
  }
}
