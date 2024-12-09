// ignore: file_names
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shoplite/ui/checkout/checkout_confirm.dart';

import '../../constants/constant.dart';
import '../../constants/data_file.dart';
import '../../constants/review_slider.dart';
import '../../constants/size_config.dart';
import '../../constants/widget_utils.dart';
import '../../constants/color_data.dart';
import '../../models/payment_card_model.dart';

class CheckoutPayment extends StatefulWidget {
  const CheckoutPayment({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CheckoutPayment();
  }
}

class _CheckoutPayment extends State<CheckoutPayment> {
  int currentStep = 0;
  int _selectedAddress = 0;
  List<PaymentCardModel> paymentModelList = DataFile.getPaymentCardList();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void _requestPop() {
    Constant.backToFinish(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double leftMargin = getAppBarPadding();
    double appBarPadding = getAppBarPadding();
    double edtHeight = getEditHeight();

    double cellHeight = MediaQuery.of(context).size.width * 0.2;

    return WillPopScope(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              getDefaultHeader(context, "Checkout", () {
                _requestPop();
              }, (value) {}, isShowSearch: false),
              getSpace(Constant.getPercentSize(screenHeight, 1.5)),
              ReviewSlider(
                  optionStyle: TextStyle(
                    fontFamily: Constant.fontsFamily,
                    fontSize: Constant.getHeightPercentSize(1.7),
                    color: fontBlack,
                    fontWeight: FontWeight.w500,
                  ),
                  onChange: (index) {},
                  initialValue: 1,
                  circleDiameter: Constant.getHeightPercentSize(5.5),
                  isCash: false,
                  width: double.infinity,
                  options: Constant.getOption()),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: leftMargin, right: leftMargin),
                  child: ListView(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: paymentModelList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Container(
                                margin: EdgeInsets.only(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    getHorSpace(Constant.getPercentSize(
                                        screenWidth, 2.3)),
                                    Icon(
                                      (index == _selectedAddress)
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: (index == _selectedAddress)
                                          ? primaryColor
                                          : greyFont,
                                      size: Constant.getPercentSize(
                                          cellHeight, 30),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                _selectedAddress = index;
                                setState(() {});
                              },
                            );
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              addNewCardDialog();
                            },
                            child: Container(
                              height: edtHeight,
                              margin: EdgeInsets.only(top: appBarPadding),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      Constant.getPercentSize(screenWidth, 10)),
                              decoration: getButtonShapeDecoration(
                                  primaryColor.withOpacity(0.1)),
                              child: Row(
                                children: [
                                  Icon(Icons.add,
                                      color: primaryColor,
                                      size: Constant.getPercentSize(
                                          edtHeight, 30)),
                                  getHorSpace(
                                      Constant.getPercentSize(screenWidth, 2)),
                                  getCustomText(
                                      "Add New Card",
                                      primaryColor,
                                      1,
                                      TextAlign.start,
                                      FontWeight.bold,
                                      Constant.getPercentSize(edtHeight, 28)),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                flex: 1,
              ),
              getButton(primaryColor, true, "Next", Colors.white, () {
                Constant.sendToScreen(const CheckoutConfirm(), context);
              }, FontWeight.w700, EdgeInsets.all(appBarPadding))
            ],
          ),
        ),
        onWillPop: () async {
          _requestPop();
          return false;
        });
  }

  bool isSaveCard = true;
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController expDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

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

  Widget getDefaultTextFiledWithoutIconWidget(BuildContext context, String s,
      TextEditingController textEditingController,
      {bool withPrefix = false, String imgName = ""}) {
    double height = getEditHeight();

    double radius = Constant.getPercentSize(height, 20);
    double fontSize = Constant.getPercentSize(height, 27);
    FocusNode myFocusNode = FocusNode();
    bool isAutoFocus = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: height,
          margin: EdgeInsets.symmetric(
              vertical: Constant.getHeightPercentSize(1.2)),
          padding: EdgeInsets.symmetric(
              horizontal: Constant.getWidthPercentSize(2.5)),
          alignment: Alignment.centerLeft,
          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape: SmoothRectangleBorder(
              side: BorderSide(
                  color: isAutoFocus ? primaryColor : Colors.grey.shade400,
                  width: 1),
              borderRadius: SmoothBorderRadius(
                cornerRadius: radius,
                cornerSmoothing: 0.8,
              ),
            ),
          ),
          child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                setState(() {
                  isAutoFocus = true;
                  myFocusNode.canRequestFocus = true;
                });
              } else {
                setState(() {
                  isAutoFocus = false;
                  myFocusNode.canRequestFocus = false;
                });
              }
            },
            child: TextField(
              maxLines: 1,
              controller: textEditingController,
              autofocus: false,
              focusNode: myFocusNode,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                  fontFamily: Constant.fontsFamily,
                  color: fontBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize),
              decoration: InputDecoration(
                  prefixIcon: (withPrefix)
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: Constant.getWidthPercentSize(2.5)),
                          child: getSvgImage(
                              imgName, Constant.getPercentSize(height, 40)),
                        )
                      : getSpace(0),
                  border: InputBorder.none,
                  isDense: true,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: s,
                  prefixIconConstraints:
                      const BoxConstraints(minHeight: 0, minWidth: 0),
                  hintStyle: TextStyle(
                      fontFamily: Constant.fontsFamily,
                      color: greyFont,
                      fontWeight: FontWeight.w400,
                      fontSize: fontSize)),
            ),
          ),
        );
      },
    );
  }
}
