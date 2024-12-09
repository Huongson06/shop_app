import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/providers/product_provider.dart';
import 'package:shoplite/ui/product/product_detail.dart';

import '../../../constants/color_data.dart';

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class ProductListView extends StatefulWidget {
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  late List uniqueProducts;
  late Set<int> seenIds;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final productListAsync = ref.watch(productListProvider);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF00796B),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Danh sách sản phẩm',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: productListAsync.when(
            data: (products) {
              uniqueProducts = [];
              seenIds = Set();

              for (var product in products) {
                if (!seenIds.contains(product.id)) {
                  uniqueProducts.add(product);
                  seenIds.add(product.id);
                }
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: uniqueProducts.length,
                itemBuilder: (context, index) {
                  final product = uniqueProducts[index];
                  final photos = product.photos;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: shadowColor,
                        width: 1.0,
                      ),
                    ),
                    color: cardColor,
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      leading: photos.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          _getImageUrl(photos[0]),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          loadingBuilder:
                              (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress
                                    .expectedTotalBytes !=
                                    null
                                    ? loadingProgress
                                    .cumulativeBytesLoaded /
                                    (loadingProgress
                                        .expectedTotalBytes ??
                                        1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image,
                                size: 60);
                          },
                        ),
                      )
                          : const Icon(Icons.image_not_supported, size: 60),
                      title: Text(
                        product.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: fontBlack,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            '${product.price.toStringAsFixed(3)} VNĐ',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetail(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('Error: ${error.toString()}'),
            ),
          ),
          backgroundColor: backgroundColor,
        );
      },
    );
  }

  /// Thay đổi URL để hoạt động trên giả lập Android
  String _getImageUrl(String url) {
    if (url.contains('127.0.0.1') || url.contains('localhost')) {
      return url
          .replaceAll('127.0.0.1', '10.0.2.2')
          .replaceAll('localhost', '10.0.2.2');
    }
    return url;
  }

  @override
  void deactivate() {
    super.deactivate();
    print('deactivate: State bị loại bỏ khỏi cây widget');
  }

  @override
  void dispose() {
    print('dispose: State bị hủy, giải phóng tài nguyên');
    super.dispose();
  }
}
