import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_helper.dart';

class GoogleAuthHelper extends AuthHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<String?> getToken() async {
    if (!await isLoggedIn()) {
      debugPrint("토큰 얻지 못함: 로그인 상태가 아님");
      return null;
    }

    return _auth.currentUser?.getIdToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  @override
  Future<bool> login() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      debugPrint("로그인 실패: Google 로그인이 취소되었습니다.");
      return false;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    debugPrint("로그인 성공: Google 로그인에 성공했습니다.");
    return true;
  }

  @override
  Future<bool> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();

    return true;
  }
}