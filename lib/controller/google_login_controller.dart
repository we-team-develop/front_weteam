import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLoggedIn = false.obs; // 로그인 상태 변수

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      firebaseUser.value = user;
      isLoggedIn.value = user != null; // 업데이트 isLoggedIn 상태
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Get.snackbar("로그인 실패", "Google 로그인이 취소되었습니다.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.snackbar("로그인 성공", "Google 로그인에 성공했습니다.");
    } catch (e) {
      Get.snackbar("로그인 에러", "로그인 중 오류가 발생했습니다: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
