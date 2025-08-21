import 'dart:io';

import 'package:driver_repository/driver_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirestoreRepo {
  Future<void> setUserData(Driver user);
  Future<bool> isProfileComplete(User driver);
  Future<void> setRole(String uid, String role);
  Future<Driver> getUser(String userId);
  Future<void> setRegistrationProgress(String uid, int progress);
  Future<int> getRegistrationProgress(String uid);
  Future<void> setProfileComplete(Driver user);
  Future<void> setOtp(int otp, String mailOrPhone);
  Future<int?> getOtp(String mailOrPhone);
  Future<void> deleteOtp(String mailOrPhone);
  Future<void> resetOtp(String mailOrPhone, int otp);
  Future<bool> isUsernameExit(String username);
  Future<bool> isEmailExit(String email);
  Future<bool> isPhoneExit(String phone);
  Future<String> getUserWithNumber(String phoneNo, String password);
  Future<String> getUserWithname(String username, String password);
  Future<String?> getEmailWithName(String username);
  Future<String> getUserWithEmail(String email, String password);
  Future<String?> getPassword(String id);
  Future<String?> getEmailById(String id);
  Future<void> updatePassword(String newPassword, String userId);
  Future<String?> getUserId(String identifiers);
  Future<void> createDriver(Driver driver);
  Future<String?> uploadFileToFirestore(File file, String folderName);
}
