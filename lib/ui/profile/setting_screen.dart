// ignore: file_names
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shoplite/constants/size_config.dart';
import 'package:shoplite/constants/color_data.dart';
import 'package:shoplite/ui/profile/card_list_screen.dart';
import 'package:shoplite/ui/profile/my_order_screen.dart';
import 'package:shoplite/ui/settings/notification_screen.dart';

import '../../../constants/constant.dart';
import '../../../constants/widget_utils.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingScreen();
  }
}

class _SettingScreen extends State<SettingScreen> {
  backClick() {
    Constant.backToFinish(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double appBarPadding = getAppBarPadding();
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              getDefaultHeader(context, "Setting", () {
                backClick();
              }, (value) {},
                  withFilter: false, isShowBack: true, isShowSearch: false),
              getSpace(appBarPadding),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(getAppBarPadding()),
                    padding: EdgeInsets.only(
                        left: appBarPadding, right: appBarPadding),
                    decoration: ShapeDecoration(
                        color: cardColor,
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius:
                                    Constant.getPercentSize(screenHeight, 2),
                                cornerSmoothing: 0.5)),
                        shadows: [
                          BoxShadow(
                              color: shadowColor.withOpacity(0.02),
                              blurRadius: 3,
                              spreadRadius: 4)
                        ]),
                    child: Column(
                      children: [
                        getSpace(appBarPadding),
                        getSettingRow("notification_icon.svg", "Notifications",
                            () {
                          Constant.sendToScreen(
                              const NotificationScreen(), context);
                        }),
                        getSeparatorWidget(),
                        getSettingRow("Question.svg", "Help & Support", () {
                          Constant.sendToScreen(const MyOrderScreen(), context);
                        }),
                        getSeparatorWidget(),
                        getSettingRow("Lock.svg", "Privacy", () {}),
                        getSeparatorWidget(),
                        // getSettingRow("heart.svg", "Shipping Address", () {
                        //   Constant.sendToScreen(
                        //       ShippingAddressScreen(), context);
                        // }),
                        // getSeparatorWidget(),
                        getSettingRow("security.svg", "Security", () {
                          Constant.sendToScreen(
                              const CardListScreen(), context);
                        }),
                        getSeparatorWidget(),
                        getSettingRow(
                            "Document.svg", "Terms of Service", () {}),
                        getSpace(appBarPadding),
                      ],
                    ),
                  ),
                ),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSeparatorWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getAppBarPadding()),
      child: Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }
}
