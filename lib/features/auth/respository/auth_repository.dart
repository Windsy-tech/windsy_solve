import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/core/constants/firebase_constants.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/models/user_model.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
  ),
);

/// Repository class for handling authentication related operations.
class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _auth = auth,
        _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  void signInWithEmailAndPassword(String? email, String? password) async {
    try {
      print(email);
      print(password);
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      print(userCredential.user!.uid);

      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        displayName: userCredential.user!.displayName!,
        companyName: '',
        companyId: '',
        email: email,
        phoneNumber: '',
        photoUrl: Constants.profileAvatarDefault,
        role: 'user',
        expertise: [],
        lastLoginDate: DateTimeUtils.getFormattedDate(DateTime.now()),
        lastLoginTime: DateTimeUtils.getFormattedTime(DateTime.now()),
        isActive: true,
        isBlocked: false,
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());
    } catch (e) {
      print(e);
    }
  }
}
