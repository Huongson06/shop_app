import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shoplite/constants/apilist.dart';
import 'package:shoplite/models/product.dart';

class ProductRepository {
  final String apiurl = api_ge_product_list;

  // Fetch danh sách sản phẩm từ API
  Future<List<Product>> fetchProducts() async {
    try {
      // Gọi API để lấy danh sách sản phẩm
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

        // Kiểm tra nếu dữ liệu sản phẩm có tồn tại và là một danh sách
        if (data['data'] != null && data['data']['products'] is List) {
          List<dynamic> productData = data['data']['products'];
          List<Product> products = productData
              .map((json) => Product.fromJson(json))
              .toList();

          print('Products: $products');
          return products;
        } else {
          throw Exception('Sản phẩm không có trong dữ liệu hoặc không đúng định dạng.');
        }
      } else {
        // Trả về lỗi nếu không có mã trạng thái 200
        print('Error Response: ${response.body}');
        throw Exception('Không thể tải danh sách sản phẩm. Mã trạng thái: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Lỗi khi tải sản phẩm: $e');
    }
  }
}
