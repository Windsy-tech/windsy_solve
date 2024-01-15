//Non-Conformity Controller

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/repository/nc_repository.dart';
import 'package:windsy_solve/models/nc_model.dart';
import 'package:windsy_solve/models/user_model.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

final ncControllerProvider = StateNotifierProvider<NCController, bool>((ref) {
  final ncRepository = ref.watch(ncRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return NCController(
    ref: ref,
    ncRepository: ncRepository,
    storageRepository: storageRepository,
  );
});

final getUserNCProvider = StreamProvider.family((ref, String uid) {
  return ref.read(ncControllerProvider.notifier).getNCsCreatedByUser(uid);
});

final searchMembersProvider = StreamProvider.family((ref, String query) {
  return ref.watch(ncControllerProvider.notifier).searchMembers(query);
});

class NCController extends StateNotifier<bool> {
  final NCRepository _ncRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  NCController({
    required NCRepository ncRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _ncRepository = ncRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createNC(BuildContext context, NCModel ncModel) async {
    state = true;
    final res = await _ncRepository.createNC(ncModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'NC created successfully!');
      Routemaster.of(context).pop();
    });
  }

  //get stream of all ncs created by user
  Stream<List<NCModel>> getNCsCreatedByUser(String uid) {
    return _ncRepository.getNCsCreatedByUser(uid);
  }

  Stream<List<UserModel>> searchMembers(String query) {
    return _ncRepository.searchMembers(query);
  }

  void addMembers(String ncId, List<String> uids, BuildContext context) async {
    final res = await _ncRepository.addMembers(ncId, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
}
