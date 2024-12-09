import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/providers/category_provider.dart';
import '../../../constants/color_data.dart';
import '../../../constants/constant.dart';
import '../../../constants/size_config.dart';
import '../../constants/widget_utils.dart';

class CategoryList extends ConsumerStatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends ConsumerState<CategoryList> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double marginPopular = 10;
    int crossAxisCountPopular = 2;
    double popularWidth =
        (screenWidth - ((crossAxisCountPopular - 1) * marginPopular)) /
            crossAxisCountPopular;
    double popularHeight = popularWidth * 1.2;

    return Consumer(
      builder: (context, ref, child) {
        final categoryListAsync = ref.watch(categoryListProvider);

        return WillPopScope(
          onWillPop: () async {
            Constant.backToFinish(context);
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            body: Column(
              children: [
                getDefaultHeader(
                  context,
                  "Category",
                      () {
                    Constant.backToFinish(context);
                  },
                      (value) {},
                  withFilter: false, // Không cần bộ lọc
                ),
                Expanded(
                  child: categoryListAsync.when(
                    data: (categories) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCountPopular,
                          crossAxisSpacing: marginPopular,
                          mainAxisSpacing: marginPopular,
                          childAspectRatio: popularWidth / popularHeight,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];

                          return InkWell(
                            onTap: () {
                              // Xử lý sự kiện click vào danh mục
                            },
                            child: Column(
                              children: [
                                // Hình ảnh danh mục bo góc kiểu elip
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20), // Tạo góc bo elip
                                  child: Container(
                                    width: popularWidth * 0.7,
                                    height: popularWidth * 0.7,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200], // Nền cho ảnh nếu không tải được
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          _getImageUrl(category.photo),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Tên danh mục
                                Text(
                                  category.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                    const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) =>
                        Center(child: Text('Error: ${error.toString()}')),
                  ),
                ),
              ],
            ),
          ),
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
}
