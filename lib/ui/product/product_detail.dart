import 'package:flutter/material.dart';
import 'package:shoplite/models/product.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 1;
  String selectedSize = "S";
  String selectedColor = "Green";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(),
                const SizedBox(height: 20),
                _buildProductInfo(),
                const SizedBox(height: 20),
                _buildDescription(),
                const SizedBox(height: 100), // Chừa không gian cho nút cố định
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildAddToCartButton(context),
          ),
        ],
      ),
      backgroundColor: "#F9F9F9".toColor(),
    );
  }

  /// AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: "#146C62".toColor(),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Product Details',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  /// Hình ảnh sản phẩm
  Widget _buildProductImage() {
    return Center(
      child: widget.product.photos.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          _getImageUrl(widget.product.photos[0]),
          height: 250,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 100);
          },
        ),
      )
          : const Icon(Icons.image_not_supported, size: 100),
    );
  }

  /// Thông tin sản phẩm
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          widget.product.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '\$${widget.product.price.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 5),
            Text(
              "4.2",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              "(425 Reviews)",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            _buildQuantitySelector(),
          ],
        ),
      ],
    );
  }

  /// Bộ chọn số lượng
  Widget _buildQuantitySelector() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              if (quantity > 1) quantity--;
            });
          },
          icon: const Icon(Icons.remove),
          color: "#146C62".toColor(),
        ),
        Text(
          quantity.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              quantity++;
            });
          },
          icon: const Icon(Icons.add),
          color: "#146C62".toColor(),
        ),
      ],
    );
  }



  /// Mô tả sản phẩm
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Description",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          widget.product.description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  /// Nút Add to Cart
  Widget _buildAddToCartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added to cart!')),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: "#146C62".toColor(),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: const Text(
        "Add to Cart",
        style:
        TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  /// Thay đổi URL để hoạt động trên giả lập Android
  String _getImageUrl(String url) {
    if (url.contains('127.0.0.1') || url.contains('localhost')) {
      return url.replaceAll('127.0.0.1', '10.0.2.2').replaceAll('localhost', '10.0.2.2');
    }
    return url;
  }
}

/// Extension để chuyển từ mã màu hoặc tên màu thành Color
extension ColorExtension on String {
  toColor() {
    Map<String, String> colorMap = {
      "Green": "#146C62",
      "Yellow": "#FFEB3B",
      "Purple": "#9C27B0",
      "Blue": "#2196F3",
      "Orange": "#FF9800",
    };

    // Kiểm tra nếu chuỗi là một tên màu
    if (colorMap.containsKey(this)) {
      return colorMap[this]!.toColor();
    }

    // Nếu là mã HEX, chuyển thành Color
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }

    // Trả về màu đen nếu không hợp lệ
    return Colors.black;
  }
}
