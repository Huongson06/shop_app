class Category {
  final int id;
  final String title;
  final String slug;
  final String photo; // Ảnh đại diện của danh mục
  final String description; // Mô tả danh mục
  final bool isParent; // Xác định xem đây có phải danh mục cha không

  // Constructor
  Category({
    required this.id,
    required this.title,
    required this.slug,
    required this.photo,
    required this.description,
    required this.isParent,
  });

  // Factory constructor từ JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] != null ? json['id'] : 0,
      title: json['title'] != null ? json['title'] : '',
      slug: json['slug'] != null ? json['slug'] : '',
      photo: json['photo'] != null ? json['photo'] : '',
      description: json['description'] != null ? json['description'] : '',
      isParent: json['is_parent'] != null ? json['is_parent'] == 1 : false,
    );
  }

  // Phương thức override toString để in ra thông tin chi tiết của Category
  @override
  String toString() {
    return 'Category{id: $id, title: $title, slug: $slug, photo: $photo, description: $description, isParent: $isParent}';
  }
}
