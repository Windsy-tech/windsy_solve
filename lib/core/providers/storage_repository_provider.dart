import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:windsy_solve/core/handler/failure.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/core/type_defs.dart';

final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String id,
    required String path,
    required File? file,
    required Uint8List? webFile,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(webFile!);
      } else {
        uploadTask = ref.putFile(file!);
      }

      final snapshot = await uploadTask;
      print(snapshot);
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<String> deleteFile({
    required String url,
    required String id,
  }) async {
    try {
      final filePath = _firebaseStorage.refFromURL(url);
      print(filePath.name);
      print(filePath.fullPath);
      print(filePath.parent);
      print(id);
      await _firebaseStorage.ref().child(filePath.fullPath).delete();
      return right('File deleted successfully!');
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<bool> deleteFolder(
    String companyId,
    String inspectionId,
    String sectionName,
  ) async {
    try {
      String path = '$companyId/inspections/$inspectionId/$sectionName';
      await _firebaseStorage.ref().child(path).delete();
      return right(true);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
