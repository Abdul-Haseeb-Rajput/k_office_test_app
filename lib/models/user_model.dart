class UserModel {
  String? uid;
  String? email;
  String? displayName;
  String? profileUrl;

  UserModel({this.uid, this.email, this.displayName, this.profileUrl});

  // receiving data from firebase
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      profileUrl: map['profileUrl'],
    );
  }

  // sending data to firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'profileUrl': profileUrl,
    };
  }
}
