import 'package:flutter/material.dart';
import 'package:shoplite/constants/color_data.dart';
import 'package:shoplite/models/blog.dart'; // Chỉnh lại theo đúng đường dẫn

class BlogDetail extends StatelessWidget {
  final Blog blog;

  BlogDetail({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: "#146C62".toColor(), // Màu sắc của AppBar, có thể thay bằng mã hex khác
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Nút back
          onPressed: () => Navigator.pop(context), // Quay lại màn hình trước đó
        ),
        title: Text(
          blog.title, // Thay thế 'Product Details' bằng tiêu đề blog
          style: const TextStyle(
            fontSize: 20, // Cỡ chữ tiêu đề
            fontWeight: FontWeight.bold, // Chữ đậm
            color: Colors.white, // Màu chữ trắng
          ),
        ),
        centerTitle: true, // Căn giữa tiêu đề
        elevation: 0, // Không có bóng đổ
      ),
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (blog.photos.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Bo góc ảnh
                  child: Image.network(
                    _getImageUrl(blog.photos[0]), // Sử dụng hàm xử lý URL
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return SizedBox(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade300,
                        ),
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                blog.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50, // Nền sáng nhạt
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  blog.summary,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1, color: Colors.grey), // Đường kẻ chia cách
              const SizedBox(height: 10),
              Text(
                blog.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5, // Tăng khoảng cách giữa các dòng
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
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
