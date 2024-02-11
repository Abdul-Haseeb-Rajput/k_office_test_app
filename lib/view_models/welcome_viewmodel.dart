import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:k_office_test_app/app/app.locator.dart';
import 'package:k_office_test_app/app/app.router.dart';
import 'package:k_office_test_app/services/shared_prefs_service.dart';
import 'package:k_office_test_app/utils/constants/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class WelcomeViewModel extends BaseViewModel {
  @override
  void dispose() {
    emailController.dispose();
    emailController.clear();
    super.dispose();
  }

  // Navigation service object
  final navigationService = locator<NavigationService>();
  // shared preference singleton object
  final sharedPrefs = locator<SharedPrefsService>();

  // email controller
  final TextEditingController emailController = TextEditingController();

  // form key
  final formKey = GlobalKey<FormState>();

  // firebase auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // login or Signup View
  // check if user with email exists or not
  Future<void> checkUserAndNavigate({required String email}) async {
    if (formKey.currentState!.validate()) {
      try {
        // Attempt to sign in with the provided email
        if (email.isNotEmpty) {
          await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password:
                "temporary_password_82322324", // a temporary password for checking existence
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // print(e.code.toString());
          await sharedPrefs.setEmailValue(
              emailKey: AppStrings.email, email: email);
          // print("email : ${sharedPrefs.getEmailValue(emailKey: AppStrings.email)}");
          navigateToSignupView();
          //
        } else if (e.code.contains("wrong-password")) {
          await sharedPrefs.setEmailValue(
              emailKey: AppStrings.email, email: email);
          navigateToLoginView();
          //
        } else {
          // print("Error: $e");
          Fluttertoast.showToast(msg: e.toString().padRight(20));
        }
      }
    }
  }

  // navigate to login view
  void navigateToLoginView() {
    navigationService.navigateToLoginView();
  }

  // navigate to login view
  void navigateToSignupView() {
    navigationService.navigateToSignupView();
  }
}
