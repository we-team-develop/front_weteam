import 'weteam_user.dart';

/// 로그인 결과에 대한 정보를 담습니다.
class LoginResult {
  /// 유저 데이터
  final WeteamUser? user;
  /// 로그인 성공 여부
  final bool isSuccess;
  /// 새로운 유저 여부
  final bool isNewUser;

  const LoginResult(
      {required this.isSuccess, this.isNewUser = false, this.user});
}