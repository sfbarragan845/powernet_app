import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/chat_user.dart';
import '../../../models/share_preferences.dart';
import '../../public/chat/allConstants/all_constants.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  Status _status = Status.uninitialized;

  Status get status => _status;

  AuthProvider({required this.googleSignIn, required this.firebaseAuth, required this.firebaseFirestore, required this.prefs});

  String? getFirebaseUserId() {
    return prefs.getString(FirestoreConstants.id);
  }

  String? getFirebaseDisplayName() {
    return prefs.getString(FirestoreConstants.displayName);
  }

  String? getFirebaseCorreo() {
    return prefs.getString(FirestoreConstants.email);
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn && prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> handleGoogleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result =
            await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where(FirestoreConstants.id, isEqualTo: firebaseUser.uid).get();
        final List<DocumentSnapshot> document = result.docs;
        if (document.isEmpty) {
          print('document1vacio ${document.toString()}');

          firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUser.uid).set({
            FirestoreConstants.displayName: firebaseUser.displayName,
            FirestoreConstants.email: firebaseUser.email,
            FirestoreConstants.photoUrl: firebaseUser.photoURL,
            FirestoreConstants.id: firebaseUser.uid,
            "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null
          });

          User? currentUser = firebaseUser;
          await prefs.setString(FirestoreConstants.id, currentUser.uid);
          await prefs.setString(FirestoreConstants.displayName, currentUser.displayName ?? "");
          //await prefs.setString(
          // FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
          await prefs.setString(FirestoreConstants.phoneNumber, currentUser.phoneNumber ?? "");
          await prefs.setString(FirestoreConstants.email, currentUser.email ?? "");
          Preferences.usrNombre = FirestoreConstants.displayName;

          Preferences.usrCorreo = FirestoreConstants.email;
          print('document1LLENO ${document.toString()}');
        } else {
          await prefs.setString(FirestoreConstants.email, "");
          User? currentUser = firebaseUser;
          await prefs.setString(FirestoreConstants.id, currentUser.uid);
          await prefs.setString(FirestoreConstants.displayName, currentUser.displayName ?? "");
          //await prefs.setString(
          // FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
          await prefs.setString(FirestoreConstants.phoneNumber, currentUser.phoneNumber ?? "");
          await prefs.setString(FirestoreConstants.email, currentUser.email ?? "");
          Preferences.usrNombre = FirestoreConstants.displayName;

          Preferences.usrCorreo = FirestoreConstants.email;
          print('541646746ENO ${document.toString()}');

          Preferences.usrNombre = FirestoreConstants.displayName;

          Preferences.usrCorreo = FirestoreConstants.email;

          DocumentSnapshot documentSnapshot = document[0];
          print('documentSnapshot ${documentSnapshot.toString()}');
          ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
          await prefs.setString(FirestoreConstants.id, userChat.id);
          await prefs.setString(FirestoreConstants.displayName, userChat.displayName);
          await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
          await prefs.setString(FirestoreConstants.phoneNumber, userChat.phoneNumber);
        }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else {
      _status = Status.authenticateCanceled;
      notifyListeners();
      return false;
    }
  }

  Future<void> googleSignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}
