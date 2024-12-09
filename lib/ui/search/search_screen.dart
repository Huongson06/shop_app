// ignore: file_names
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shoplite/constants/constant.dart';
import 'package:shoplite/constants/size_config.dart';

import 'package:shoplite/ui/search/filter_screen.dart';

import '../../constants/widget_utils.dart';
import '../../constants/color_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchScreen();
  }
}

class _SearchScreen extends State<SearchScreen> {
  _requestPop() {
    Constant.backToFinish(context);
    // Constant.sendToScreen(HomeScreen(selectedTab: 3), context);
  }

  bool isSaveCard = true;

  List<String> suggestionlist = [

  ];

  List<String> selectedSearchList = ["shoes"];
  List<String> popularSearchList = [

  ];

  List<String> filteredList = [];
  TextEditingController searchController = TextEditingController(text: "sho");
  ValueNotifier<bool> valChange = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    checkData();
  }

  checkData() {
    String value = searchController.value.text;
    filteredList.clear();
    if (value.isNotEmpty) {
      for (var element in suggestionlist) {
        if (element.contains(value)) {
          filteredList.add(element);
        }
      }
      valChange.value = !valChange.value;
    } else {
      valChange.value = !valChange.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double appBarPadding = getAppBarPadding();
    double size = Constant.getHeightPercentSize(6);
    double toolbarHeight = Constant.getToolbarHeight(context);

    double iconSize = Constant.getPercentSize(screenHeight, 3.4);

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
                Container(
                  color: primaryColor,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            top: Constant.getToolbarTopHeight(context),
                            left: appBarPadding,
                            right: appBarPadding),
                        height: toolbarHeight,
                        child: Stack(
                          children: [
                            Visibility(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: getLeadingIcon(context, () {
                                    _requestPop();
                                  })),
                              visible: true,
                            ),
                            Center(
                              child: getCustomText(
                                  "Search",
                                  Colors.white,
                                  1,
                                  TextAlign.center,
                                  FontWeight.bold,
                                  Constant.getPercentSize(size, 50)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: appBarPadding,
                            right: appBarPadding,
                            bottom: appBarPadding * 1.5,
                            top: Constant.getPercentSize(appBarPadding, 30)),
                        width: double.infinity,
                        height: getEditHeight(),
                        padding: EdgeInsets.symmetric(
                            horizontal: Constant.getWidthPercentSize(3)),
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                    cornerRadius: getCorners(),
                                    cornerSmoothing: getCornerSmoothing()))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getSvgImage("Search.svg", getEdtIconSize()),
                            getHorSpace(Constant.getWidthPercentSize(2)),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  filteredList.clear();
                                  if (value.isNotEmpty) {
                                    for (var element in suggestionlist) {
                                      if (element.contains(value)) {
                                        filteredList.add(element);
                                      }
                                    }
                                    valChange.value = !valChange.value;
                                  } else {
                                    valChange.value = !valChange.value;
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: "Search...",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontFamily: Constant.fontsFamily,
                                        fontSize: getEdtTextSize(),
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54)),
                                style: TextStyle(
                                    fontFamily: Constant.fontsFamily,
                                    fontSize: getEdtTextSize(),
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                              ),

                              // getCustomText("Search...", Colors.black54, 1,
                              //     TextAlign.start, FontWeight.w400, getEdtTextSize()),
                              flex: 1,
                            ),
                            ValueListenableBuilder(
                              builder: (context, value, child) {
                                return (filteredList.isNotEmpty)
                                    ? InkWell(
                                        onTap: () {
                                          // setState(() {
                                          searchController.clear();
                                          checkData();
                                          // });
                                        },
                                        child: getSvgImage(
                                            "Close.svg", getEdtIconSize()),
                                      )
                                    : getSpace(0);
                              },
                              valueListenable: valChange,
                            ),
                            getHorSpace(
                                Constant.getPercentSize(screenWidth, 0.8)),
                            InkWell(
                              child:
                                  getSvgImage("filter.svg", getEdtIconSize()),
                              onTap: () {
                                Constant.sendToScreen(
                                    const FilterScreen(), context);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                getSpace(appBarPadding / 2),
                Expanded(
                  child: ValueListenableBuilder(
                    builder: (context, value, child) {
                      return (filteredList.isNotEmpty)
                          ? SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: appBarPadding,
                                            vertical: Constant.getPercentSize(
                                                appBarPadding, 65)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            getSvgImage(
                                                "Rotate_Left.svg", iconSize),
                                            getHorSpace(Constant.getPercentSize(
                                                screenWidth, 2)),
                                            Expanded(
                                              child: getCustomText(
                                                  filteredList[index],
                                                  fontBlack,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.w400,
                                                  Constant.getPercentSize(
                                                      iconSize, 80)),
                                              flex: 1,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: filteredList.length,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: appBarPadding),
                                    child: Divider(color: Colors.grey.shade400),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: appBarPadding),
                                    child: getCustomText(
                                        "Popular Searches",
                                        fontBlack,
                                        1,
                                        TextAlign.start,
                                        FontWeight.bold,
                                        Constant.getPercentSize(
                                            screenHeight, 2.5)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: appBarPadding,
                                        vertical: appBarPadding),
                                    child: Wrap(
                                      spacing: 6.0,
                                      runSpacing: 6.0,
                                      children: List.generate(
                                          popularSearchList.length, (index) {
                                        return Container(
                                          decoration: getButtonShapeDecoration(
                                              (selectedSearchList.contains(
                                                      popularSearchList[index]))
                                                  ? primaryColor
                                                  : primaryColor
                                                      .withOpacity(0.05),
                                              withCustomCorner: true,
                                              corner: Constant.getPercentSize(
                                                  iconSize, 43)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Constant.getPercentSize(
                                                      screenWidth, 3),
                                              vertical: Constant.getPercentSize(
                                                  screenWidth, 2)),
                                          child: getCustomText(
                                              popularSearchList[index],
                                              (selectedSearchList.contains(
                                                      popularSearchList[index]))
                                                  ? Colors.white
                                                  : primaryColor,
                                              1,
                                              TextAlign.center,
                                              FontWeight.w400,
                                              Constant.getPercentSize(
                                                  iconSize, 63)),
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Center(
                              child: SingleChildScrollView(
                                child: getEmptyWidget(
                                    "empty_search.svg",
                                    "No Searches",
                                    "You have no recent searches.",
                                    "",
                                    () {},
                                    withButton: false),
                              ),
                            );
                    },
                    valueListenable: valChange,
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
