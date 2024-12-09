// ignore: file_names
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shoplite/constants/constant.dart';
import 'package:shoplite/constants/data_file.dart';
import 'package:shoplite/constants/size_config.dart';
import 'package:shoplite/models/model_my_order.dart';
import 'package:shoplite/ui/home/home_screen.dart';
import 'package:shoplite/ui/items/track_order_screen.dart';

import '../../constants/widget_utils.dart';
import '../../constants/color_data.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyOrderScreen();
  }
}

class _MyOrderScreen extends State<MyOrderScreen> {
  _requestPop() {
    Constant.backToFinish(context);
  }

  // List<ModelMyOrder> myOrderList = [];
  List<ModelMyOrder> myOrderList = DataFile.getMyOrders();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double appBarPadding = getAppBarPadding();

    double cellHeight = Constant.getPercentSize(screenWidth, 21);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getDefaultHeader(context, "My Orders", () {
                  _requestPop();
                }, (value) {}, isShowSearch: false),
                getSpace(appBarPadding),
                Visibility(
                  visible: myOrderList.isNotEmpty,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: appBarPadding),
                    child: getCustomText(
                        "List of your orders",
                        fontBlack,
                        1,
                        TextAlign.start,
                        FontWeight.w600,
                        Constant.getPercentSize(screenHeight, 2)),
                  ),
                ),
                Expanded(
                  child: (myOrderList.isEmpty)
                      ? Center(
                          child: getEmptyWidget(
                              "empty_cart.svg",
                              "No Orders Yet!",
                              "Explore more and shortlist some products",
                              "Go to Shop", () {
                            Constant.sendToScreen(HomeScreen(), context);
                          }),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              ModelMyOrder modelCart = myOrderList[index];
                              double sizeHeight =
                                  Constant.getPercentSize(cellHeight, 29);
                              double sizeWidth = sizeHeight * 3;

                              return InkWell(
                                onTap: () {
                                  Constant.sendToScreen(
                                      const TrackOrderScreen(), context);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: appBarPadding,
                                      right: appBarPadding,
                                      top: (index == 0)
                                          ? appBarPadding
                                          : (appBarPadding / 2),
                                      bottom: appBarPadding / 2),
                                  width: double.infinity,
                                  height: cellHeight,
                                  padding: EdgeInsets.all(
                                      Constant.getPercentSize(cellHeight, 10)),
                                  decoration: ShapeDecoration(
                                      color: cardColor,
                                      shape: SmoothRectangleBorder(
                                          borderRadius: SmoothBorderRadius(
                                              cornerRadius:
                                                  Constant.getPercentSize(
                                                      cellHeight, 13),
                                              cornerSmoothing: 0.5))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        child: Image.asset(
                                          Constant.assetImagePath +
                                              modelCart.image!,
                                          width: Constant.getPercentSize(
                                              screenWidth, 15.5),
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                Constant.getPercentSize(
                                                    cellHeight, 10))),
                                      ),
                                      getHorSpace(Constant.getPercentSize(
                                          screenWidth, 3)),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            getCustomText(
                                                modelCart.name ?? "",
                                                fontBlack,
                                                1,
                                                TextAlign.start,
                                                FontWeight.bold,
                                                Constant.getPercentSize(
                                                    cellHeight, 15)),
                                            getSpace(Constant.getPercentSize(
                                                cellHeight, 7)),
                                            getCustomText(
                                                modelCart.subTitle ?? "",
                                                fontBlack,
                                                1,
                                                TextAlign.start,
                                                FontWeight.w400,
                                                Constant.getPercentSize(
                                                    cellHeight, 14)),
                                            const Expanded(
                                              child: SizedBox(),
                                              flex: 1,
                                            ),
                                            Row(
                                              children: [
                                                getCustomText(
                                                    modelCart.price ?? "",
                                                    fontBlack,
                                                    1,
                                                    TextAlign.start,
                                                    FontWeight.w700,
                                                    Constant.getPercentSize(
                                                        cellHeight, 14.5)),
                                                getHorSpace(
                                                    Constant.getPercentSize(
                                                        screenWidth, 0.5)),
                                                Expanded(
                                                  child: getCustomText(
                                                      " x${modelCart.quantity}",
                                                      greyFont,
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.w600,
                                                      Constant.getPercentSize(
                                                          cellHeight, 15.5)),
                                                  flex: 1,
                                                )
                                              ],
                                            )
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                        flex: 1,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          getCustomText(
                                              "25-02-2022",
                                              greyFont,
                                              1,
                                              TextAlign.start,
                                              FontWeight.w400,
                                              Constant.getPercentSize(
                                                  cellHeight, 13.3)),
                                          Container(
                                            child: Center(
                                              child: getCustomText(
                                                  modelCart.status ?? "",
                                                  modelCart.color!,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.w500,
                                                  Constant.getPercentSize(
                                                      sizeWidth, 14)),
                                            ),
                                            width: sizeWidth,
                                            height: sizeHeight,
                                            decoration: ShapeDecoration(
                                                shape: SmoothRectangleBorder(
                                                    borderRadius:
                                                        SmoothBorderRadius(
                                                            cornerRadius: Constant
                                                                .getPercentSize(
                                                                    sizeHeight,
                                                                    50))),
                                                color: modelCart.color!
                                                    .withOpacity(0.1)),
                                          )
                                        ],
                                      )
                                      // getSvgImage("Trash.svg", deleteIconSize)
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: myOrderList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            primary: true,
                          ),
                        ),
                  flex: 1,
                )
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
            getCustomText(title, fontBlack, 1, TextAlign.start, FontWeight.w700,
                Constant.getPercentSize(iconSize, 63)),
            getSpace(Constant.getPercentSize(iconSize, 36)),
            getCustomText(desc, greyFont, 1, TextAlign.start, FontWeight.w400,
                Constant.getPercentSize(iconSize, 61)),
          ],
        )
      ],
    );
  }
}
