import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<UserCredential> siginWithGoogle() async {
    var googleSignInAccount = await GoogleSignIn().signIn();
    var authentication = await googleSignInAccount!.authentication;

    var credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
