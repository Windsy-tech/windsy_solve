import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
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
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<String> deleteFile({
    required String url,
  }) async {
    try {
      final filePath = _firebaseStorage.refFromURL(url);
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

  FutureEither downloadFile(String url, String fileName) async {
    final ref = _firebaseStorage.refFromURL(url);

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final File tempFile = File('$appDocPath/$fileName');
    try {
      await ref.writeToFile(tempFile);
      await tempFile.create();

      //create the file and open it

      return right('File downloaded successfully!');
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
