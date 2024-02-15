import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExceptionHandler {
  static String handleException(dynamic e) {
    if (e is FirebaseAuthException) {
      return _handleAuthException(e);
    } else if (e is FirebaseException) {
      return _handleFirestoreException(e);
    } else {
      // Handle other Firebase exceptions or general exceptions here
      return "An unexpected error occurred";
    }
  }

  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'User not found. Please check your credentials.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      // Handle other authentication exceptions as needed
      default:
        return 'Authentication failed. Please try again later.';
    }
  }

  static String _handleFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'cancelled':
        return 'Operation cancelled.';
      case 'unavailable':
        return 'Service unavailable. Please check your internet connection.';
      // Handle other Firestore exceptions as needed
      default:
        return 'Firestore operation failed. Please try again later.';
    }
  }
}
