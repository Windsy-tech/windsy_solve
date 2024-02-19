import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:windsy_solve/core/hive/adapters/inspection_sync_task/inspection_sync_task.dart';
import 'package:windsy_solve/core/hive/adapters/nc_sync_task/nc_sync_task.dart';
import 'package:windsy_solve/features/nc/repository/nc_repository.dart';

final testProvider = Provider(
  (ref) => LocalDatabase(
    ref: ref,
  ),
);

class LocalDatabase {
  final Ref _ref;
  LocalDatabase({required Ref ref}) : _ref = ref;
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

  //Sync NC tasks to firebase
  Future<void> syncNCTasks() async {
    final box = await Hive.openBox<NCSyncTask>('nc_sync_tasks');
    for (var i = 0; i < box.length; i++) {
      NCSyncTask? task = box.getAt(i);
      switch (task!.action) {
        case 'create':
          break;
        case 'update':
          final res = await _ref.read(ncRepositoryProvider).updateNC(
                task.companyId,
                task.userId,
                task.ncModel,
              );
          res.fold((l) => print('error uploading to firebase'), (r) {
            print('uploaded to firebase');
          });
          break;
        case 'delete':
          //sync to firebase
          //...
          //...
          //...
          break;
      }
      //delete the task from local db
      await box.deleteAt(i);
    }
  }

  //Sync all tasks to firebase
  Future<void> syncAllTasks() async {
    final box = await Hive.openBox<InspectionSyncTask>('inspection_sync_tasks');
    final box2 = await Hive.openBox<NCSyncTask>('nc_sync_tasks');
    //sync all inspection tasks
    for (var i = 0; i < box.length; i++) {
      final task = box.getAt(i);
      //sync to firebase
      //...
      //...
      //...
      //delete the task from local db
      await box.deleteAt(i);
    }
    //sync all nc tasks
    for (var i = 0; i < box2.length; i++) {
      final task = box2.getAt(i);
      //sync to firebase
      //...
      //...
      //...
      //delete the task from local db
      await box2.deleteAt(i);
    }
  }
}
