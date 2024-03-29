//Non-Conformity Controller

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/repository/nc_repository.dart';
import 'package:windsy_solve/models/common/user_model.dart';
import 'package:windsy_solve/models/common/windfarm_model.dart';
import 'package:windsy_solve/models/nc/nc_model.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

final ncControllerProvider = StateNotifierProvider<NCController, bool>((ref) {
  final ncRepository = ref.watch(ncRepositoryProvider);
  return NCController(
    ref: ref,
    ncRepository: ncRepository,
  );
});

final getUserNCProvider = StreamProvider<List<NCModel>>((ref) {
  return ref.watch(ncControllerProvider.notifier)._getNCsCreatedByUser();
});

final getNCbyIdProvider =
    FutureProvider.autoDispose.family((ref, String ncId) async {
  final ncController = ref.watch(ncControllerProvider.notifier);
  return ncController.getNCbyId(ncId);
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

  NCController({
    required NCRepository ncRepository,
    required Ref ref,
  })  : _ncRepository = ncRepository,
        _ref = ref,
        super(false);

  //create new nc
  void createNC(BuildContext context, String companyId, NCModel ncModel) async {
    state = true;
    final res = await _ncRepository.createNC(companyId, ncModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) {
        showSnackBar(
            context, 'NC-$r created successfully!', SnackBarType.success);
        Routemaster.of(context).pop();
      },
    );
  }

  //delete nc
  void deleteNC(BuildContext context, String companyId, String ncId) async {
    state = true;
    final res = await _ncRepository.deleteNC(companyId, ncId);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) {
        showSnackBar(context, r, SnackBarType.success);
        Routemaster.of(context).pop();
      },
    );
  }

  //close nc
  void closeNC(BuildContext context, String companyId, String ncId) async {
    state = true;
    final user = _ref.read(userProvider)!;
    final res = await _ncRepository.closeNC(companyId, user.uid, ncId);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) => showSnackBar(context, r, SnackBarType.success),
    );
  }

  //update nc
  void updateNC(BuildContext context, NCModel nc) async {
    state = true;
    final user = _ref.read(userProvider)!;
    final res = await _ncRepository.updateNC(user.companyId, user.uid, nc);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) {
        showSnackBar(context, r, SnackBarType.success);
        Routemaster.of(context).pop();
      },
    );
  }

  //get future of nc by id
  Future<NCModel> getNCbyId(String ncId) async {
    //final user = _ref.read(userProvider)!;
    final ncModel = await _ncRepository.getNCbyId('windsy', ncId);
    return NCModel.fromMap(ncModel.data() as Map<String, dynamic>);
  }

  //get stream of nc by id
  Stream<NCModel> getNCbyId1(String ncId) {
    //final user = _ref.read(userProvider)!;
    return _ncRepository.getNCbyId1('windsy', ncId);
  }

  //get stream of all ncs created by user
  Stream<List<NCModel>> _getNCsCreatedByUser() {
    final user = _ref.read(userProvider)!;
    final data = _ncRepository.getNCsCreatedByUser(user.companyId, user.uid);
    return data;
  }

  //get stream of all ncs created by user
  Stream<List<UserModel>> searchMembers(String query) {
    return _ncRepository.searchMembers(query);
  }

  //add members
  void addMembers(String ncId, List<String> uids, BuildContext context) async {
    final res = await _ncRepository.addMembers(ncId, uids);
    res.fold(
      (l) => showSnackBar(context, l.message, SnackBarType.error),
      (r) => Routemaster.of(context).pop(),
    );
  }

  //get windfarms
  Stream<List<WindFarmModel>> getWindFarms(String query) {
    final user = _ref.read(userProvider);
    final companyName = user!.companyName;
    return _ncRepository.getWindFarms(companyName, query);
  }
}
