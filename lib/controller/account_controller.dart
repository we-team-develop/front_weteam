import 'package:front_weteam/util/api_service.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();

  void login() {
    _firebaseAuth.currentUser?.getIdToken().then((idToken) {
      if (idToken != null) {
        _apiService.authenticateWithIdToken(idToken).then((response) {
          if (response.statusCode == 200) {
            // Handle successful authentication
            print("Authenticated on server side!");
          } else {
            // Handle failure
            print("Failed to authenticate on server side: ${response.body}");
          }
        }).catchError((error) {
          // Handle network errors
          print("Error sending idToken to server: $error");
        });
      } else {
        // Handle the case where idToken is null
        print("Error: idToken is null");
      }
    }).catchError((error) {
      // Handle errors in getting the idToken
      print("Error getting idToken: $error");
    });
  }
}
