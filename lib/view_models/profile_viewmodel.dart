import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k_office_test_app/app/app.locator.dart';
import 'package:k_office_test_app/app/app.router.dart';
import 'package:k_office_test_app/models/user_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends BaseViewModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final NavigationService _navigationService = locator<NavigationService>();

  Uint8List? selectedImage;

  // pick Image from gallery
  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      Fluttertoast.showToast(msg: "Image Selected");
      return await file.readAsBytes();
    }
    // print("no image is selected");
  }

  // select picked image
  selectImage() async {
    // Show circular progress indicator
    setBusy(true);

    Uint8List img = await pickImage(ImageSource.gallery);
    selectedImage = img;
    await addProfileToCollection(selectedImage!);
    // Hide circular progress indicator
    setBusy(false);
    selectedImage = null;
    // rebuildUi();
  }

  Future<String> uploadImageToStorage(String fileName, Uint8List file) async {
    final Reference storageRef =
        _firebaseStorage.ref().child("profile images/$fileName");
    UploadTask uploadTask = storageRef.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    // Get the download URL of the uploaded file
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  // update profileurl in firestore

  Future<String> addProfileToCollection(Uint8List file) async {
    String imgUrl =
        await uploadImageToStorage(_firebaseAuth.currentUser!.email!, file);
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(_firebaseAuth.currentUser!.email)
          .set({"profileUrl": imgUrl}, SetOptions(merge: true));
      rebuildUi();
      Fluttertoast.showToast(msg: "image uploaded to firestore");
      return "Success";
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return "failed";
    }
  }

  // stream to get user details from firestore after he uploaded his image to firestore

  // Stream controller and stream
  late final StreamController<UserModel> _userDetailsController =
      StreamController<UserModel>();
  Stream<UserModel> get userDetailsStream => _userDetailsController.stream;

  // Method to subscribe to the stream
  void subscribeToUserDetailsStream() {
    // Get the user details stream and add to the stream controller
    getUserDetailsStream()!.listen((userDetails) {
      // Add the user details to the stream controller
      _userDetailsController.add(userDetails);
    });
  }

  // Method to get the user details as a stream
  Stream<UserModel>? getUserDetailsStream() async* {
    try {
      final userEmail = _firebaseAuth.currentUser!.email!;

      final DocumentSnapshot userDocument =
          await _firebaseFirestore.collection("users").doc(userEmail).get();

      if (userDocument.exists) {
        yield UserModel.fromMap(userDocument.data() as Map<String, dynamic>);
      } else {
        yield UserModel();
      }
    } catch (e) {
      // Handle any error that may occur during the process
      // print('Error fetching user details: $e');
      Fluttertoast.showToast(msg: e.toString());
      yield UserModel();
    }
  }

  // signout function
  Future<void> signOut() async {
    try {
      await _firebaseAuth
          .signOut()
          .then((value) => _navigationService.replaceWith(Routes.welcomeView));
      Fluttertoast.showToast(msg: "successfully signedOut:) ");
    } catch (e) {
      // print('Error signing out: $e');
      Fluttertoast.showToast(msg: "$e:) ");
      // Handle any error during sign-out
    }
  }
}
