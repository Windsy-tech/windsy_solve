import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:windsy_solve/core/hive/adapters/inspection_sync_task/inspection_sync_task.dart';
import 'package:windsy_solve/core/hive/adapters/nc_sync_task/nc_sync_task.dart';
import 'package:windsy_solve/features/home/screens/pending_sync/repository/sync_task_repository.dart';
import 'package:windsy_solve/features/nc/repository/nc_repository.dart';

final syncTaskControllerProvider = Provider((ref) {
  final syncTaskRepository = ref.watch(syncTaskRepositoryProvider);
  return SyncTaskController(
    syncTaskRepository: syncTaskRepository,
    ref: ref,
  );
});

class SyncTaskController {
  final SyncTaskRepository _syncTaskRepository;

  final Ref _ref;
  SyncTaskController(
      {required SyncTaskRepository syncTaskRepository, required Ref ref})
      : _syncTaskRepository = syncTaskRepository,
        _ref = ref;

  Future<void> saveNCSyncTask(NCSyncTask ncSyncTask) async {
    final box = await Hive.openBox<NCSyncTask>('nc_sync_tasks');
    await box.add(ncSyncTask);
  }

  Future<List<NCSyncTask>> getNCSyncTasks() async {
    final box = await Hive.openBox<NCSyncTask>('nc_sync_tasks');
    return box.values.toList();
  }

  Future<void> clearNCSyncTasks() async {
    final box = await Hive.openBox<NCSyncTask>('nc_sync_tasks');
    await box.clear();
  }

  //get the number of pending sync tasks count
  Future<int> getNCSyncTasksCount() async {
    final box = await Hive.openBox<NCSyncTask>('nc_sync_tasks');
    return box.length;
  }

  Future<void> saveInspectionSyncTask(
      InspectionSyncTask inspectionSyncTask) async {
    final box = await Hive.openBox<InspectionSyncTask>('inspection_sync_tasks');
    await box.add(inspectionSyncTask);
  }

  Future<List<InspectionSyncTask>> getInspectionSyncTasks() async {
    final box = await Hive.openBox<InspectionSyncTask>('inspection_sync_tasks');
    return box.values.toList().cast<InspectionSyncTask>();
  }

  Future<void> clearInspectionSyncTasks() async {
    final box = await Hive.openBox<InspectionSyncTask>('inspection_sync_tasks');
    await box.clear();
  }

  //get the number of pending sync tasks count
  Future<int> getInspectionSyncTasksCount() async {
    final box = await Hive.openBox<InspectionSyncTask>('inspection_sync_tasks');
    return box.length;
  }

  Future<int> getTotalSyncTasksCount() async {
    final box = await Hive.openBox<InspectionSyncTask>('inspection_sync_tasks');
    final box2 = await Hive.openBox<NCSyncTask>('nc_sync_tasks');
    return box.length + box2.length;
  }

  Future<void> clearAllSyncTasks() async {
    final box = await Hive.openBox<InspectionSyncTask>('inspection_sync_tasks');
    final box2 = await Hive.openBox<NCSyncTask>('nc_sync_tasks');
    await box.clear();
    await box2.clear();
  }

  Future<void> syncNCTasks(WidgetRef ref) async {
    await _syncTaskRepository.syncNCTasks(ref);
  }
}
