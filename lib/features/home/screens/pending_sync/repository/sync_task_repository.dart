import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:windsy_solve/core/hive/adapters/inspection_sync_task/inspection_sync_task.dart';
import 'package:windsy_solve/core/hive/adapters/nc_sync_task/nc_sync_task.dart';
import 'package:windsy_solve/features/nc/repository/nc_repository.dart';

final syncTaskRepositoryProvider = Provider<SyncTaskRepository>((ref) {
  return SyncTaskRepository();
});

class SyncTaskRepository {
  //Sync NC tasks to firebase
  Future<void> syncNCTasks(WidgetRef ref) async {
    final box = await Hive.openBox<NCSyncTask>('nc_sync_tasks');
    for (var i = 0; i < box.length; i++) {
      NCSyncTask? task = box.getAt(i);
      switch (task!.action) {
        case 'create':
          break;
        case 'update':
          final res = await ref.read(ncRepositoryProvider).updateNC(
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
