import 'package:hive/hive.dart';
import 'package:windsy_solve/models/nc/nc_model.dart';

class NCModelAdapter extends TypeAdapter<NCModel> {
  @override
  final int typeId = 1;

  @override
  NCModel read(BinaryReader reader) {
    final fieldsCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < fieldsCount; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }

    return NCModel(
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
      assignedTo: fields[10] as List<String>?,
      createdBy: fields[11] as String,
      createdAt: fields[12] as DateTime,
      updatedBy: fields[13] as String,
      updatedAt: fields[14] as DateTime,
      closedBy: fields[15] as String?,
      closedAt: fields[16] as DateTime?,
      closedReason: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NCModel obj) {
    writer
      ..writeByte(18)
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
      ..write(obj.assignedTo)
      ..writeByte(11)
      ..write(obj.createdBy)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedBy)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.closedBy)
      ..writeByte(16)
      ..write(obj.closedAt)
      ..writeByte(17)
      ..write(obj.closedReason);
  }
}

