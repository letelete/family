import 'package:firebase_auth/firebase_auth.dart';

class User {
  String id;
  String name;
  String photoUrl;
  User({this.id, this.name, this.photoUrl});

  User.initial()
      : id = '',
        name = '',
        photoUrl = '';

  User.fromFirebaseUser(FirebaseUser user)
      : id = user.providerId,
        name = user.displayName,
        photoUrl = user.photoUrl;
}
