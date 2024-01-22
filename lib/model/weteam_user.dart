import 'package:front_weteam/main.dart';

class WeteamUser {
  int id;
  String? username;
  String? email; // 서버에 말해야함
  String? organization;
  String? role;
  int profile = 0;

  WeteamUser(
      {required this.id,
      required this.username,
      required this.email,
      this.organization,
      this.role}) {
   loadProfileFromSharePreferences();
  }

  factory WeteamUser.fromJson(Map json) {
    return WeteamUser(
        id: json['id'] as int,
        username: json['username'] as String,
        email: json['email'] as String?,
        organization: json['organization'] as String?,
        role: json['role'] as String?);
  }

  void loadProfileFromSharePreferences() {
    profile = sharedPreferences.getInt(SharedPreferencesKeys.userProfileIndex) ?? 0;
  }
}
