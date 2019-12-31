import 'package:family/core/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Api {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Asynchronously sings in user into his Google account.
  ///
  /// Returns [User] model converted from [FirebaseUser] object on successful authentication,
  /// else pops up google accounts selection dialog and verifies choosen credentials.
  /// Returns @nullable [User] at the end. If null, user could not be fetched.
  Future<User> getUserProfile() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();

    if (firebaseUser != null) {
      return User.fromFirebaseUser(firebaseUser);
    }

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    firebaseUser = (await _firebaseAuth.signInWithCredential(credential)).user;

    return User.fromFirebaseUser(firebaseUser);
  }

  /// Asynchronously logs out currently authenticated user and returns its [User] model.
  ///
  /// If null, user has been successfully signed out,
  /// else the returned [User] model is a currently signed user data.
  Future<User> getLoggedOutUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    if (firebaseUser != null) {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      firebaseUser = null;
    }
    return User.fromFirebaseUser(firebaseUser);
  }
}
