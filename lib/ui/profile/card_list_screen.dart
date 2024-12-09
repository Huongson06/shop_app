// ignore: file_names
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shoplite/constants/constant.dart';
import 'package:shoplite/constants/data_file.dart';
import 'package:shoplite/constants/size_config.dart';
import 'package:shoplite/ui/home/home_screen.dart';

import '../../constants/widget_utils.dart';
import '../../constants/color_data.dart';
import '../../models/payment_card_model.dart';

class CardListScreen extends StatefulWidget {
  const CardListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CardListScreen();
  }
}

class _CardListScreen extends State<CardListScreen> {
  _requestPop() {
    Constant.sendToScreen(HomeScreen(selectedTab: 3), context);
  }

  List<PaymentCardModel> paymentModelList = DataFile.getPaymentCardList();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController expDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  bool isSaveCard = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double appBarPadding = getAppBarPadding();

    double cellHeight = Constant.getPercentSize(screenWidth, 20);

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
                getDefaultHeader(context, "My Cards", () {
                  _requestPop();
                }, (value) {}, isShowSearch: false),
                getSpace(appBarPadding),
                Visibility(
                  visible: paymentModelList.isNotEmpty,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: appBarPadding),
                    child: getCustomText(
                        "Your cards",
                        fontBlack,
                        1,
                        TextAlign.start,
                        FontWeight.w600,
                        Constant.getPercentSize(screenHeight, 2.5)),
                  ),
                ),
                getSpace(appBarPadding / 2),
                Expanded(
                  child: (paymentModelList.isEmpty)
                      ? Center(
                          child: getEmptyWidget(
                              "empty_card.svg",
                              "No Cards Yet!",
                              "Add your card and lets get started.",
                              "Add Card", () {
                            addNewCardDialog();
                          }),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: paymentModelList.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: appBarPadding,
                                        right: appBarPadding,
                                        bottom: appBarPadding / 2,
                                        top: appBarPadding / 2),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: appBarPadding,
                                        vertical: Constant.getPercentSize(
                                            appBarPadding, 50)),
                                    // padding: EdgeInsets.all(
                                    //     Constant.getHeightPercentSize(10)),
                                    // decoration: getDecoration(getPercentSize(cellHeight,10 )),
                                    decoration: ShapeDecoration(
                                        color: cardColor,
                                        shape: SmoothRectangleBorder(
                                            borderRadius: SmoothBorderRadius(
                                                cornerRadius:
                                                    Constant.getPercentSize(
                                                        cellHeight, 10),
                                                cornerSmoothing: 0.5))),
                                    height: cellHeight,
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        getSvgImage(
                                            paymentModelList[index].image ?? "",
                                            Constant.getPercentSize(
                                                cellHeight, 50)),
                                        getHorSpace(Constant.getPercentSize(
                                            screenWidth, 2.3)),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              getCustomText(
                                                  paymentModelList[index].name!,
                                                  fontBlack,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.bold,
                                                  Constant.getPercentSize(
                                                      cellHeight, 22)),
                                              getSpace(Constant.getPercentSize(
                                                  cellHeight, 7)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  getCustomText(
                                                      "xxxx xxxx xxxx ",
                                                      fontBlack,
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.w400,
                                                      Constant.getPercentSize(
                                                          cellHeight, 19)),
                                                  Expanded(
                                                    child: getCustomText(
                                                        paymentModelList[index]
                                                            .desc!,
                                                        fontBlack,
                                                        1,
                                                        TextAlign.start,
                                                        FontWeight.w400,
                                                        Constant.getPercentSize(
                                                            cellHeight, 21)),
                                                    flex: 1,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {});
                                  },
                                );
                              }),
                        ),
                  flex: 1,
                ),
                Visibility(
                    visible: paymentModelList.isNotEmpty,
                    child: getButton(
                        primaryColor, true, "Add New Card", Colors.white, () {
                      addNewCardDialog();
                    }, FontWeight.w700, EdgeInsets.all(appBarPadding)))
              ],
            ),
          ),
        ),
        onWillPop: () async {
          _requestPop();
          return false;
        });
  }

  addNewCardDialog() {
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double height = Constant.getPercentSize(screenHeight, 45);
    double radius = Constant.getPercentSize(screenHeight, 4.5);
    double margin = getAppBarPadding();
    double cellHeight = Constant.getPercentSize(height, 6.5);
    double fontSize = Constant.getPercentSize(cellHeight, 70);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius))),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return FractionallySizedBox(
                heightFactor: 0.57,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: margin),
                  child: ListView(
                    children: <Widget>[
                      getSpace(Constant.getPercentSize(height, 4)),
                      Center(
                        child: Container(
                          width: Constant.getWidthPercentSize(10),
                          height: 1,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      getSpace(Constant.getPercentSize(height, 5)),
                      Row(
                        children: [
                          Expanded(
                            child: getCustomText(
                                "Add Credit Card",
                                fontBlack,
                                1,
                                TextAlign.start,
                                FontWeight.bold,
                                Constant.getPercentSize(height, 5)),
                            flex: 1,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.close,
                                size: Constant.getPercentSize(height, 6),
                                color: fontBlack,
                              )),
                        ],
                      ),
                      getSpace(Constant.getPercentSize(height, 3)),
                      getDefaultTextFiledWithoutIconWidget(
                          context, "Name On Card", cardHolderNameController,
                          withPrefix: true, imgName: "Document.svg"),
                      getDefaultTextFiledWithoutIconWidget(
                          context, "Card Number", cardNumberController,
                          withPrefix: true, imgName: "Card.svg"),
                      Row(
                        children: [
                          Expanded(
                            child: getDefaultTextFiledWithoutIconWidget(
                                context, "MM/YY", expDateController),
                            flex: 1,
                          ),
                          getHorSpace(margin),
                          Expanded(
                            child: getDefaultTextFiledWithoutIconWidget(
                                context, "CVV", cvvController),
                            flex: 1,
                          )
                        ],
                      ),
                      getSpace(Constant.getPercentSize(height, 3)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (isSaveCard) {
                              isSaveCard = false;
                            } else {
                              isSaveCard = true;
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: Constant.getHeightPercentSize(0.5)),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Container(
                                height: cellHeight,
                                width: cellHeight,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: primaryColor.withOpacity(0.4),
                                        width: 1),
                                    color: (isSaveCard)
                                        ? primaryColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Constant.getPercentSize(
                                            cellHeight, 12)))),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    size:
                                        Constant.getPercentSize(cellHeight, 80),
                                    color: (isSaveCard)
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: fontSize,
                              ),
                              getCustomText("Save Card", fontBlack, 1,
                                  TextAlign.start, FontWeight.w500, fontSize)
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              top: Constant.getHeightPercentSize(0.5)),
                          child: getButton(
                            primaryColor,
                            true,
                            "Add",
                            Colors.white,
                            () {},
                            FontWeight.bold,
                            EdgeInsets.symmetric(vertical: margin),
                          )
                          //     getButtonWidget(context, "Add", primaryColor, () {
                          //   Navigator.of(context).pop();
                          // }),
                          ),
                      getSpace(margin)
                    ],
                  ),
                ),
              );
            },
          );
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
