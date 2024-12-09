import 'package:flutter/material.dart';
import 'package:shoplite/constants/apilist.dart';
import 'package:shoplite/constants/color_data.dart';
import 'package:shoplite/constants/widget_utils.dart';
import 'package:shoplite/models/profile.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // Sử dụng image_picker cho cả web và mobile
import 'package:flutter/foundation.dart'; // Thư viện hỗ trợ kiểm tra nền tảng
import 'package:http/http.dart' as http;


class EditProfileScreen extends StatefulWidget {
  final Profile currentProfile;

  const EditProfileScreen({Key? key, required this.currentProfile})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditProfileScreen();
  }
}

class _EditProfileScreen extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late Profile _profile;
  late ImagePicker _picker; // Đảm bảo sử dụng ImagePicker cho phù hợp với nền tảng
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _profile = widget.currentProfile;
    _picker = ImagePicker(); // Chỉ cần sử dụng ImagePicker cho cả web và mobile
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Nếu có ảnh được chọn từ thư viện
      if (_imageFile != null) {
        _profile.photo = _imageFile!.path; // Đặt URL của ảnh hoặc đường dẫn của ảnh
      }

      try {
        final response = await http.post(
          Uri.parse(api_updateprofile),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $g_token',
          },
          body: jsonEncode(_profile.toJson()),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.pop(context, _profile); // Trả dữ liệu về ProfileScreen
        } else {
          throw Exception('Failed to update profile');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
        _profile.photo = _imageFile!.path; // Lưu ảnh vào profile
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double appBarPadding = getAppBarPadding();

    return Scaffold(
      backgroundColor: backgroundColor, // Sử dụng màu nền của ProfileScreen
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: primaryColor, // Đồng nhất màu với nút
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(appBarPadding),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: appBarPadding, vertical: appBarPadding),
          decoration: BoxDecoration(
            color: cardColor, // Màu giống thẻ trong ProfileScreen
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trường ảnh đại diện
                GestureDetector(
                  onTap: _pickImage, // Nhấn vào để chọn ảnh từ thư viện
                  child: _imageFile == null
                      ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_profile.photo.isNotEmpty ? _profile.photo : 'default_image_url'), // Nếu không có ảnh mới, sử dụng URL mặc định
                  )
                      : CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(File(_imageFile!.path)), // Sử dụng FileImage cho ảnh cục bộ
                  ),
                ),

                const SizedBox(height: 20),
                // Trường tên đầy đủ
                TextFormField(
                  initialValue: _profile.full_name,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: greyFont),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSaved: (value) => _profile.full_name = value!,
                ),
                const SizedBox(height: 20),
                // Trường email
                TextFormField(
                  initialValue: _profile.email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: greyFont),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSaved: (value) => _profile.email = value!,
                ),
                const SizedBox(height: 20),
                // Trường phone
                TextFormField(
                  initialValue: _profile.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    labelStyle: TextStyle(color: greyFont),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSaved: (value) => _profile.phone = value!,
                ),
                const SizedBox(height: 20),
                // Trường địa chỉ
                TextFormField(
                  initialValue: _profile.address,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: greyFont),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSaved: (value) => _profile.address = value!,
                ),
                const Spacer(),
                // Nút lưu
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // Thay vì 'primary'
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
