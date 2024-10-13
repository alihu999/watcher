// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employees_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeesRecordAdapter extends TypeAdapter<EmployeesRecord> {
  @override
  final int typeId = 0;

  @override
  EmployeesRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmployeesRecord(
      employeeName: fields[0] as String,
      startAt: fields[1] as DateTime,
      finishAt: fields[2] as DateTime,
      breakSAt: fields[3] as DateTime,
      breakFAt: fields[4] as DateTime,
      uplod: fields[5] as bool,
      deleted: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, EmployeesRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.employeeName)
      ..writeByte(1)
      ..write(obj.startAt)
      ..writeByte(2)
      ..write(obj.finishAt)
      ..writeByte(3)
      ..write(obj.breakSAt)
      ..writeByte(4)
      ..write(obj.breakFAt)
      ..writeByte(5)
      ..write(obj.uplod)
      ..writeByte(6)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeesRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
