import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/utils/network.dart';
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

  Future<AuthResult> ghostSignIn() async {
    try {
      final response = await _networkUtil.postReq(
        '/login',
        body: {
          'email': 'google@play.com',
          'password': 'password',
        },
      );

      return AuthResult.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();

      final googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken,
      );

      final authResult = await _auth.signInWithCredential(credential);

      final user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous, 'User must not be anonymous');
        if (user.isAnonymous) {
          throw Failure(message: 'User must not be anonymous');
        }
        return Future.value(authResult.credential?.accessToken);
      } else {
        throw Failure(message: 'An unexpected error occured');
      }
    } catch (error, stackTrace) {
      Logger().f(stackTrace);
      Logger().e(error);
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
      await _googleSignIn.signOut();
      await _networkUtil.postReq('/logout');
    } catch (e) {
      rethrow;
    }
  }
}
