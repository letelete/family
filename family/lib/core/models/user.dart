import 'package:firebase_auth/firebase_auth.dart';

class User {
  String id;
  String name;
  String photoUrl;
  User({this.id, this.name, this.photoUrl});

  User.fromFirebaseUser(FirebaseUser user)
      : assert(user != null),
        id = user.uid,
        name = user.displayName,
        photoUrl = user.photoUrl;
}
