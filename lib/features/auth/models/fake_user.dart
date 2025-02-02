class FakeUser {
  final String id;
  final String email;
  final String? phone;
  final String createdAt;
  final Map<String, dynamic> appMetadata;
  final Map<String, dynamic> userMetadata;

  FakeUser({
    required this.id,
    required this.email,
    this.phone,
    required this.createdAt,
    this.appMetadata = const {},
    this.userMetadata = const {},
  });
}
