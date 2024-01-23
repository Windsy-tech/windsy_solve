//Non-Conformity Controller

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/repository/nc_repository.dart';
import 'package:windsy_solve/models/nc_model.dart';
import 'package:windsy_solve/models/user_model.dart';
import 'package:windsy_solve/models/windfarm_model.dart';
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

final getUserNCProvider = FutureProvider<List<NCModel>>((ref) async {
  return await ref.watch(ncControllerProvider.notifier)._getNCsCreatedByUser();
});

final searchMembersProvider = StreamProvider.family((ref, String query) {
  return ref.watch(ncControllerProvider.notifier).searchMembers(query);
});

final getWindFarmsProvider = StreamProvider.family((ref, String query) {
  return ref.watch(ncControllerProvider.notifier).getWindFarms(query);
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

  void createNC(BuildContext context, String companyId, NCModel ncModel) async {
    state = true;
    final res = await _ncRepository.createNC(companyId, ncModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'NC-$r created successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  void deleteNC(BuildContext context, String companyId, String ncId) async {
    state = true;
    final res = await _ncRepository.deleteNC(companyId, ncId);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, r);
        Routemaster.of(context).pop();
      },
    );
  }

  //get stream of all ncs created by user
  Future<List<NCModel>> _getNCsCreatedByUser() async {
    final user = _ref.read(userProvider)!;
    final data =
        await _ncRepository.getNCsCreatedByUser(user.companyId, user.uid);
    return data;
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

  Stream<List<WindFarmModel>> getWindFarms(String query) {
    final user = _ref.read(userProvider);
    final companyName = user!.companyName;
    print(companyName);
    return _ncRepository.getWindFarms(companyName, query);
  }
}
