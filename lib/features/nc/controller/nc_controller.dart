//Non-Conformity Controller

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/failure.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';
import 'package:windsy_solve/core/type_defs.dart';
import 'package:windsy_solve/models/nc_model.dart';

final ncControllerProvider = Provider<NCController>((ref) {
  return NCController(firestore: ref.watch(firestoreProvider));
});

class NCController extends StateNotifier<bool> {
  final FirebaseFirestore _firestore;
  final Ref _ref;
  final StorageRepository _storageRepository;
  

  NCController({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _ncs => _firestore.collection('ncs');

  void createNC(String id, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community created successfully!');
      Routemaster.of(context).pop();
    });
  }
}
