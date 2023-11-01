// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obdRawData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserdataAdapter extends TypeAdapter<Userdata> {
  @override
  final int typeId = 2;

  @override
  Userdata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Userdata(
      name: fields[0] as String,
      uservehicle: fields[1] as UserVehicleRaw,
    );
  }

  @override
  void write(BinaryWriter writer, Userdata obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.uservehicle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserdataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserVehicleRawAdapter extends TypeAdapter<UserVehicleRaw> {
  @override
  final int typeId = 3;

  @override
  UserVehicleRaw read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserVehicleRaw(
      vin: fields[0] as String,
      userdata: fields[1] as UserDataProcess,
    );
  }

  @override
  void write(BinaryWriter writer, UserVehicleRaw obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.vin)
      ..writeByte(1)
      ..write(obj.userdata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserVehicleRawAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserDataProcessAdapter extends TypeAdapter<UserDataProcess> {
  @override
  final int typeId = 4;

  @override
  UserDataProcess read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDataProcess(
      time: fields[6] as DateTime,
      isOnline: fields[0] as bool,
      userdata: (fields[3] as List).cast<ObdRawData>(),
      signature: fields[2] as String,
      acc: fields[4] as UserAcc,
      pos: fields[5] as PositionClass,
      processada: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserDataProcess obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.isOnline)
      ..writeByte(1)
      ..write(obj.processada)
      ..writeByte(2)
      ..write(obj.signature)
      ..writeByte(3)
      ..write(obj.userdata)
      ..writeByte(4)
      ..write(obj.acc)
      ..writeByte(5)
      ..write(obj.pos)
      ..writeByte(6)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataProcessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAccAdapter extends TypeAdapter<UserAcc> {
  @override
  final int typeId = 5;

  @override
  UserAcc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAcc(
      x: fields[0] as String,
      y: fields[1] as String,
      z: fields[2] as String,
      unit: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserAcc obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.y)
      ..writeByte(2)
      ..write(obj.z)
      ..writeByte(3)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAccAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PositionClassAdapter extends TypeAdapter<PositionClass> {
  @override
  final int typeId = 6;

  @override
  PositionClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PositionClass(
      long: fields[0] as double,
      lat: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PositionClass obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.long)
      ..writeByte(1)
      ..write(obj.lat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ObdRawDataAdapter extends TypeAdapter<ObdRawData> {
  @override
  final int typeId = 7;

  @override
  ObdRawData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ObdRawData(
      pid: fields[0] as String,
      obddata: fields[1] as ObdData,
    );
  }

  @override
  void write(BinaryWriter writer, ObdRawData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pid)
      ..writeByte(1)
      ..write(obj.obddata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObdRawDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ObdDataAdapter extends TypeAdapter<ObdData> {
  @override
  final int typeId = 8;

  @override
  ObdData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ObdData(
      unit: fields[0] as String,
      title: fields[1] as String,
      response: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ObdData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.unit)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.response);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObdDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
