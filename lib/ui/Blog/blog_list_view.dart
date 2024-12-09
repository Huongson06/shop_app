import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/providers/blog_provider.dart'; // Chỉnh lại theo đúng đường dẫn
import 'package:shoplite/ui/Blog/blog_detail.dart'; // Chỉnh lại theo đúng đường dẫn

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

class BlogListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theo dõi trạng thái của `blogListProvider`
    final blogListAsync = ref.watch(blogListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor, // Màu xanh lá cây đậm cho topbar
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.white, // Vòng tròn màu trắng
            radius: 15,
            child: Icon(
              Icons.arrow_back,
              color: primaryColor, // Màu xanh lá cây cho mũi tên
            ),
          ),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
        title: const Text(
          'Blogs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true, // Căn giữa tiêu đề
        elevation: 0, // Loại bỏ bóng của AppBar
      ),
      body: blogListAsync.when(
        data: (blogs) {
          List uniqueBlogs = [];
          Set<int> seenIds = Set();

          for (var blog in blogs) {
            if (!seenIds.contains(blog.id)) {
              uniqueBlogs.add(blog);
              seenIds.add(blog.id);
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10), // Thêm padding cho danh sách
            itemCount: uniqueBlogs.length, // Sử dụng số lượng blog không trùng lặp
            itemBuilder: (context, index) {
              final blog = uniqueBlogs[index];
              final photos = blog.photos;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10), // Khoảng cách giữa các item
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bo góc
                  side: BorderSide(color: shadowColor, width: 1),
                ),
                color: cardColor, // Màu nền card
                elevation: 5, // Thêm bóng cho card
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 15), // Padding cho nội dung
                  leading: photos.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Bo góc ảnh
                    child: Image.network(
                      _getImageUrl(photos[0]), // Sử dụng hàm xử lý URL
                      width: 60, // Kích thước ảnh
                      height: 60, // Kích thước ảnh
                      fit: BoxFit.cover, // Đảm bảo ảnh không bị méo
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // Khi ảnh đã tải xong
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes !=
                                null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ??
                                    1)
                                : null,
                          ),
                        ); // Khi ảnh đang tải
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image,
                            size: 60); // Hiển thị khi có lỗi tải ảnh
                      },
                    ),
                  )
                      : const Icon(Icons.image_not_supported, size: 60), // Hiển thị khi không có ảnh
                  title: Text(
                    blog.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: fontBlack, // Màu chữ đậm
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5), // Khoảng cách giữa mô tả và nội dung
                      Text(
                        blog.summary,
                        style: TextStyle(color: greyFont), // Màu chữ xám
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey, // Màu mũi tên
                  ), // Nút dẫn đến trang chi tiết
                  onTap: () {
                    // Chuyển tới trang chi tiết bài viết và truyền dữ liệu
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetail(blog: blog), // Truyền dữ liệu bài viết
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
      backgroundColor: backgroundColor, // Màu nền gần như trắng hoàn toàn
    );
  }

  /// Xử lý URL để hoạt động trên giả lập Android
  String _getImageUrl(String url) {
    if (url.contains('127.0.0.1') || url.contains('localhost')) {
      return url.replaceAll('127.0.0.1', '10.0.2.2').replaceAll('localhost', '10.0.2.2');
    }
    return url;
  }
}
