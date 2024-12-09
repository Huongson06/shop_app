// ignore: file_names
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/constants/constant.dart';
import 'package:shoplite/constants/data_file.dart';
import 'package:shoplite/constants/size_config.dart';
import 'package:shoplite/constants/widget_utils.dart';
import 'package:shoplite/constants/color_data.dart';
import 'package:shoplite/models/model_banner.dart';
import 'package:shoplite/models/model_category.dart';
import 'package:shoplite/models/model_trending.dart';
import 'package:shoplite/ui/home/home_screen.dart';
import 'package:shoplite/ui/product/all_product_list.dart';
import 'package:shoplite/ui/category/category_list.dart';
import 'package:shoplite/ui/search/search_screen.dart';

import '../../../providers/category_provider.dart';
import '../../../providers/product_provider.dart';
import '../../product/product_detail.dart';

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabHome();
  }
}

class _TabHome extends State<TabHome> {
  List<ModelBanner> bannerList = DataFile.getAllBanner();
  int selectedSlider = 0;

  getTitleWidget(double padding, String txt, Function function) {
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: Constant.getPercentSize(screenHeight, 1.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getCustomText(txt, fontBlack, 1, TextAlign.start, FontWeight.w800,
              Constant.getPercentSize(screenHeight, 3)),
          InkWell(
            onTap: () {
              function();
            },
            child: getCustomText("View all", primaryColor, 1, TextAlign.start,
                FontWeight.w400, Constant.getPercentSize(screenHeight, 2.3)),
          )
        ],
      ),
    );
  }

  List<ModelCategory> catList = DataFile.getAllCategory();
  List<ModelTrending> trendingList = DataFile.getAllTrendingProduct();
  List<ModelTrending> popularList = DataFile.getAllPopularProduct();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double appbarPadding = getAppBarPadding();
    double iconSize = Constant.getPercentSize(screenHeight, 3);
    double carousalHeight = Constant.getPercentSize(screenWidth, 42);
    double categoryHeight = Constant.getPercentSize(screenHeight, 25);
    double categoryWidth = Constant.getPercentSize(categoryHeight, 58);
    double trendingHeight = Constant.getPercentSize(screenHeight, 42);
    double trendingWidth = Constant.getPercentSize(trendingHeight, 75);

    double marginPopular = appbarPadding;
    int crossAxisCountPopular = 2;
    double popularWidth =
        (screenWidth - ((crossAxisCountPopular - 1) * marginPopular)) /
            crossAxisCountPopular;
    // var _width = ( _screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;

    double popularHeight = trendingHeight;

    final List<Widget> imageSliders = bannerList
        .map((item) => SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Container(
                decoration: ShapeDecoration(
                    shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius:
                                Constant.getPercentSize(carousalHeight, 8),
                            cornerSmoothing: 0.2))),
                // margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(
                        Constant.getPercentSize(carousalHeight, 8))),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                          Constant.assetImagePath + item.image!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),

                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal:
                        //           Constant.getPercentSize(screenWidth, 4.5)),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       getCustomTextWithoutMaxLine(
                        //           item.title!,
                        //           Colors.white,
                        //           TextAlign.start,
                        //           FontWeight.w500,
                        //           Constant.getPercentSize(carousalHeight, 17),
                        //           txtHeight: 1.2)
                        //     ],
                        //   ),
                        // ),
                      ],
                    )),
              ),
            ))
        .toList();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: primaryColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: appbarPadding),
            child: AppBar(
              elevation: 0,
              backgroundColor: primaryColor,
              leadingWidth: Constant.getPercentSize(screenHeight, 18),
              leading: Builder(
                builder: (context) {
                  return Image.asset(
                    Constant.assetImagePath + "logo.png",
                    height: Constant.getPercentSize(screenHeight, 4),
                  );
                },
              ),
              actions: [
                InkWell(
                  child: getSvgImage("Bag.svg", iconSize, color: Colors.white),
                  onTap: () {
                    Constant.sendToScreen(HomeScreen(selectedTab: 2), context);
                  },
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: appbarPadding,
                right: appbarPadding,
                bottom: appbarPadding * 1.5,
                top: Constant.getPercentSize(appbarPadding, 30)),
            width: double.infinity,
            height: getEditHeight(),
            padding: EdgeInsets.symmetric(
                horizontal: Constant.getPercentSize(screenWidth, 3)),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: getCorners(),
                        cornerSmoothing: getCornerSmoothing()))),
            child: InkWell(
              onTap: () {
                Constant.sendToScreen(const SearchScreen(), context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getSvgImage("Search.svg", getEdtIconSize()),
                  getHorSpace(Constant.getPercentSize(screenWidth, 2)),
                  Expanded(
                    child: getCustomText("Search...", Colors.black54, 1,
                        TextAlign.start, FontWeight.w400, getEdtTextSize()),
                    flex: 1,
                  ),
                  getSvgImage("filter.svg", getEdtIconSize()),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: backgroundColor,
              width: double.infinity,
              height: double.infinity,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            Expanded(
                              child: CarouselSlider(
                                options: CarouselOptions(
                                    autoPlay: true,
                                    // viewportFraction:0.85,
                                    // aspectRatio: 1.8,
                                    // viewportFraction: 0.8,
                                    height: double.infinity,
                                    enlargeCenterPage: true,
                                    disableCenter: true,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        selectedSlider = index;
                                      });
                                    }),
                                items: imageSliders,
                              ),
                              flex: 1,
                            ),
                            DotsIndicator(
                              dotsCount: imageSliders.length,
                              position: selectedSlider,
                              decorator: DotsDecorator(
                                size: const Size(7, 7),
                                activeSize: const Size(7, 7),
                                color: primaryColor.withOpacity(0.3),
                                activeColor: primaryColor,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    height: carousalHeight + 10,
                    margin: EdgeInsets.only(
                        top: Constant.getPercentSize(screenHeight, 2)),
                  ),
                  getTitleWidget(appbarPadding, "Categories", () {
                    Constant.sendToScreen(const CategoryList(), context);
                  }),
                  SizedBox(
                    width: double.infinity,
                    height: categoryHeight,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final categoryListAsync =
                            ref.watch(categoryListProvider);

                        return categoryListAsync.when(
                          data: (categories) {
                            return ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                double itemMargin =
                                    Constant.getPercentSize(categoryHeight, 4);

                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const CategoryList(),
                                    ));
                                  },
                                  child: Container(
                                    width: categoryWidth,
                                    margin: (index == 0)
                                        ? EdgeInsets.only(
                                            left: appbarPadding,
                                            right: itemMargin,
                                            top: itemMargin,
                                            bottom: itemMargin,
                                          )
                                        : EdgeInsets.all(itemMargin),
                                    height: double.infinity,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: ShapeDecoration(
                                              shape: SmoothRectangleBorder(
                                                borderRadius:
                                                    SmoothBorderRadius(
                                                  cornerRadius:
                                                      Constant.getPercentSize(
                                                          categoryHeight, 50),
                                                  cornerSmoothing: 0.8,
                                                ),
                                              ),
                                              color: Colors.transparent,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Constant.getPercentSize(
                                                    categoryHeight, 50),
                                              ),
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[
                                                      200], // Màu nền khi ảnh không tải được
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        _getImageUrl(
                                                            category.photo)),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          flex: 1,
                                        ),
                                        getSpace(Constant.getPercentSize(
                                            categoryHeight, 6)),
                                        getCustomText(
                                          category.title,
                                          fontBlack,
                                          1,
                                          TextAlign.center,
                                          FontWeight.w700,
                                          Constant.getPercentSize(
                                              categoryHeight, 9),
                                        ),
                                        getSpace(Constant.getPercentSize(
                                            categoryHeight, 4)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: categories.length,
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) => Center(
                            child: Text('Error: ${error.toString()}'),
                          ),
                        );
                      },
                    ),
                  ),
                  getTitleWidget(appbarPadding, "Trending Products", () {
                    Constant.sendToScreen(const AllProductList(), context);
                  }),
                  SizedBox(
                    width: double.infinity,
                    height: trendingHeight,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final trendingProductListAsync =
                            ref.watch(productListProvider);
                        return trendingProductListAsync.when(
                          data: (products) {
                            return ListView.builder(
                              primary: false,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final photos = product.photos;
                                double itemMargin =
                                    Constant.getPercentSize(trendingHeight, 4);

                                return InkWell(
                                  onTap: () {
                                    Constant.sendToScreen(
                                      ProductDetail(product: product),
                                      context,
                                    );
                                  },
                                  child: Container(
                                    height: double.infinity,
                                    width: trendingWidth,
                                    padding: EdgeInsets.all(
                                        Constant.getPercentSize(
                                            trendingHeight, 3.3)),
                                    margin: (index == 0)
                                        ? EdgeInsets.only(
                                            left: appbarPadding,
                                            right: itemMargin,
                                            top: itemMargin,
                                            bottom: itemMargin,
                                          )
                                        : EdgeInsets.all(itemMargin),
                                    decoration: ShapeDecoration(
                                        color: cardColor,
                                        shape: SmoothRectangleBorder(
                                            borderRadius: SmoothBorderRadius(
                                                cornerRadius:
                                                    Constant.getPercentSize(
                                                        trendingHeight, 4),
                                                cornerSmoothing: 0.5)),
                                        shadows: [
                                          BoxShadow(
                                              color: shadowColor,
                                              spreadRadius: 1.2,
                                              blurRadius: 2)
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              // Ảnh sản phẩm
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Constant.getPercentSize(
                                                            trendingHeight, 4)),
                                                child: photos.isNotEmpty
                                                    ? Image.network(
                                                        _getImageUrl(photos[0]),
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Icon(
                                                            Icons.broken_image,
                                                            size: 80,
                                                            color: Colors.grey,
                                                          );
                                                        },
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size: 80,
                                                        color: Colors.grey,
                                                      ),
                                              ),
                                              // Icon yêu thích
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          flex: 1,
                                        ),
                                        getSpace(Constant.getPercentSize(
                                            trendingHeight, 5)),
                                        // Tên sản phẩm
                                        getCustomText(
                                          product.title ?? "",
                                          fontBlack,
                                          1,
                                          TextAlign.start,
                                          FontWeight.bold,
                                          Constant.getPercentSize(
                                              trendingHeight, 5.5),
                                        ),
                                        getSpace(Constant.getPercentSize(
                                            trendingHeight, 2.5)),
                                        // Giá sản phẩm
                                        Row(
                                          children: [
                                            getCustomText(
                                              "${product.price.toStringAsFixed(3)} VNĐ",
                                              fontBlack,
                                              1,
                                              TextAlign.start,
                                              FontWeight.normal,
                                              Constant.getPercentSize(
                                                  trendingHeight, 5.5),
                                            ),
                                            if (product.originalPrice != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: Text(
                                                  "${product.originalPrice.toStringAsFixed(3)} VNĐ",
                                                  style: const TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 12,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: products.length,
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) =>
                              Center(child: Text('Error: ${error.toString()}')),
                        );
                      },
                    ),
                  ),
                  getTitleWidget(appbarPadding, "Popular Products", () {
                    Constant.sendToScreen(const AllProductList(), context);
                  }),
                  Consumer(
                    builder: (context, ref, child) {
                      final productListAsync = ref.watch(productListProvider);

                      return productListAsync.when(
                        data: (products) {
                          return GridView.builder(
                            padding: EdgeInsets.all(marginPopular),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCountPopular,
                              crossAxisSpacing: marginPopular,
                              mainAxisSpacing: marginPopular,
                              childAspectRatio: popularWidth / popularHeight,
                            ),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return InkWell(
                                onTap: () {
                                  Constant.sendToScreen(
                                    ProductDetail(product: product),
                                    context,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Hình ảnh sản phẩm
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                          child: product.photos.isNotEmpty
                                              ? Image.network(
                                            _getImageUrl(product.photos[0]),
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                                size: 80,
                                                color: Colors.grey,
                                              );
                                            },
                                          )
                                              : const Icon(
                                            Icons.image_not_supported,
                                            size: 80,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      // Tiêu đề sản phẩm
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        child: Text(
                                          product.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      // Giá sản phẩm
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          "${product.price.toStringAsFixed(3)} VNĐ",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8), // Khoảng cách dưới
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Center(child: Text('Error: ${error.toString()}')),
                      );
                    },
                  ),


                ],
              ),
            ),
          )
          // Container(
          //   decoration:,
          // )
        ],
      ),
    );
  }
}

String _getImageUrl(String url) {
  if (url.contains('127.0.0.1') || url.contains('localhost')) {
    return url
        .replaceAll('127.0.0.1', '10.0.2.2')
        .replaceAll('localhost', '10.0.2.2');
  }
  return url;
}
