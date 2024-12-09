import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/providers/category_provider.dart';

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

class CategoryListView extends StatefulWidget {
  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  late List uniqueCategories;
  late Set<int> seenIds;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final categoryListAsync = ref.watch(categoryListProvider);

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
              'Danh sách danh mục',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: categoryListAsync.when(
            data: (categories) {
              uniqueCategories = [];
              seenIds = Set();

              for (var category in categories) {
                if (!seenIds.contains(category.id)) {
                  uniqueCategories.add(category);
                  seenIds.add(category.id);
                }
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: uniqueCategories.length,
                itemBuilder: (context, index) {
                  final category = uniqueCategories[index];

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
                      leading: category.photo.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          _getImageUrl(category.photo),
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
                        category.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: fontBlack,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),

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
