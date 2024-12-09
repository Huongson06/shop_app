import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shoplite/constants/constant.dart';
import 'package:shoplite/constants/size_config.dart';
import 'package:shoplite/ui/profile/edit_profile_screen.dart';
import '../../constants/apilist.dart';
import '../../constants/widget_utils.dart';
import '../../constants/color_data.dart';
import 'package:shoplite/models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  Profile currentProfile = initialProfile;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  // Lấy thông tin người dùng từ API
  Future<void> fetchProfile() async {
    final url = Uri.parse('$base/getprofile');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $g_token', // Lấy token từ Flutter
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          currentProfile = Profile.fromJson(data);
        });
      } else {
        print("Lỗi: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Lỗi kết nối: $e");
    }
  }

  // Phương thức quay lại màn hình trước đó
  _requestPop() {
    Constant.backToFinish(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double appBarPadding = getAppBarPadding();
    double imgHeight = Constant.getPercentSize(screenHeight, 16);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                getDefaultHeader(context, "Profile", () {
                  _requestPop();
                }, (value) {}, isShowSearch: false),
                getSpace(appBarPadding),
                // Container for profile image
                Container(
                  width: imgHeight,
                  height: imgHeight,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: currentProfile.photo.isNotEmpty
                          ? NetworkImage(currentProfile.photo) // Dùng NetworkImage để lấy ảnh từ URL
                          : const AssetImage('assets/images/default_avatar.png') as ImageProvider, // Ảnh mặc định nếu không có ảnh
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: appBarPadding,
                      right: appBarPadding,
                      top: appBarPadding,
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: appBarPadding, vertical: appBarPadding),
                        decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            getRowWidget("Full Name", currentProfile.full_name, "Document.svg"),
                            getSeparateDivider(),
                            getRowWidget("Email", currentProfile.email, "email.svg"),
                            getSeparateDivider(),
                            getRowWidget("Phone Number", currentProfile.phone, "Call_Calling.svg"),
                            getSeparateDivider(),
                            getRowWidget("Address", currentProfile.address, "fav_fill.svg"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                getButton(primaryColor, true, "Edit Profile", Colors.white, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(currentProfile: currentProfile),
                    ),
                  ).then((updatedProfile) {
                    if (updatedProfile != null) {
                      setState(() {
                        currentProfile = updatedProfile;
                      });
                    }
                  });
                }, FontWeight.w700, EdgeInsets.all(appBarPadding)),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          _requestPop();
          return false;
        });
  }

  Widget getSeparateDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getAppBarPadding()),
      child: Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }

  Widget getRowWidget(String title, String desc, String icon) {
    double iconSize = Constant.getHeightPercentSize(3.8);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getSvgImage(icon, iconSize),
        getHorSpace(Constant.getWidthPercentSize(2)),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getCustomText(title, fontBlack, 1, TextAlign.start, FontWeight.w700, Constant.getPercentSize(iconSize, 63)),
            getSpace(Constant.getPercentSize(iconSize, 36)),
            getCustomText(desc, greyFont, 1, TextAlign.start, FontWeight.w400, Constant.getPercentSize(iconSize, 61)),
          ],
        ),
      ],
    );
  }
}
