import 'dart:convert';
import 'dart:io'; // Để kiểm tra môi trường
import 'package:flutter/foundation.dart' show kIsWeb; // Để nhận diện Flutter Web
import 'package:shoplite/models/site_setting.dart';
import '../models/profile.dart';
import 'package:http_parser/http_parser.dart'; // Để sử dụng MediaType
import 'package:http/http.dart' as http;

// Tự động xác định base URL
final String base = _getBaseUrl();

String _getBaseUrl() {
    if (kIsWeb) {
        // Nếu chạy trên Flutter Web (Chrome, Edge)
        return 'http://127.0.0.1:8000/api/v1';
    } else if (Platform.isAndroid) {
        // Nếu chạy trên giả lập Android
        return 'http://10.0.2.2:8000/api/v1';
    } else if (Platform.isIOS) {
        // Nếu chạy trên giả lập iOS
        return 'http://127.0.0.1:8000/api/v1';
    } else {
        // Các trường hợp khác
        return 'http://127.0.0.1:8000/api/v1';
    }
}

// Các endpoint API
final String api_register = base + "/register";
final String api_updateprofile = base + "/updateprofile";
final String api_ge_product_list = base + "/getproductlist";
final String api_ge_category_list = base + "/getcategorylist";
final String api_ge_blog_list = base + "/getbloglist";
final String api_login = base + "/login";
final String api_sitesetting = base + "/getsitesetting";

// Biến toàn cục lưu trữ thông tin
var g_sitesetting =
SiteSetting(id: 0, company_name: 'company_name', logo: 'logo');
var app_type = "app";
var g_token = "";

// Hồ sơ người dùng mặc định
Profile initialProfile = Profile(
    full_name: 'md',
    phone: '',
    address: '',
    photo: '',
    username: '',
    email: '');
// Hàm đăng nhập
Future<void> login(String username, String password) async {
    final url = Uri.parse(api_login);
    final body = jsonEncode({
        'username': username,
        'password': password,
    });

    try {
        final response = await http.post(
            url,
            headers: {
                'Content-Type': 'application/json',
            },
            body: body,
        );

        if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            g_token = responseData['token']; // Lưu token
            print("Đăng nhập thành công");
        } else {
            print("Lỗi: ${response.statusCode} - ${response.body}");
        }
    } catch (e) {
        print("Lỗi kết nối: $e");
    }
}

// Hàm cập nhật hồ sơ người dùng (bao gồm cả ảnh và thông tin)
Future<void> updateProfile(Profile profile, {File? imageFile}) async {
    final url = Uri.parse(api_updateprofile);

    // Tạo MultipartRequest để gửi ảnh và thông tin người dùng
    var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
            'Authorization': 'Bearer $g_token', // Sử dụng token toàn cục
        })
    // Thêm các trường thông tin người dùng
        ..fields['full_name'] = profile.full_name
        ..fields['phone'] = profile.phone
        ..fields['address'] = profile.address
        ..fields['email'] = profile.email;

    // Nếu có ảnh, gửi ảnh lên server
    if (imageFile != null) {
        String mimeType = 'image/jpeg'; // Mặc định là jpeg, thay đổi nếu ảnh là png, jpg,...
        if (imageFile.path.endsWith('.png')) {
            mimeType = 'image/png';
        } else if (imageFile.path.endsWith('.jpg') || imageFile.path.endsWith('.jpeg')) {
            mimeType = 'image/jpeg';
        }

        request.files.add(await http.MultipartFile.fromPath(
            'photo', // Tên trường ảnh trên server
            imageFile.path,
            contentType: MediaType.parse(mimeType),
        ));
    }

    try {
        // Gửi request
        final response = await request.send();

        if (response.statusCode == 200) {
            final responseBody = await response.stream.bytesToString();
            final responseData = jsonDecode(responseBody);

            // Kiểm tra nếu có thông tin phản hồi từ server (ví dụ: đường dẫn ảnh mới)
            if (responseData['user'] != null) {
                // Cập nhật hồ sơ thành công, xử lý thông tin trả về nếu cần
                print("Cập nhật hồ sơ thành công");
                // Bạn có thể lưu lại thông tin hồ sơ mới hoặc ảnh đã được cập nhật
                // Ví dụ: g_userProfile = Profile.fromJson(responseData['user']);
            }
        } else {
            print("Lỗi: ${response.statusCode} - ${response.reasonPhrase}");
        }
    } catch (e) {
        print("Lỗi kết nối: $e");
    }
}

