// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehiclesUser.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserVehiclesAdapter extends TypeAdapter<UserVehicles> {
  @override
  final int typeId = 0;

  @override
  UserVehicles read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserVehicles(
      user: fields[0] as String,
      vehicle: fields[1] as Path,
    );
  }

  @override
  void write(BinaryWriter writer, UserVehicles obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.user)
      ..writeByte(1)
      ..write(obj.vehicle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserVehiclesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PathAdapter extends TypeAdapter<Path> {
  @override
  final int typeId = 1;

  @override
  Path read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Path(
      id: fields[0] as String,
      tacc: fields[1] as double,
      kmarre: (fields[2] as List).cast<dynamic>(),
      farrk: (fields[3] as List).cast<dynamic>(),
      percentdata: fields[5] as double,
      fuelkf: (fields[4] as List).cast<dynamic>(),
      points: (fields[7] as List).cast<dynamic>(),
    )..time = fields[6] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Path obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tacc)
      ..writeByte(2)
      ..write(obj.kmarre)
      ..writeByte(3)
      ..write(obj.farrk)
      ..writeByte(4)
      ..write(obj.fuelkf)
      ..writeByte(5)
      ..write(obj.percentdata)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.points);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PathAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
