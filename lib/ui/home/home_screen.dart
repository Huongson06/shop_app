import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/constants/constant.dart';
import 'package:shoplite/constants/size_config.dart';
import 'package:shoplite/constants/color_data.dart';
import 'package:shoplite/ui/home/tabscreen/tab_cart.dart';
import 'package:shoplite/ui/home/tabscreen/tab_favourite.dart';
import 'package:shoplite/ui/home/tabscreen/tab_home.dart';
import 'package:shoplite/ui/home/tabscreen/tab_profile.dart';
import 'package:shoplite/models/profile.dart';
import 'package:shoplite/providers/profile_provider.dart';
import 'package:shoplite/providers/product_provider.dart'; // Thêm import này
import '../../constants/custom_animated_bottom_bar.dart';


class HomeScreen extends ConsumerStatefulWidget {
  final int selectedTab;

  HomeScreen({Key? key, this.selectedTab = 0}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends ConsumerState<HomeScreen> {
  int currentPos = 0;
  final Color _activeColor = primaryColor;
  final Color _inactiveColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    currentPos = widget.selectedTab;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double bottomHeight = Constant.getPercentSize(screenHeight, 8.5);
    double iconHeight = Constant.getPercentSize(bottomHeight, 28);

    // Lấy thông tin Profile từ profileProvider
    final Profile userProfile = ref.watch(profileProvider).profile;

    // Tạo danh sách các Tab với ListTile cho TabProfile
    final List<Widget> listImages = [
      const TabHome(),
      const TabFavourite(),
      const TabCart(),
      Column(
        children: [
          Expanded(
            child: TabProfile(
              email: userProfile.email,
              fullName: userProfile.full_name,
            ),
          ),
        ],
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        Constant.closeApp();
        return false;
      },
      child: Scaffold(
        body: listImages[currentPos],
        bottomNavigationBar: CustomAnimatedBottomBar(
          containerHeight: bottomHeight,
          backgroundColor: backgroundColor,
          selectedIndex: currentPos,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          totalItemCount: 4,
          onItemSelected: (index) => setState(() => currentPos = index),
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              title: 'Home',
              activeColor: _activeColor,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
              iconSize: iconHeight,
              imageName: "Home.svg",
            ),
            BottomNavyBarItem(
              title: 'Favourite',
              activeColor: _activeColor,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
              iconSize: iconHeight,
              imageName: "heart.svg",
            ),
            BottomNavyBarItem(
              title: 'Cart',
              activeColor: _activeColor,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
              iconSize: iconHeight,
              imageName: "Bag.svg",
            ),
            BottomNavyBarItem(
              title: 'Profile',
              activeColor: _activeColor,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
              iconSize: iconHeight,
              imageName: "User.svg",
            ),
          ],
        ),
      ),
    );
  }
}