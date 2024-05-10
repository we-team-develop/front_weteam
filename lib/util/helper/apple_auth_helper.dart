import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'auth_helper.dart';

class AppleAuthHelper extends AuthHelper {
  @override
  Future<String?> getToken() async {
    if (!(await isLoggedIn())) {
      debugPrint("AppleAuthHelper: getToken이 호출되었지만 로그인 상태가 아님");
      return null;
    }

    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  Future<bool> login() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email'); // 이메일 요구
    appleProvider.addScope('name'); // 이름 요구
    try {
      await FirebaseAuth.instance.signInWithProvider(appleProvider);
    } catch (e, st) {
      debugPrint("$e");
      debugPrintStack(stackTrace: st);
      return false;
    }
    return true;
  }

  @override
  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  WeteamAuthProvider getProvider() {
    return WeteamAuthProvider.apple;
  }
}
