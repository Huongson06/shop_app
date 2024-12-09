// ignore: file_names
import 'package:flutter/material.dart';

import '../../constants/constant.dart';
import '../../constants/data_file.dart';
import '../../constants/review_slider.dart';
import '../../constants/size_config.dart';
import '../../constants/widget_utils.dart';
import '../../constants/color_data.dart';
import '../../models/address_model.dart';
import '../../models/payment_card_model.dart';
import '../../models/product_model.dart';
import 'thank_you_dialog.dart';

class CheckoutConfirm extends StatefulWidget {
  const CheckoutConfirm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CheckoutConfirm();
  }
}

class _CheckoutConfirm extends State<CheckoutConfirm> {
  List<AddressModel> addressList = DataFile.getAddressList();

  int currentStep = 0;
  List<PaymentCardModel> paymentModelList = DataFile.getPaymentCardList();
  List<ProductModel> cartModelList = DataFile.getCartModel();

  @override
  void initState() {
    super.initState();
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
    double height = Constant.getPercentSize(screenHeight, 12);

    double imageSize = Constant.getPercentSize(height, 67);
    double radius = Constant.getPercentSize(height, 10);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              getDefaultHeader(context, "Checkout", () {
                _requestPop();

              }, (value) {
              }, isShowSearch: false),
              getSpace(Constant.getPercentSize(screenHeight, 1.5)),
              ReviewSlider(
                  optionStyle: TextStyle(
                    fontFamily: Constant.fontsFamily,
                    fontSize: Constant.getHeightPercentSize(1.7),
                    color: fontBlack,
                    fontWeight: FontWeight.w500,
                  ),
                  onChange: (index) {},
                  initialValue: 2,
                  circleDiameter: Constant.getHeightPercentSize(5.5),
                  isCash: false,
                  width: double.infinity,
                  options: Constant.getOption()),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.only(left: leftMargin, right: leftMargin),
                  child: ListView(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            bottom:
                                Constant.getPercentSize(screenHeight, 2)),
                        padding: EdgeInsets.all(
                            Constant.getPercentSize(screenHeight, 2)),
                        decoration: getButtonShapeDecoration(cardColor,
                            withCustomCorner: true,
                            corner:
                                Constant.getPercentSize(screenHeight, 1.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getCustomText(
                                'Shipping Address',
                                fontBlack,
                                1,
                                TextAlign.start,
                                FontWeight.bold,
                                Constant.getPercentSize(screenHeight, 2.2)),
                            getSpace(
                                Constant.getPercentSize(screenHeight, 1)),
                            getCustomTextWithoutMaxLine(
                                '1901 Thornridge Cir.Shiloh,Hawaii 81063',
                                fontBlack,
                                TextAlign.start,
                                FontWeight.w400,
                                Constant.getPercentSize(screenHeight, 2.2)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom:
                                Constant.getPercentSize(screenHeight, 2)),
                        padding: EdgeInsets.all(
                            Constant.getPercentSize(screenHeight, 2)),
                        decoration: getButtonShapeDecoration(cardColor,
                            withCustomCorner: true,
                            corner:
                                Constant.getPercentSize(screenHeight, 1.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomText(
                                'Payment Method',
                                fontBlack,
                                1,
                                TextAlign.start,
                                FontWeight.bold,
                                Constant.getPercentSize(screenHeight, 2.2)),
                            getSpace(
                                Constant.getPercentSize(screenHeight, 1)),
                            Row(
                              children: [
                                getSvgImage(
                                    "paypal.svg",
                                    Constant.getPercentSize(
                                        screenHeight, 4)),
                                getHorSpace(Constant.getPercentSize(
                                    screenWidth, 2)),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getCustomText(
                                          'Paypal',
                                          fontBlack,
                                          1,
                                          TextAlign.start,
                                          FontWeight.bold,
                                          Constant.getPercentSize(
                                              screenHeight, 2)),
                                      Row(
                                        children: [
                                          getCustomTextWithoutMaxLine(
                                              'xxxx xxxx xxxx ',
                                              fontBlack,
                                              TextAlign.start,
                                              FontWeight.w400,
                                              Constant.getPercentSize(
                                                  screenHeight, 2)),
                                          Expanded(
                                            child:
                                                getCustomTextWithoutMaxLine(
                                                    '5416',
                                                    fontBlack,
                                                    TextAlign.start,
                                                    FontWeight.w400,
                                                    Constant.getPercentSize(
                                                        screenHeight, 2.2)),
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
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom:
                                Constant.getPercentSize(screenHeight, 2)),
                        padding: EdgeInsets.all(
                            Constant.getPercentSize(screenHeight, 2)),
                        decoration: getButtonShapeDecoration(cardColor,
                            withCustomCorner: true,
                            corner:
                                Constant.getPercentSize(screenHeight, 1.5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomText(
                                'Cart Detail',
                                fontBlack,
                                1,
                                TextAlign.start,
                                FontWeight.bold,
                                Constant.getPercentSize(screenHeight, 2.2)),
                            getSpace(
                                Constant.getPercentSize(appBarPadding, 90)),
                            ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return Container(
                                    height: 0.4,
                                    color: Colors.grey.shade300,
                                    margin: EdgeInsets.symmetric(
                                        vertical: leftMargin),
                                  );
                                },
                                shrinkWrap: true,
                                itemCount: cartModelList.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: imageSize,
                                          width: imageSize,
                                          decoration:
                                              getButtonShapeDecoration(
                                                  Colors.transparent,
                                                  withCustomCorner: true,
                                                  corner: radius),
                                          margin: EdgeInsets.only(
                                            right: (leftMargin / 2),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(radius)),
                                            child: Image.asset(
                                              Constant.assetImagePath +
                                                  cartModelList[index]
                                                      .image!,
                                              width: imageSize,
                                              height: imageSize,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                          // Card(
                                          //   shape: RoundedRectangleBorder(
                                          //       borderRadius:
                                          //           BorderRadiusDirectional
                                          //               .circular(radius)),
                                          //   clipBehavior: Clip.antiAlias,
                                          //   child: Image.asset(
                                          //     Constant.assetImagePath +
                                          //         cartModelList[index].image!,
                                          //     fit: BoxFit.fill,
                                          //   ),
                                          // ),
                                          ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  getCustomText(
                                                      cartModelList[index]
                                                              .name ??
                                                          "",
                                                      fontBlack,
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.bold,
                                                      Constant
                                                          .getPercentSize(
                                                              height,
                                                              17.5)),
                                                  getSpace(Constant
                                                      .getPercentSize(
                                                          height, 7)),
                                                  getCustomText(
                                                      cartModelList[index]
                                                              .subTitle ??
                                                          "",
                                                      fontBlack,
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.w400,
                                                      Constant
                                                          .getPercentSize(
                                                              height, 15))
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                getCustomText(
                                                    cartModelList[index]
                                                            .price ??
                                                        "",
                                                    fontBlack,
                                                    1,
                                                    TextAlign.start,
                                                    FontWeight.bold,
                                                    Constant.getPercentSize(
                                                        height, 17)),
                                                getCustomText(
                                                    " x${cartModelList[index].quantity}",
                                                    greyFont,
                                                    1,
                                                    TextAlign.start,
                                                    FontWeight.w400,
                                                    Constant.getPercentSize(
                                                        height, 16))
                                              ],
                                            )
                                            // getCustomTextWithFontFamilyWidget(
                                            //     cartModelList[index].price!,
                                            //     primaryColor,
                                            //     getPercentSize(height, 15),
                                            //     FontWeight.w400,
                                            //     TextAlign.start,
                                            //     1)
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                })
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: Constant.getPercentSize(screenHeight, 2),top:Constant.getPercentSize(screenHeight, 2) ),
                        padding: EdgeInsets.all(
                            Constant.getPercentSize(screenHeight, 2)),
                        decoration: getButtonShapeDecoration(cardColor,
                            withCustomCorner: true,
                            corner:
                                Constant.getPercentSize(screenHeight, 1.5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getRow("Subtotal", '\$56.00'),
                            getSpace(
                                Constant.getPercentSize(screenHeight, 2.2)),
                            getRow("Shipping", '\$5.00'),
                            getSpace(
                                Constant.getPercentSize(screenHeight, 3.8)),
                            getRow("Tax(2%)", '\$2.00'),
                            getSpace(
                                Constant.getPercentSize(screenHeight, 3.8)),
                            getRow("Total", '\$63.00', isTotal: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 1,
              ),
              getButton(primaryColor, true, "Confirm", Colors.white, () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ThankYouDialog(context, (v) {
                        setState(() {

                        });
                      });
                    });

              },
                  FontWeight.w700, EdgeInsets.all(appBarPadding))
            ],
          ),
        ),
        onWillPop: () async {
          _requestPop();
          return false;
        });
  }

  getRow(String title, String total, {bool isTotal = false}) {
    return Row(
      children: [
        Expanded(
          child: (isTotal)
              ? getCustomText(title, fontBlack, 1, TextAlign.start,
                  FontWeight.w700, Constant.getHeightPercentSize(2.4))
              : getCustomText(title, fontBlack, 1, TextAlign.start,
                  FontWeight.w400, Constant.getHeightPercentSize(1.9)),
          flex: 1,
        ),
        (isTotal)
            ? getCustomText(total, primaryColor, 1, TextAlign.start,
                FontWeight.w700, Constant.getHeightPercentSize(2.8))
            : getCustomText(total, fontBlack, 1, TextAlign.start,
                FontWeight.w700, Constant.getHeightPercentSize(2.2))
      ],
    );
  }
}
