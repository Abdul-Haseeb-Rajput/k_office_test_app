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

class SignupViewModel extends BaseViewModel {
  //navigation service singleton object
  final navigationService = locator<NavigationService>();
  // shared preference singleton object
  final sharedPrefs = locator<SharedPrefsService>();

  // password editing controller
  final TextEditingController passwordController = TextEditingController();
  // name editing controller
  final TextEditingController nameController = TextEditingController();

  // form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? errorMessage;

  // firebase auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // firebase firestore instance
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  bool obscureText = false;

  // functions

  // show hide password
  void toggleObsecureText() {
    obscureText = !obscureText;
    notifyListeners();
  }

  // signup user function
  Future<void> signUp({required String name, required String password}) async {
    String email = await getEmailValue();
    // print(email);
    if (formKey.currentState!.validate()) {
      try {
        await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((_) => {postDetailsToFirestore()})
            .then(
              (_) => navigateToProfileView(),
            )
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
          // print(e);
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

// password validator
  String passwordValidator(String value) {
    RegExp regex = RegExp(r'^.{6,}$');
    if (value.isEmpty) {
      return ("Password is required for login");
    }
    if (!regex.hasMatch(value)) {
      return ("Enter Valid Password(Min. 6 Character)");
    }
    return ("error");
  }

  // get email address from shared preferences
  Future<String> getEmailValue() async {
    final emailValue =
        await sharedPrefs.getEmailValue(emailKey: AppStrings.email);
    return emailValue;
  }

  // post credentials to firestore
  postDetailsToFirestore() async {
    // calling our firestore

    User? user = _firebaseAuth.currentUser;
    // calling our user model
    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.displayName = nameController.text;
    // sedning these values
    await _fireStore.collection("users").doc(user.email).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");
  }

  // navigate to profile
  void navigateToProfileView() {
    navigationService.replaceWithProfileView();
  }
}
