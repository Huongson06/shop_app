// tab_profile.dart
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shoplite/constants/size_config.dart';
import 'package:shoplite/constants/color_data.dart';
import 'package:shoplite/ui/home/home_screen.dart';
import 'package:shoplite/ui/profile/card_list_screen.dart';
import 'package:shoplite/ui/profile/my_order_screen.dart';
import 'package:shoplite/ui/profile/profile_screen.dart';
import 'package:shoplite/ui/profile/setting_screen.dart';
import 'package:shoplite/ui/profile/shipping_sddress_screen.dart';
import 'package:shoplite/ui/product/product_list_view.dart';
import 'package:shoplite/ui/category/category_list_view.dart';
import 'package:shoplite/ui/Blog/blog_list_view.dart';

import '../../../constants/constant.dart';
import '../../../constants/pref_data.dart';
import '../../../constants/widget_utils.dart';
import '../../intro/splash_screen.dart';

class TabProfile extends StatefulWidget {
  final String email;
  final String fullName;

  const TabProfile({Key? key, required this.email, required this.fullName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabProfile();
  }
}

class _TabProfile extends State<TabProfile> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double appBarPadding = getAppBarPadding();
    double imgHeight = Constant.getPercentSize(screenHeight, 16);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor,
      child: Column(
        children: [
          getDefaultHeader(context, "Profile", () {}, (value) {}, withFilter: false, isShowBack: false, isShowSearch: false),
          getSpace(appBarPadding),
          buildProfileImage(imgHeight),
          getSpace(appBarPadding),
          buildProfileName(screenHeight),
          getSpace(Constant.getPercentSize(appBarPadding, 50)),
          buildProfileEmail(screenHeight),
          getSpace(appBarPadding),
          buildSettingsList(appBarPadding, screenHeight),
          buildLogoutButton(appBarPadding),
        ],
      ),
    );
  }

  Widget buildProfileImage(double imgHeight) {
    return Container(
      width: imgHeight,
      height: imgHeight,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(Constant.assetImagePath + "Profile.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildProfileName(double screenHeight) {
    return getCustomText(widget.fullName, fontBlack, 1, TextAlign.center, FontWeight.bold, Constant.getPercentSize(screenHeight, 2.7));
  }

  Widget buildProfileEmail(double screenHeight) {
    return getCustomText(widget.email, greyFont, 1, TextAlign.center, FontWeight.w400, Constant.getPercentSize(screenHeight, 2.2));
  }

  Widget buildSettingsList(double appBarPadding, double screenHeight) {
    return Expanded(
        child: Container(
          margin: EdgeInsets.all(getAppBarPadding()),
          padding: EdgeInsets.only(left: appBarPadding, right: appBarPadding),
          decoration: ShapeDecoration(
              color: cardColor,
              shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(cornerRadius: Constant.getPercentSize(screenHeight, 2), cornerSmoothing: 0.5)
              ),
              shadows: [
                BoxShadow(color: shadowColor.withOpacity(0.02), blurRadius: 3, spreadRadius: 4)
              ]
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            primary: true,
            shrinkWrap: true,
            children: buildSettingItems(appBarPadding),
          ),
        )
    );
  }

  List<Widget> buildSettingItems(double appBarPadding) {
    List<Map<String, dynamic>> settings = [
      {"icon": "User.svg", "title": "My Profile", "screen": const ProfileScreen()},
      {"icon": "Bag.svg", "title": "My Orders", "screen": const MyOrderScreen()},
      {"icon": "heart.svg", "title": "My Favourites", "screen": HomeScreen(selectedTab: 1)},
      {"icon": "shipping_location.svg", "title": "Shipping Address", "screen": const ShippingAddressScreen()},
      {"icon": "Card.svg", "title": "My Cards", "screen": const CardListScreen()},
      {"icon": "Setting.svg", "title": "Settings", "screen": const SettingScreen()},
      {"icon": "Document.svg", "title": "Danh sách sản phẩm", "screen": ProductListView()},
      {"icon": "Sort.svg", "title": "Danh sách bài viết", "screen": BlogListView()},
      {"icon": "Document.svg", "title": "Danh mục sản phẩm", "screen": CategoryListView()},// Assuming ProductListView exists
    ];
    List<Widget> items = [];
    for (var setting in settings) {
      items.add(getSettingRow(setting["icon"], setting["title"], () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => setting["screen"]));
      }));
      items.add(getSeparatorWidget());
    }
    items.add(getSpace(appBarPadding));
    return items;
  }

  Widget buildLogoutButton(double appBarPadding) {
    return getButton(primaryColor, true, "Logout", Colors.white, () {
      PrefData.setLogIn(false);
      Constant.sendToScreen(const SplashScreen(), context);
    }, FontWeight.w700, EdgeInsets.all(appBarPadding));
  }

  Widget getSeparatorWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getAppBarPadding()),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}
