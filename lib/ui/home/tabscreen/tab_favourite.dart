import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoplite/providers/product_provider.dart';
import 'package:shoplite/ui/product/product_detail.dart';
import 'package:shoplite/ui/search/filter_screen.dart';
import '../../../constants/apilist.dart';
import '../../../constants/constant.dart';
import '../../../constants/size_config.dart';
import '../../../constants/widget_utils.dart';

class TabFavourite extends StatefulWidget {
  const TabFavourite({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabFavourite();
  }
}

class _TabFavourite extends State<TabFavourite> {
  late List<int> favouriteIds; // Lưu danh sách ID sản phẩm yêu thích
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    favouriteIds = [];
    _loadFavourites(); // Load danh sách yêu thích từ SharedPreferences
  }

  /// Hàm load danh sách ID sản phẩm yêu thích dựa trên token
  Future<void> _loadFavourites() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      // Sử dụng token để lấy danh sách yêu thích riêng của người dùng
      favouriteIds = prefs.getStringList('${g_token}_favouriteIds')
          ?.map((id) => int.parse(id))
          .toList() ??
          [];
    });
  }

  /// Hàm lưu danh sách ID sản phẩm yêu thích theo token
  Future<void> _saveFavourites() async {
    await prefs.setStringList(
        '${g_token}_favouriteIds', favouriteIds.map((id) => id.toString()).toList());
  }

  /// Hiển thị thông báo Snackbar
  void _showSnackbar(String message, bool isAdded) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isAdded ? Colors.green : Colors.red,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double marginPopular = 10;
    int crossAxisCountPopular = 2;
    double popularWidth =
        (screenWidth - ((crossAxisCountPopular - 1) * marginPopular)) / crossAxisCountPopular;
    double popularHeight = popularWidth * 1.3;

    return Consumer(
      builder: (context, ref, child) {
        final productListAsync = ref.watch(productListProvider);

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: Column(
            children: [
              // Header
              Container(
                color: const Color(0xFF007B66),
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "My Favourite",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search...",
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.white),
                          onPressed: () {
                            Constant.sendToScreen(const FilterScreen(), context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Danh sách yêu thích
              Expanded(
                child: productListAsync.when(
                  data: (products) {
                    final favouriteProducts = products
                        .where((product) => favouriteIds.contains(product.id))
                        .toList();

                    return favouriteProducts.isNotEmpty
                        ? GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCountPopular,
                        crossAxisSpacing: marginPopular,
                        mainAxisSpacing: marginPopular,
                        childAspectRatio: popularWidth / popularHeight,
                      ),
                      itemCount: favouriteProducts.length,
                      itemBuilder: (context, index) {
                        final favouriteProduct = favouriteProducts[index];
                        final isFavourite = favouriteIds.contains(favouriteProduct.id);

                        return InkWell(
                          onTap: () {
                            Constant.sendToScreen(
                              ProductDetail(product: favouriteProduct),
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
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        _getImageUrl(
                                          favouriteProduct.photos.isNotEmpty
                                              ? favouriteProduct.photos[0]
                                              : 'https://via.placeholder.com/150',
                                        ),
                                        width: double.infinity,
                                        height: 170,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: IconButton(
                                        icon: Icon(
                                          isFavourite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFavourite ? Colors.red : Colors.grey,
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            if (isFavourite) {
                                              favouriteIds.remove(favouriteProduct.id);
                                            } else {
                                              favouriteIds.add(favouriteProduct.id);
                                            }
                                          });
                                          await _saveFavourites();
                                          _showSnackbar(
                                            isFavourite
                                                ? "Đã xóa sản phẩm khỏi danh sách yêu thích"
                                                : "Đã thêm sản phẩm vào danh sách yêu thích",
                                            !isFavourite,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    favouriteProduct.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "${favouriteProduct.price.toStringAsFixed(3)} VNĐ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                        : const Center(child: Text("Không có sản phẩm yêu thích"));
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      Center(child: Text('Error: ${error.toString()}')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Hàm chuyển đổi URL ảnh phù hợp với môi trường
  String _getImageUrl(String url) {
    if (url.contains('127.0.0.1') || url.contains('localhost')) {
      return url.replaceAll('127.0.0.1', '10.0.2.2').replaceAll('localhost', '10.0.2.2');
    }
    return url;
  }
}
