class User {
  final String username;
  final String avatarUrl;
  final int followers;

  User({required this.username, required this.avatarUrl, required this.followers});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['login'],
      avatarUrl: json['avatar_url'],
      followers: json['followers'] ?? 0,
    );
  }
}