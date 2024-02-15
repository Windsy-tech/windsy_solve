import 'package:hive/hive.dart';
import 'package:windsy_solve/models/inspection_model.dart';

part 'inspection_sync_task.g.dart';

@HiveType(typeId: 2)
class InspectionSyncTask {
  @HiveField(0)
  final String companyId;

  @HiveField(1)
  final InspectionModel inspectionModel;

  @HiveField(2)
  final String action;

  InspectionSyncTask({
    required this.companyId,
    required this.inspectionModel,
    required this.action,
  });
}