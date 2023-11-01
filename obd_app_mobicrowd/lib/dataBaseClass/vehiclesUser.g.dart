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
      kmarrh: (fields[4] as List).cast<dynamic>(),
      kmacch: fields[5] as double,
      kmaccarrh: (fields[6] as List).cast<dynamic>(),
      kmarre: (fields[7] as List).cast<dynamic>(),
      kmacce: fields[8] as double,
      kmaccarre: (fields[9] as List).cast<dynamic>(),
      kmarrv: (fields[10] as List).cast<dynamic>(),
      kmaccv: fields[11] as double,
      kmaccarrv: (fields[12] as List).cast<dynamic>(),
      farrk: (fields[13] as List).cast<dynamic>(),
      m: fields[14] as double,
      c: fields[15] as double,
      rquare: fields[16] as double,
      m2: fields[17] as double,
      c2: fields[18] as double,
      rquare2: fields[19] as double,
      fuelk: (fields[20] as List).cast<dynamic>(),
      fuels: (fields[21] as List).cast<dynamic>(),
      percentdata: fields[24] as double,
      fuelkf: (fields[22] as List).cast<dynamic>(),
      fuelsf: (fields[23] as List).cast<dynamic>(),
      points: (fields[26] as List).cast<dynamic>(),
    )..time = fields[25] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Vin obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tarr)
      ..writeByte(2)
      ..write(obj.tacc)
      ..writeByte(3)
      ..write(obj.taccarr)
      ..writeByte(4)
      ..write(obj.kmarrh)
      ..writeByte(5)
      ..write(obj.kmacch)
      ..writeByte(6)
      ..write(obj.kmaccarrh)
      ..writeByte(7)
      ..write(obj.kmarre)
      ..writeByte(8)
      ..write(obj.kmacce)
      ..writeByte(9)
      ..write(obj.kmaccarre)
      ..writeByte(10)
      ..write(obj.kmarrv)
      ..writeByte(11)
      ..write(obj.kmaccv)
      ..writeByte(12)
      ..write(obj.kmaccarrv)
      ..writeByte(13)
      ..write(obj.farrk)
      ..writeByte(14)
      ..write(obj.m)
      ..writeByte(15)
      ..write(obj.c)
      ..writeByte(16)
      ..write(obj.rquare)
      ..writeByte(17)
      ..write(obj.m2)
      ..writeByte(18)
      ..write(obj.c2)
      ..writeByte(19)
      ..write(obj.rquare2)
      ..writeByte(20)
      ..write(obj.fuelk)
      ..writeByte(21)
      ..write(obj.fuels)
      ..writeByte(22)
      ..write(obj.fuelkf)
      ..writeByte(23)
      ..write(obj.fuelsf)
      ..writeByte(24)
      ..write(obj.percentdata)
      ..writeByte(25)
      ..write(obj.time)
      ..writeByte(26)
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
