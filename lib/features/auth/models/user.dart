class User {
  final String id;
  final String email;
  final String? phone;
  final String createdAt;

  const User({
    required this.id,
    required this.email,
    this.phone,
    required this.createdAt,
  });
}
