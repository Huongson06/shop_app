class Blog {
  final int id;
  final String title;
  final String summary;
  final List<String> photos;  // Danh sách ảnh
  final String content;

  // Constructor
  Blog({
    required this.id,
    required this.title,
    required this.summary,
    required this.photos,
    required this.content,
  });

  // Factory constructor từ JSON
  factory Blog.fromJson(Map<String, dynamic> json) {
    // Tách chuỗi ảnh thành danh sách URL (nếu có nhiều ảnh, bạn có thể tách chuỗi)
    List<String> photoList = json['photo'] != null
        ? json['photo'].toString().split(',')  // Tách chuỗi ảnh thành danh sách
        : [];

    return Blog(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      photos: photoList,  // Gán vào thuộc tính photos
    );
  }

  // Phương thức override toString để in ra thông tin chi tiết của Blog
  @override
  String toString() {
    return 'Blog{id: $id, title: $title, summary: $summary, photos: $photos, content: $content}';
  }
}
