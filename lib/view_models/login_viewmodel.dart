import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:k_office_test_app/app/app.locator.dart';
import 'package:k_office_test_app/app/app.router.dart';
import 'package:k_office_test_app/models/user_model.dart';
import 'package:k_office_test_app/services/shared_prefs_service.dart';
import 'package:k_office_test_app/utils/constants/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  // firestore instance
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // firebase auth insatnce
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // shared prefs instance
  final SharedPrefsService sharedPrefs = locator<SharedPrefsService>();
  // passwordController
  final TextEditingController passwordController = TextEditingController();
  // navigation service
  final NavigationService navigationService = locator<NavigationService>();

  // form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? errorMessage;

  bool obscureText = false;

  // Cached user data
  UserModel? _userData;

  // Getter for user data
  UserModel? get userData => _userData;

  // show hide password
  void toggleObsecureText() {
    obscureText = !obscureText;
    rebuildUi();
  }

//sign in function
  Future<void> signIn({
    required String password,
  }) async {
    final email = await sharedPrefs.getEmailValue(emailKey: AppStrings.email);

    if (formKey.currentState!.validate()) {
      try {
        await firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((_) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  navigateToProfile(),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        // print(error.code);
      }
    }
  }

  // to get user existing email , username and profile image
  Future<void> getUserDetails() async {
    try {
      final userEmail =
          await sharedPrefs.getEmailValue(emailKey: AppStrings.email);

      final DocumentSnapshot userDocument =
          await firebaseFirestore.collection("users").doc(userEmail).get();

      if (userDocument.exists) {
        _userData = UserModel.fromMap(
            userDocument.data() as Map<String, dynamic>); // Cache the user data
        rebuildUi(); // Notify listeners that the data has changed
      }
    } catch (e) {
      // print('Error fetching user details: $e');
      Fluttertoast.showToast(msg: e.toString());
    }
  }

//
  void navigateToProfile() {
    navigationService.replaceWithProfileView();
  }
}
