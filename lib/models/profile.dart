class Profile {
  String full_name;
  String phone;
  String address;
  String photo;
  String email;
  String username;

  Profile({
    required this.full_name,
    required this.phone,
    required this.address,
    required this.photo,
    required this.email,
    required this.username,
  });

  // Tạo phương thức từ JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      full_name: json['full_name'],
      phone: json['phone'],
      address: json['address'],
      photo: json['avatar_url'],
      email: json['email'],
      username: json['username'],
    );
  }

  // Chuyển đổi Profile thành JSON
  Map<String, dynamic> toJson() {
    return {
      'full_name': full_name,
      'phone': phone,
      'address': address,
      'avatar_url': photo,
      'username': username,
      'email': email,
    };
  }

  Profile copyWith({
    String? full_name,
    String? phone,
    String? address,
    String? photo,
    String? email,
    String? username,
  }) {
    return Profile(
      full_name: full_name ?? this.full_name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photo: photo ?? this.photo,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }
}
