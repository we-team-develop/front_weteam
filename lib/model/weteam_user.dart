import './weteam_profile.dart';

class WeteamUser {
  int id;
  String? username;
  String? email; // 서버에 말해야함
  String? organization;
  String? role;
  WeteamProfile? profile;

  WeteamUser(
      {required this.id,
      required this.username,
      required this.email,
      this.organization,
      this.role,
      this.profile});

  factory WeteamUser.fromJson(Map json) {
    WeteamProfile? profile;
    if (json['profile'] != null) {
      profile = WeteamProfile.fromJson(json['profile']);
    }

    return WeteamUser(
        id: json['id'] as int,
        username: json['username'] as String,
        email: json['email'] as String?,
        organization: json['organization'] as String?,
        role: json['role'] as String?,
        profile: profile);
  }

  @override
  bool operator ==(Object other) {
    if (other.hashCode == hashCode) return true;
    return other is WeteamUser &&
        id == other.id &&
        username == other.username &&
        email == other.email &&
        organization == other.organization &&
        role == other.role &&
        profile == other.profile;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(id, username, email, organization, role, profile);

}
