// ignore: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shoplite/constants/apilist.dart';
import 'package:shoplite/constants/constant.dart';
import 'package:shoplite/constants/pref_data.dart';
import 'package:shoplite/constants/size_config.dart';
import 'package:shoplite/constants/widget_utils.dart';
import 'package:shoplite/constants/color_data.dart';
import 'package:shoplite/ui/home/home_screen.dart';
import '../../repositories/sitesetting_repository.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  final ProfileRepository _repository = ProfileRepository();
  String? siteName;
  String? logoUrl;
  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    // Gọi API để lấy site setting và lưu trữ
    final settings = await _repository.loadSiteSetting();
    siteName = settings['site_name'];
    logoUrl = settings['logo_url'];

    if (siteName != null && logoUrl != null) {
      // Nếu đã có dữ liệu, hiển thị ngay thông tin đã lưu
      setState(() {});
    }

    await _repository.fetchAndSaveSiteSetting();

    // Kiểm tra trạng thái đăng nhập

    g_token = await PrefData.getToken();
    bool isLoggedIn = await PrefData.isLogIn();
    // Chuyển trang sau khi load xong site setting
    if (isLoggedIn && g_token != '') {
      Constant.sendToScreen(HomeScreen(), context);
    } else {
      // PrefData.setLogIn(true); // Nếu cần, đặt trạng thái đã đăng nhập
      Constant.sendToScreen(const LoginScreen(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;

    double iconSize = Constant.getPercentSize(screenHeight, 10);

    return PopScope(
      onPopInvokedWithResult: (context, result) {
        // Handle back navigation
        Constant.backToFinish(context as BuildContext);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(Constant.getPercentSize(iconSize, 25)),
                child: logoUrl == null
                    ? getSvgImage("logo_img.svg", iconSize, color: fontBlack)
                    : Image.network(
                        logoUrl!,
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.fill,
                        color: fontBlack,
                      ),
              ),
              getCustomText(
                  siteName ?? "SHOPPING",
                  fontBlack,
                  1,
                  TextAlign.center,
                  FontWeight.w900,
                  Constant.getPercentSize(screenHeight, 5.5)),
            ],
          ),
        ),
      ),
    );
  }
}
