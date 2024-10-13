// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeStatusAdapter extends TypeAdapter<EmployeeStatus> {
  @override
  final int typeId = 1;

  @override
  EmployeeStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmployeeStatus(
      employeeName: fields[0] as String,
      status: fields[1] as String,
      deleted: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, EmployeeStatus obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.employeeName)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
