import 'dart:developer';

import 'package:driver_repository/driver_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class FirebaseDriverRepository implements DriverRepo {
  FirebaseDriverRepository({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth;
  String storedVerificationId = '';
  FirestoreRepo firestoreRepo = FirestoreDriverRepository();

  @override
  Stream<User?> get userStatus {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }

  @override
  Future<Driver> signUpWithEmail(Driver myUser, String password) async {
    try {
      // Add a prefix to the email address for driver accounts
      final driverEmail = 'driver_${myUser.email}';

      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: driverEmail,
        password: password,
      );

      // Store the original email in Firestore
      myUser = myUser.copyWith(
        id: user.user!.uid,
        email: myUser.email, // Keep the original email in the Driver object
      );

      // Store the driver data in Firestore with the original email
      await firestoreRepo.createDriver(myUser);

      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> verifyEmail(String email, int otp, String message) async {
    final smtpServer = gmail("fleetgo.rides@gmail.com", "itui iiyp tvvs derv");

    log(email);

    final message = Message()
      ..from = const Address("fleetgo.rides@gmail.com", "Fleetgo")
      ..recipients.add(email)
      ..subject = "Your Fleetgo code is $otp"
      ..html = """
  <html>
  <body style="font-family: Arial, sans-serif; color: #333; font-size: 15px; ">
    
    <p>Your Fleetgo verification code is:</p>
    
    <p style="font-size: 28px; font-weight: bold; color: #a6a2a2; text-align: center;">$otp</p>
    
    <p>Please enter this code to complete your verification process.</p>
    
    <p>For some security reasons, don't share it with anyone..</p>
    
    <p>Best regards,<br><b>FleetGo Team</b></p>
  </body>
  </html>
  """;
    try {
      final sendReport =
          await send(message, smtpServer, timeout: const Duration(minutes: 5));
      log("OTP Sent: ${sendReport.toString()}");
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> verifyPhone(
    String phone,
  ) async {
    try {
      phone = "+91${phone.trim()}";

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (phoneAuthCredential) async {},
        verificationFailed: (error) {
          log('Verification failed: ${error.message}');
        },
        codeSent: (verificationId, forceResendingToken) {
          storedVerificationId = verificationId;
          log('otp sent : $verificationId');
        },
        codeAutoRetrievalTimeout: (verificationId) {
          log('auto retrieval time out');
          storedVerificationId = verificationId;
        },
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Driver> signUpWithPhone(Driver myUser, String smsOtp) async {
    try {
      final cred = await _firebaseAuth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: storedVerificationId, smsCode: smsOtp));
      log('verification id in function : $storedVerificationId');
      log('phone user : ${cred.user}');
      myUser = myUser.copyWith(id: cred.user!.uid);
      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Driver> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth?.idToken,
              accessToken: googleAuth?.accessToken));
      final user = cred.user;
      final Driver myUser = Driver(
          id: user?.uid ?? '',
          email: user?.email ?? '',
          name: user?.displayName ?? '',
          number: user?.phoneNumber ?? '',
          password: '',
          registrationProgress: 0,
          role: 'Driver');
      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      final message = await firestoreRepo.getUserWithEmail(email, password);

      if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(message)) {
        // Add the driver_ prefix to the email for Firebase authentication
        final driverEmail = 'driver_$message';
        await _firebaseAuth.signInWithEmailAndPassword(
          email: driverEmail,
          password: password,
        );
        log('driver signed in');
        return null;
      } else {
        return message;
      }
    } catch (e) {
      log(e.toString());
      return 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  Future<String?> signInWithNumber(String phoneNo, String password) async {
    try {
      final message = await firestoreRepo.getUserWithNumber(phoneNo, password);
      log(message);
      if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(message)) {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: message,
          password: password,
        );
        return null;
      } else {
        return message;
      }
    } catch (e) {
      log(e.toString());
      return 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  Future<String?> signInWithUsername(String username, String password) async {
    try {
      final message = await firestoreRepo.getUserWithname(username, password);
      log(message);
      if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(message)) {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: message,
          password: password,
        );
        return null;
      } else {
        return message;
      }
    } catch (e) {
      log(e.toString());
      return 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  Future<String?> signIn(String identifier, String password) async {
    if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(identifier)) {
      return signInWithEmail(identifier, password);
    } else if (RegExp(r'^[0-9]{10}$').hasMatch(identifier)) {
      return signInWithNumber(identifier, password);
    } else {
      return signInWithUsername(identifier, password);
    }
  }

  @override
  Future<void> logoOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> verifySmsCodeForReset(String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: storedVerificationId,
        smsCode: smsCode,
      );
      await _firebaseAuth.signInWithCredential(credential);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<void> updatePassword(String userId, String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception('No user signed in. Please sign in first.');
      }

      if (user.uid != userId) {
        throw Exception('Cannot change password for another user');
      }

      // Update password in Firebase
      await user.updatePassword(newPassword);

      // Update password in Firestore
      await firestoreRepo.updatePassword(newPassword, userId);
    } catch (e) {
      log('Password update error: ${e.toString()}');
      rethrow;
    }
  }
}
