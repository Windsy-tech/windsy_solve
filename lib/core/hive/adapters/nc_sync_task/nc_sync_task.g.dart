// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nc_sync_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NCSyncTaskAdapter extends TypeAdapter<NCSyncTask> {
  @override
  final int typeId = 0;

  @override
  NCSyncTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NCSyncTask(
      companyId: fields[0] as String,
      userId: fields[1] as String,
      ncModel: fields[2] as NCModel,
      action: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NCSyncTask obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.companyId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.ncModel)
      ..writeByte(3)
      ..write(obj.action);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NCSyncTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
