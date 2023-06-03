class User {
  User({
    required this.id,
    required this.email,
    required this.authHash,
    required this.createdAt,
  });

  final int id;
  final String email;
  final String authHash;
  final DateTime createdAt;
}
