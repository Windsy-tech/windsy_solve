import 'package:hive/hive.dart';
import 'package:windsy_solve/core/hive/adapters/inspection_sync_task/inspection_sync_task.dart';
import 'package:windsy_solve/core/hive/adapters/nc_sync_task/nc_sync_task.dart';

class LocalDatabase {
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

  Future<void> saveInspectionSyncTask(NCSyncTask ncSyncTask) async {
    final box = await Hive.openBox<NCSyncTask>('inspection_sync_tasks');
    await box.add(ncSyncTask);
  }

  Future<List<InspectionSyncTask>> getInspectionSyncTasks() async {
    final box = await Hive.openBox<NCSyncTask>('inspection_sync_tasks');
    return box.values.toList().cast<InspectionSyncTask>();
  }

  Future<void> clearInspectionSyncTasks() async {
    final box = await Hive.openBox<NCSyncTask>('inspection_sync_tasks');
    await box.clear();
  }

  //get the number of pending sync tasks count
  Future<int> getInspectionSyncTasksCount() async {
    final box = await Hive.openBox<NCSyncTask>('inspection_sync_tasks');
    return box.length;
  }
}
