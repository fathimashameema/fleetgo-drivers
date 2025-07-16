import 'package:driver_repository/driver_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DriverRepo {
  Stream<User?> get userStatus;
  Future<Driver> signUpWithEmail(Driver user, String password);
  Future<void> verifyPhone(String phone);
  Future<Driver> signInWithGoogle();
  Future<void> verifyEmail(String email, int otpc, String message);
  Future<Driver> signUpWithPhone(Driver myUser, String smsOtp);
  Future<String?> signInWithEmail(String email, String password);
  Future<String?> signInWithNumber(String phoneNo, String password);
  Future<String?> signInWithUsername(String username, String password);
  Future<String?> signIn(String identifier, String password);
  Future<void> logoOut();
  Future<void> resetPassword(String email);
  Future<bool> verifySmsCodeForReset(String smsCode);
  Future<void> updatePassword(String userId, String newPassword);
}
