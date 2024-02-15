import 'package:hive/hive.dart';
import 'package:windsy_solve/models/inspection_model.dart';

class InspectionModelAdapter extends TypeAdapter<InspectionModel> {
  @override
  final int typeId = 3;

  @override
  InspectionModel read(BinaryReader reader) {
    final fieldsCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < fieldsCount; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }

    return InspectionModel(
      id: fields[0] as String,
      title: fields[1] as String,
      problemDescription: fields[2] as String,
      status: fields[3] as String,
      severity: fields[4] as int,
      category: fields[5] as String,
      windFarm: fields[6] as String,
      turbineNo: fields[7] as String,
      platform: fields[8] as String?,
      oem: fields[9] as String?,
      customer: fields[10] as String,
      externalAuditor: fields[11] as String,
      supplier: fields[12] as String,
      createdBy: fields[13] as String,
      createdAt: fields[14] as DateTime,
      updatedBy: fields[15] as String,
      updatedAt: fields[16] as DateTime,
      closedBy: fields[17] as String?,
      closedAt: fields[18] as DateTime?,
      closedReason: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.problemDescription)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.severity)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.windFarm)
      ..writeByte(7)
      ..write(obj.turbineNo)
      ..writeByte(8)
      ..write(obj.platform)
      ..writeByte(9)
      ..write(obj.oem)
      ..writeByte(10)
      ..write(obj.customer)
      ..writeByte(11)
      ..write(obj.externalAuditor)
      ..writeByte(12)
      ..write(obj.supplier)
      ..writeByte(13)
      ..write(obj.createdBy)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedBy)
      ..writeByte(16)
      ..write(obj.updatedAt)
      ..writeByte(17)
      ..write(obj.closedBy)
      ..writeByte(18)
      ..write(obj.closedAt)
      ..writeByte(19)
      ..write(obj.closedReason);
  }

}

