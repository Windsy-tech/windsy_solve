import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/providers/storage_repository_provider.dart';
import 'package:windsy_solve/features/inspection/controller/inspection_controller.dart';
import 'package:windsy_solve/features/inspection/repository/check_list_repository.dart';
import 'package:windsy_solve/models/checklist_model.dart';

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
      checkListModel.section, checkListModel.id);
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

  Stream<CheckListModel> getCheckListById(String section, String checkListId) {
    //final inspection = _ref.watch(inspectionControllerProvider.notifier);
    return _checkListRepository.getCheckListById(section, checkListId);
  }
}
