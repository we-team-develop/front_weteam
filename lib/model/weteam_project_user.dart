import 'package:front_weteam/model/weteam_user.dart';

class WeteamProjectUser {
  final int id;
  final String? role;
  final WeteamUser user;

  const WeteamProjectUser(
      {required this.id, required this.role, required this.user});

  factory WeteamProjectUser.fromJson(Map data) {
    return WeteamProjectUser(
        id: data['id'],
        role: data['role'],
        user: WeteamUser.fromJson(data['user']));
  }
}
