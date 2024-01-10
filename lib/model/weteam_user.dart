class WeteamUser {
  int id;
  String username;
  String email;
  String? organization;
  String? role;

  WeteamUser({
    required this.id,
    required this.username,
    required this.email,
    this.organization,
    this.role
});

  factory WeteamUser.fromJson(Map json) {
    return WeteamUser(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      organization: json['organization'] as String?,
      role: json['role'] as String?
    );
  }
}