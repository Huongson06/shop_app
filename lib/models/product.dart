class Product {
  final int id;
  final String title;
  final double price;
  final List<String> photos;
  final String description;// Đây là danh sách ảnh

  // Constructor
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.photos,
    required this.description,
  });

  // Factory constructor từ JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    // Tách chuỗi ảnh thành danh sách URL
    List<String> photoList = json['photo'] != null
        ? json['photo'].toString().split(',')  // Tách chuỗi ảnh thành danh sách
        : [];

    // Trả về đối tượng Product, xử lý các giá trị null hoặc không hợp lệ
    return Product(
      id: json['id'] != null ? json['id'] : 0,
      title: json['title'] != null ? json['title'] : '',
      price: (json['price'] is num ? json['price'] : 0.0).toDouble(),
      photos: photoList,  // Gán vào thuộc tính photos
      description: json['description'] != null ? json['description'] : '',
    );
  }

  get originalPrice => null;

  get sale => null;


  // Phương thức override toString để in ra thông tin chi tiết của Product
  @override
  String toString() {
    return 'Product{id: $id, title: $title, price: $price, photos: $photos, description: $description}';
  }
}
