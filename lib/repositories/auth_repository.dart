import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shoplite/constants/apilist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoplite/constants/pref_data.dart';
import 'package:shoplite/models/profile.dart';

class AuthRepository {
  final String apiUrl = api_login; // URL của API đăng nhập
  final String apiRegisterUrl = api_register; // URL của API đăng ký
  final String apiUpdateProfileUrl = api_updateprofile; // URL của API cập nhật profile

  // Phương thức đăng nhập
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        g_token = data['token']['token'];
        PrefData.setToken(g_token);

        initialProfile = Profile(
          phone: data['user']['phone'],
          full_name: data['user']['full_name'],
          address: data['user']['address'],
          photo: data['user']['photo'],
          email: data['user']['email'],
          username: data['user']['username'],
        );
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  // Phương thức đăng ký
  Future<bool> register(String email, String password, String full_Name,
      String phone, String address) async {
    try {
      final body = jsonEncode({
        'email': email,
        'password': password,
        'full_name': full_Name,
        'phone': phone,
        'address': address,
      });

      final response = await http.post(
        Uri.parse(apiRegisterUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // In ra phản hồi để kiểm tra

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Kiểm tra success từ phản hồi
        if (data['success'] == true) {
          print('Đăng ký thành công!');
          return true; // Đăng ký thành công
        } else {
          print('Lỗi trong quá trình đăng ký: ${data['message']}');
          return false; // Đăng ký không thành công, xử lý thông báo lỗi từ API
        }
      } else {
        print('Đăng ký thất bại: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Lỗi khi đăng ký: $error');
      return false; // Lỗi trong quá trình gọi API hoặc xử lý
    }
  }

  // Phương thức cập nhật thông tin profile
  Future<bool> updateProfile(Profile profile) async {
    try {
      final response = await http.put(
        Uri.parse(apiUpdateProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $g_token', // Gửi token trong header
        },
        body: jsonEncode(profile.toJson()), // Sử dụng phương thức toJson để gửi dữ liệu
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          PrefData.setProfile(profile); // Cập nhật thông tin mới vào SharedPreferences
          return true;
        } else {
          print('Lỗi trong quá trình cập nhật profile: ${data['message']}');
          return false;
        }
      } else {
        print('Cập nhật thất bại: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Lỗi khi cập nhật profile: $error');
      return false;
    }
  }
}
