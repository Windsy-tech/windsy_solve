// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_sync_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionSyncTaskAdapter extends TypeAdapter<InspectionSyncTask> {
  @override
  final int typeId = 2;

  @override
  InspectionSyncTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InspectionSyncTask(
      companyId: fields[0] as String,
      inspectionModel: fields[1] as InspectionModel,
      action: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionSyncTask obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.companyId)
      ..writeByte(1)
      ..write(obj.inspectionModel)
      ..writeByte(2)
      ..write(obj.action);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionSyncTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
