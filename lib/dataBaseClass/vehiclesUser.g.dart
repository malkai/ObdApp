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
      vehicle: fields[1] as Vin,
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

class VinAdapter extends TypeAdapter<Vin> {
  @override
  final int typeId = 1;

  @override
  Vin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vin(
      id: fields[0] as String,
      tarr: (fields[1] as List).cast<dynamic>(),
      tacc: fields[2] as double,
      taccarr: (fields[3] as List).cast<dynamic>(),
      kmarre: (fields[4] as List).cast<dynamic>(),
      kmacce: fields[5] as double,
      kmaccarre: (fields[6] as List).cast<dynamic>(),
      kmarrv: (fields[7] as List).cast<dynamic>(),
      kmaccv: fields[8] as double,
      kmaccarrv: (fields[9] as List).cast<dynamic>(),
      farrk: (fields[10] as List).cast<dynamic>(),
      percentdata: fields[12] as double,
      fuelkf: (fields[11] as List).cast<dynamic>(),
      points: (fields[14] as List).cast<dynamic>(),
    )..time = fields[13] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Vin obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tarr)
      ..writeByte(2)
      ..write(obj.tacc)
      ..writeByte(3)
      ..write(obj.taccarr)
      ..writeByte(4)
      ..write(obj.kmarre)
      ..writeByte(5)
      ..write(obj.kmacce)
      ..writeByte(6)
      ..write(obj.kmaccarre)
      ..writeByte(7)
      ..write(obj.kmarrv)
      ..writeByte(8)
      ..write(obj.kmaccv)
      ..writeByte(9)
      ..write(obj.kmaccarrv)
      ..writeByte(10)
      ..write(obj.farrk)
      ..writeByte(11)
      ..write(obj.fuelkf)
      ..writeByte(12)
      ..write(obj.percentdata)
      ..writeByte(13)
      ..write(obj.time)
      ..writeByte(14)
      ..write(obj.points);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VinAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
