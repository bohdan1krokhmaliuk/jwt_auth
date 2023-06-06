class UserDetails {
  const UserDetails(this.id);
  const UserDetails.empty() : id = null;

  final int? id;
}

class User {
  const User({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.createdAt,
  });

  final int id;
  final String email;
  final DateTime createdAt;
  final String passwordHash;
}
