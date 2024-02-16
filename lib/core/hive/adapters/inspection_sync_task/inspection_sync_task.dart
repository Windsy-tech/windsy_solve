import 'package:hive/hive.dart';
import 'package:windsy_solve/models/inspection_model.dart';

part 'inspection_sync_task.g.dart';

@HiveType(typeId: 2)
class InspectionSyncTask {
  @HiveField(0)
  final String companyId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final InspectionModel inspectionModel;

  @HiveField(3)
  final String action;

  InspectionSyncTask({
    required this.companyId,
    required this.userId,
    required this.inspectionModel,
    required this.action,
  });
}
