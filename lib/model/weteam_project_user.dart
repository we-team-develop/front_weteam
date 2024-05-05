import 'weteam_user.dart';

class WeteamProjectUser {
  final int id;
  final String? role;
  final bool enable;
  final WeteamUser user;

  const WeteamProjectUser(
      {required this.id,
      required this.role,
      required this.enable,
      required this.user});

  factory WeteamProjectUser.fromJson(Map data) {
    return WeteamProjectUser(
        id: data['id'],
        role: data['role'],
        enable: data['enable'],
        user: WeteamUser.fromJson(data['user']));
  }
}
