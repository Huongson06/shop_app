import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoplite/models/profile.dart'; // Nhớ import lớp Profile

class PrefData {
  static String prefName = "com.example.shopping";

  static String introAvailable = prefName + "isIntroAvailable";
  static String isLoggedIn = prefName + "isLoggedIn";
  static String token = prefName + "token";
  static String profile = prefName + "profile"; // Khóa lưu trữ thông tin profile

  static Future<SharedPreferences> getPrefInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  static Future<bool> isIntroAvailable() async {
    SharedPreferences preferences = await getPrefInstance();
    bool isIntroAvailable = preferences.getBool(introAvailable) ?? true;
    return isIntroAvailable;
  }

  static setIntroAvailable(bool avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setBool(introAvailable, avail);
  }

  static setLogIn(bool avail) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setBool(isLoggedIn, avail);
  }

  static Future<bool> isLogIn() async {
    SharedPreferences preferences = await getPrefInstance();
    bool isIntroAvailable = preferences.getBool(isLoggedIn) ?? false;
    return isIntroAvailable;
  }

  // Lưu token vào SharedPreferences
  static setToken(String mtoken) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(token, mtoken);
  }

  static Future<String> getToken() async {
    SharedPreferences preferences = await getPrefInstance();
    String tokenvalue = preferences.getString(token) ?? '';
    return tokenvalue;
  }

  // Lưu thông tin profile vào SharedPreferences
  static Future<void> setProfile(Profile profile) async {
    SharedPreferences preferences = await getPrefInstance();
    String profileJson = jsonEncode(profile.toJson()); // Chuyển Profile thành JSON
    await preferences.setString(PrefData.profile, profileJson); // Lưu vào SharedPreferences
  }

  // Lấy thông tin profile từ SharedPreferences
  static Future<Profile?> getProfile() async {
    SharedPreferences preferences = await getPrefInstance();
    String? profileJson = preferences.getString(PrefData.profile); // Lấy dữ liệu từ SharedPreferences
    if (profileJson != null) {
      Map<String, dynamic> profileMap = jsonDecode(profileJson); // Chuyển JSON thành Map
      return Profile.fromJson(profileMap); // Trả về đối tượng Profile
    }
    return null; // Trả về null nếu không tìm thấy profile
  }
}
