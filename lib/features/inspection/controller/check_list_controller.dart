import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/inspection/repository/check_list_repository.dart';
import 'package:windsy_solve/models/checklist_model.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

final checkListControllerProvider =
    StateNotifierProvider<CheckListController, bool>((ref) {
  final checkListRepository = ref.watch(checkListRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CheckListController(
    ref: ref,
    checkListRepository: checkListRepository,
    storageRepository: storageRepository,
  );
});

final getCheckListByIdProvider =
    StreamProvider.family((ref, CheckListModel checkListModel) {
  final checkListController = ref.watch(checkListControllerProvider.notifier);
  return checkListController.getCheckListById(
    checkListModel.inspectionId,
    checkListModel.section,
    checkListModel.id,
  );
});

final getComponentsProvider = StreamProvider.family((ref, String query) {
  return ref.watch(checkListControllerProvider.notifier).getComponents(query);
});

final getChecksProvider = StreamProvider.family((ref, String query) {
  return ref.watch(checkListControllerProvider.notifier).getChecks(query);
});

class CheckListController extends StateNotifier<bool> {
  final CheckListRepository _checkListRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CheckListController({
    required CheckListRepository checkListRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _checkListRepository = checkListRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  //update checkList
  void updateCheckList(
    BuildContext context,
    String checkListId,
    CheckListModel checkList,
  ) async {
    final user = _ref.watch(userProvider)!;

    checkList = checkList.copyWith(
      modifiedBy: user.displayName,
      modifiedAt: DateTime.now(),
    );
    final res = await _checkListRepository.updateCheckList(
      user.companyId,
      checkListId,
      checkList,
    );
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, r.toString());
        //Routemaster.of(context).pop();
      },
    );
  }

  //Adds a new custom component to firebase
  void addNewComponent(BuildContext context, String component) async {
    final user = _ref.watch(userProvider)!;
    final res = await _checkListRepository.addNewComponent(
      user.companyId,
      component,
    );
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, r.toString());
        //Routemaster.of(context).pop();
      },
    );
  }

  //Adds a new custom check to firebase
  void addNewCheck(BuildContext context, String check) async {
    final user = _ref.watch(userProvider)!;
    final res = await _checkListRepository.addNewCheck(
      user.companyId,
      check,
    );
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, r.toString());
        //Routemaster.of(context).pop();
      },
    );
  }

  //get check list by id
  Stream<CheckListModel> getCheckListById(
      String inspectionId, String section, String checkListId) {
    //final inspection = _ref.watch(inspectionControllerProvider.notifier);
    return _checkListRepository.getCheckListById(
        inspectionId, section, checkListId);
  }

  //get components
  Stream<List<String>> getComponents(String query) {
    final user = _ref.read(userProvider);
    final companyName = user!.companyName;
    return _checkListRepository.getComponents(companyName, query);
  }

  //get checks
  Stream<List<String>> getChecks(String query) {
    final user = _ref.read(userProvider);
    final companyName = user!.companyName;
    return _checkListRepository.getChecks(companyName, query);
  }
}
