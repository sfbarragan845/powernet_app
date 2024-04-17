import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController with ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;

  login() async {
    googleAccount = await _googleSignIn.signIn();
    /*
    googleAccount = await _googleSignIn.isSignedIn().then((isSignedIn) async {
      if (isSignedIn) {
        await _googleSignIn.signInSilently().then((value) => googleAccount = value, onError: print);
      }
      return null;
    });
    */
    notifyListeners();
  }

  logOut() async {
    googleAccount = await _googleSignIn.signOut();
    notifyListeners();
  }
}
