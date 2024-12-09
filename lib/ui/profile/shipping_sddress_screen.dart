// ignore: file_names
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shoplite/constants/constant.dart';
import 'package:shoplite/constants/data_file.dart';
import 'package:shoplite/constants/size_config.dart';
import 'package:shoplite/ui/home/home_screen.dart';
import 'package:shoplite/ui/profile/add_shipping_sddress_screen.dart';

import '../../constants/widget_utils.dart';
import '../../constants/color_data.dart';
import '../../models/address_model.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShippingAddressScreen();
  }
}

class _ShippingAddressScreen extends State<ShippingAddressScreen> {
  _requestPop() {
    Constant.sendToScreen(HomeScreen(selectedTab: 3), context);
  }

  List<String> popUpMenuList = ["Edit", "Delete"];

  List<AddressModel> addressList = [];

  // List<AddressModel> addressList = DataFile.getAddressList();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double appBarPadding = getAppBarPadding();

    double cellHeight = Constant.getPercentSize(screenWidth, 30);
    // double cellHeight = Constant.getPercentSize(screenWidth, 20);

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
                getDefaultHeader(context, "Shipping Address", () {
                  _requestPop();
                }, (value) {}, isShowSearch: false),
                getSpace(appBarPadding),
                Visibility(
                  visible: addressList.isNotEmpty,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: appBarPadding),
                    child: getCustomText(
                        "Your addresses",
                        fontBlack,
                        1,
                        TextAlign.start,
                        FontWeight.w600,
                        Constant.getPercentSize(screenHeight, 2.5)),
                  ),
                ),
                getSpace(appBarPadding / 2),
                Expanded(
                  child: (addressList.isEmpty)
                      ? Center(
                          child: getEmptyWidget(
                              "empty_location.svg",
                              "No Address Yet!",
                              "Add Your Address and lets get started.",
                              "Add Address", () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) =>
                                  const AddShippingAddressScreen(),
                            ))
                                .then((value) {
                              addressList = DataFile.getAddressList();
                              setState(() {});
                            });
                          }),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: ListView.builder(
                            itemBuilder: (context1, index) {
                              return Container(
                                height: cellHeight,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                    horizontal: appBarPadding,
                                    vertical: appBarPadding / 2),
                                padding: EdgeInsets.all(appBarPadding),
                                decoration: ShapeDecoration(
                                    color: cardColor,
                                    shadows: [
                                      BoxShadow(
                                          color: shadowColor.withOpacity(0.05),
                                          spreadRadius: 1,
                                          blurRadius: 3)
                                    ],
                                    shape: SmoothRectangleBorder(
                                        borderRadius: SmoothBorderRadius(
                                            cornerRadius:
                                                Constant.getPercentSize(
                                                    cellHeight, 19),
                                            cornerSmoothing: 0.5))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: getCustomText(
                                              "Jennie Winget",
                                              fontBlack,
                                              1,
                                              TextAlign.start,
                                              FontWeight.w700,
                                              Constant.getPercentSize(
                                                  cellHeight, 13.5)),
                                          flex: 1,
                                        ),
                                        getHorSpace(Constant.getPercentSize(
                                            screenWidth, 1.5)),
                                        PopupMenuButton(
                                          child: Image.asset(
                                              Constant.assetImagePath +
                                                  "more.png",
                                              height: Constant.getPercentSize(
                                                  cellHeight, 14),
                                              width: Constant.getPercentSize(
                                                  cellHeight, 15)),
                                          padding: EdgeInsets.zero,
                                          // getSvgImage(
                                          //     "Sort.svg",
                                          //     Constant.getPercentSize(
                                          //         cellHeight, 30)),
                                          itemBuilder: (context1) {
                                            return List.generate(
                                                popUpMenuList.length, (index) {
                                              return PopupMenuItem(
                                                padding: EdgeInsets.zero,
                                                height: 29,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Align(
                                                        child: getCustomText(
                                                            popUpMenuList[
                                                                index],
                                                            fontBlack,
                                                            1,
                                                            TextAlign.start,
                                                            FontWeight.w400,
                                                            15),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                      ),
                                                      height: (index ==
                                                              popUpMenuList
                                                                      .length -
                                                                  1)
                                                          ? 30
                                                          : 29,
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                    ),
                                                    (index ==
                                                            popUpMenuList
                                                                    .length -
                                                                1)
                                                        ? Container()
                                                        : Divider(
                                                            color: Colors
                                                                .grey.shade300,
                                                            height: 1.5,
                                                          )
                                                  ],
                                                ),

                                                onTap: () async {
                                                  if (index == 1) {
                                                    Future.delayed(
                                                      Duration.zero,
                                                      () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            double height = Constant
                                                                .getHeightPercentSize(
                                                                    30);
                                                            double width = Constant
                                                                .getWidthPercentSize(
                                                                    80);
                                                            double radius = Constant
                                                                .getPercentSize(
                                                                    height, 4);

                                                            return Dialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .circular(Constant
                                                                        .getPercentSize(
                                                                            screenHeight,
                                                                            2)),
                                                              ),
                                                              elevation: 0.0,
                                                              insetPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child: Container(
                                                                height: height,
                                                                width: width,
                                                                padding:
                                                                    EdgeInsets.all(
                                                                        (radius)),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      backgroundColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              radius),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color:
                                                                          shadowColor,
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                        child:
                                                                            Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              Constant.getPercentSize(
                                                                            height,
                                                                            4,
                                                                          ),
                                                                        ),
                                                                        getCustomTextWithoutMaxLine(
                                                                          'Are you sure you want to delete\n this address?',
                                                                          fontBlack,
                                                                          TextAlign
                                                                              .center,
                                                                          FontWeight
                                                                              .bold,
                                                                          Constant.getPercentSize(
                                                                              height,
                                                                              10),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              Constant.getPercentSize(
                                                                            height,
                                                                            14,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: Constant.getPercentSize(width, 5)),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: InkWell(
                                                                                    onTap: () {
                                                                                      Constant.backToFinish(context);
                                                                                    },
                                                                                    child: Container(
                                                                                      margin: EdgeInsets.only(right: Constant.getWidthPercentSize(3)),
                                                                                      height: Constant.getHeightPercentSize(7),
                                                                                      decoration: ShapeDecoration(
                                                                                        color: Colors.transparent,
                                                                                        shape: SmoothRectangleBorder(
                                                                                          side: BorderSide(color: primaryColor, width: 2),
                                                                                          borderRadius: SmoothBorderRadius(
                                                                                            cornerRadius: Constant.getHeightPercentSize(1.8),
                                                                                            cornerSmoothing: 0.8,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: getCustomText("Cancel", primaryColor, 1, TextAlign.center, FontWeight.w600, Constant.getHeightPercentSize(2)),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                              Expanded(
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    Constant.backToFinish(context);
                                                                                    // Navigator.pushReplacement(
                                                                                    //     context,
                                                                                    //     MaterialPageRoute(
                                                                                    //       builder: (context) => TrackOrderPage(),
                                                                                    //     ));
                                                                                  },
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(left: Constant.getWidthPercentSize(3)),
                                                                                    height: Constant.getHeightPercentSize(7),
                                                                                    decoration: ShapeDecoration(
                                                                                      color: primaryColor,
                                                                                      shape: SmoothRectangleBorder(
                                                                                        borderRadius: SmoothBorderRadius(
                                                                                          cornerRadius: Constant.getHeightPercentSize(1.8),
                                                                                          cornerSmoothing: 0.8,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    child: Center(child: getCustomText("Delete", Colors.white, 1, TextAlign.center, FontWeight.w600, Constant.getHeightPercentSize(2))),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  } else {}
                                                  // switch (index) {
                                                  //   case 0:
                                                  //     break;
                                                  //   case 1:

                                                  // showDialog(
                                                  //   context: context,
                                                  //   builder: (context) {
                                                  //     double height = Constant
                                                  //         .getHeightPercentSize(
                                                  //             35);
                                                  //     double width = Constant
                                                  //         .getWidthPercentSize(
                                                  //             80);
                                                  //     double radius = Constant
                                                  //         .getPercentSize(
                                                  //             height, 4);
                                                  //     double imgSize = Constant
                                                  //         .getPercentSize(
                                                  //             height, 32);
                                                  //
                                                  //     return Dialog(
                                                  //       shape:
                                                  //           RoundedRectangleBorder(
                                                  //         borderRadius: BorderRadius
                                                  //             .circular(Constant
                                                  //                 .getPercentSize(
                                                  //                     screenHeight,
                                                  //                     2)),
                                                  //       ),
                                                  //       elevation: 0.0,
                                                  //       insetPadding:
                                                  //           EdgeInsets.zero,
                                                  //       backgroundColor:
                                                  //           Colors.transparent,
                                                  //       child: Container(
                                                  //         height: height,
                                                  //         width: width,
                                                  //         padding:
                                                  //             EdgeInsets.all(
                                                  //                 (radius)),
                                                  //         decoration:
                                                  //             BoxDecoration(
                                                  //           color:
                                                  //               backgroundColor,
                                                  //           borderRadius:
                                                  //               BorderRadius
                                                  //                   .circular(
                                                  //                       radius),
                                                  //           boxShadow: [
                                                  //             BoxShadow(
                                                  //               color:
                                                  //                   shadowColor,
                                                  //             ),
                                                  //           ],
                                                  //         ),
                                                  //         child: Column(
                                                  //           mainAxisAlignment:
                                                  //               MainAxisAlignment
                                                  //                   .center,
                                                  //           crossAxisAlignment:
                                                  //               CrossAxisAlignment
                                                  //                   .center,
                                                  //           children: <Widget>[
                                                  //             Expanded(
                                                  //                 child:
                                                  //                     Container(
                                                  //               child: Column(
                                                  //                 mainAxisAlignment:
                                                  //                     MainAxisAlignment
                                                  //                         .center,
                                                  //                 crossAxisAlignment:
                                                  //                     CrossAxisAlignment
                                                  //                         .center,
                                                  //                 children: [
                                                  //                   SizedBox(
                                                  //                     height: Constant
                                                  //                         .getPercentSize(
                                                  //                       height,
                                                  //                       4,
                                                  //                     ),
                                                  //                   ),
                                                  //                   getCustomText(
                                                  //                     'Are you sure you want to delete\n this address?',
                                                  //                     fontBlack,
                                                  //                     1,
                                                  //                     TextAlign
                                                  //                         .center,
                                                  //                     FontWeight
                                                  //                         .bold,
                                                  //                     Constant.getPercentSize(
                                                  //                         height,
                                                  //                         6),
                                                  //                   ),
                                                  //                   SizedBox(
                                                  //                     height: Constant
                                                  //                         .getPercentSize(
                                                  //                       height,
                                                  //                       6,
                                                  //                     ),
                                                  //                   ),
                                                  //                   Padding(
                                                  //                     padding: EdgeInsets.symmetric(
                                                  //                         horizontal: Constant.getPercentSize(
                                                  //                             width,
                                                  //                             5)),
                                                  //                     child:
                                                  //                         Row(
                                                  //                       children: [
                                                  //                         Expanded(
                                                  //                           child: InkWell(
                                                  //                               onTap: () {
                                                  //                                 Constant.backToFinish(context);
                                                  //                               },
                                                  //                               child: Container(
                                                  //                                 margin: EdgeInsets.only(right: Constant.getWidthPercentSize(3)),
                                                  //                                 height: Constant.getHeightPercentSize(7),
                                                  //                                 decoration: ShapeDecoration(
                                                  //                                   color: Colors.transparent,
                                                  //                                   shape: SmoothRectangleBorder(
                                                  //                                     side: BorderSide(color: primaryColor, width: 2),
                                                  //                                     borderRadius: SmoothBorderRadius(
                                                  //                                       cornerRadius: Constant.getHeightPercentSize(1.8),
                                                  //                                       cornerSmoothing: 0.8,
                                                  //                                     ),
                                                  //                                   ),
                                                  //                                 ),
                                                  //                                 child: Center(
                                                  //                                   child: getCustomText("Cancel", primaryColor, 1, TextAlign.center, FontWeight.w600, Constant.getHeightPercentSize(2)),
                                                  //                                 ),
                                                  //                               )),
                                                  //                         ),
                                                  //                         Expanded(
                                                  //                           child:
                                                  //                               InkWell(
                                                  //                             onTap: () {
                                                  //                               Constant.backToFinish(context);
                                                  //                               // Navigator.pushReplacement(
                                                  //                               //     context,
                                                  //                               //     MaterialPageRoute(
                                                  //                               //       builder: (context) => TrackOrderPage(),
                                                  //                               //     ));
                                                  //                             },
                                                  //                             child: Container(
                                                  //                               margin: EdgeInsets.only(left: Constant.getWidthPercentSize(3)),
                                                  //                               height: Constant.getHeightPercentSize(7),
                                                  //                               decoration: ShapeDecoration(
                                                  //                                 color: primaryColor,
                                                  //                                 shape: SmoothRectangleBorder(
                                                  //                                   borderRadius: SmoothBorderRadius(
                                                  //                                     cornerRadius: Constant.getHeightPercentSize(1.8),
                                                  //                                     cornerSmoothing: 0.8,
                                                  //                                   ),
                                                  //                                 ),
                                                  //                               ),
                                                  //                               child: Center(child: getCustomText("Delete", Colors.white, 1, TextAlign.center, FontWeight.w600, Constant.getHeightPercentSize(2))),
                                                  //                             ),
                                                  //                           ),
                                                  //                         )
                                                  //                       ],
                                                  //                     ),
                                                  //                   )
                                                  //                 ],
                                                  //               ),
                                                  //             )),
                                                  //           ],
                                                  //         ),
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // );
                                                  // break;
                                                  // }
                                                  // Navigator.of(context).pop();
                                                },
                                                // child: Text(popUpMenuList[index]),
                                              );
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    // getSpace(Constant.getPercentSize(
                                    //     cellHeight, 10)),
                                    Expanded(
                                      child: Container(),
                                      flex: 1,
                                    ),

                                    getCustomText(
                                        "1901 Thornridge Cir.Shiloh,\nHawaii 81063,US",
                                        fontBlack,
                                        2,
                                        TextAlign.start,
                                        FontWeight.w400,
                                        Constant.getPercentSize(
                                            cellHeight, 13)),
                                    Expanded(
                                      child: Container(),
                                      flex: 1,
                                    ),
                                    getCustomText(
                                        "(603) 555-0123",
                                        fontBlack,
                                        1,
                                        TextAlign.start,
                                        FontWeight.w400,
                                        Constant.getPercentSize(cellHeight, 13))
                                  ],
                                ),
                              );
                            },
                            itemCount: addressList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            primary: true,
                          ),
                        ),
                  flex: 1,
                ),
                Visibility(
                    visible: addressList.isNotEmpty,
                    child: getButton(
                        primaryColor, true, "Add New Address", Colors.white,
                        () {
                      Constant.sendToScreen(
                          const AddShippingAddressScreen(), context);
                      // print("addaddres===true");
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
