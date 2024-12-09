import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shoplite/constants/constant.dart';
import 'package:shoplite/constants/data_file.dart';
import 'package:shoplite/constants/review_slider.dart';
import 'package:shoplite/constants/size_config.dart';
import 'package:shoplite/constants/widget_utils.dart';
import 'package:shoplite/constants/color_data.dart';
import 'package:shoplite/ui/checkout/checkout_payment.dart';
import '../../models/address_model.dart';
import '../../models/payment_card_model.dart';
import '../profile/add_shipping_sddress_screen.dart';

class CheckoutAddress extends StatefulWidget {
  const CheckoutAddress({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CheckoutAddress();
  }
}

class _CheckoutAddress extends State<CheckoutAddress> {
  List<AddressModel> addressList = DataFile.getAddressList();

  int currentStep = 0;
  int _selectedAddress = 0;
  List<PaymentCardModel> paymentModelList = DataFile.getPaymentCardList();

  @override
  void initState() {
    super.initState();
    addressList = DataFile.getAddressList();
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
                  initialValue: 0,
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
                          itemCount: addressList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: appBarPadding / 2,
                                    top: appBarPadding / 2),
                                padding: EdgeInsets.all(appBarPadding),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      (index == _selectedAddress)
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: (index == _selectedAddress)
                                          ? primaryColor
                                          : greyFont,
                                      size: Constant.getPercentSize(
                                          cellHeight, 28),
                                    ),
                                    getHorSpace(Constant.getPercentSize(
                                        screenWidth, 2.3)),
                                    Expanded(
                                      child: getCustomTextWithoutMaxLine(
                                          addressList[index].location!,
                                          fontBlack,
                                          TextAlign.start,
                                          FontWeight.w400,
                                          Constant.getPercentSize(
                                              cellHeight, 20)),
                                      flex: 1,
                                    ),
                                    getHorSpace(Constant.getPercentSize(
                                        screenWidth, 2.3)),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Image.asset(
                                        Constant.assetImagePath + "edit.png",
                                        height: Constant.getPercentSize(
                                            cellHeight, 25),
                                      ),
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
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) =>
                                    const AddShippingAddressScreen(),
                              ))
                                  .then((value) {
                                setState(() {});
                              });
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
                                      "Add New Address",
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
                Constant.sendToScreen(const CheckoutPayment(), context);
              }, FontWeight.w700, EdgeInsets.all(appBarPadding))
            ],
          ),
        ),
        onWillPop: () async {
          _requestPop();
          return false;
        });
  }
}
