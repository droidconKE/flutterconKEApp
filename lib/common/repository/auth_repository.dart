import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/utils/network.dart';
import 'package:fluttercon/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class AuthRepository {
  final _networkUtil = NetworkUtil();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'profile',
      'email',
    ],
  );

  Future<String> signInWithGoogle() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      Logger().f(googleSignInAccount);
      final googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      Logger().f(googleSignInAuthentication);

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken,
      );
      Logger().f(credential);

      final authResult = await _auth.signInWithCredential(credential);
      Logger().f(authResult);

      final user = authResult.user;
      Logger().f(user);

      if (user != null) {
        assert(!user.isAnonymous, 'User must not be anonymous');
        if (user.isAnonymous) {
          throw Failure(message: 'User must not be anonymous');
        }
        return Future.value(authResult.credential?.accessToken);
      } else {
        throw Failure(message: 'An unexpected error occured');
      }
    } catch (e, st) {
      Logger().f(DefaultFirebaseOptions.currentPlatform);
      Logger().f(st);
      Logger().e(e);
      rethrow;
    }
  }

  Future<AuthResult> signIn({required String token}) async {
    try {
      final response = await _networkUtil.postWithFormData(
        '/social_login/google',
        body: {
          'access_token': token,
        },
      );

      Logger().d(response);

      return AuthResult.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      await _networkUtil.postReq('/logout');
      await _googleSignIn.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
