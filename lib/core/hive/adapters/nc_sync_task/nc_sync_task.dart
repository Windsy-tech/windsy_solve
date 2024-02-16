import 'package:hive/hive.dart';
import 'package:windsy_solve/models/nc_model.dart';

part 'nc_sync_task.g.dart';

@HiveType(typeId: 0)
class NCSyncTask {
  @HiveField(0)
  final String companyId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final NCModel ncModel;

  @HiveField(3)
  final String action;

  NCSyncTask({
    required this.companyId,
    required this.userId,
    required this.ncModel,
    required this.action,
  });
}
