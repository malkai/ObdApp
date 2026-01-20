// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blockchainid.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContractAdapter extends TypeAdapter<Contract> {
  @override
  final int typeId = 12;

  @override
  Contract read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contract(
      add: fields[0] as String,
      vehicle: (fields[3] as List).cast<Path>(),
      time: fields[1] as DateTime,
      status: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Contract obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.add)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.vehicle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContractAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class walletAdapter extends TypeAdapter<wallet> {
  @override
  final int typeId = 13;

  @override
  wallet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return wallet(
      add: fields[0] as String,
      name: fields[2] as String,
    )
      ..site = fields[1] as String
      ..blockchain = fields[3] as bool
      ..vin = fields[4] as String
      ..usertank = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, wallet obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.add)
      ..writeByte(1)
      ..write(obj.site)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.blockchain)
      ..writeByte(4)
      ..write(obj.vin)
      ..writeByte(5)
      ..write(obj.usertank);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is walletAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 14;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as int,
      add: fields[1] as String,
      vin: fields[2] as String,
      fuel_B: fields[3] as String,
      fuel_E: fields[4] as String,
      usertank: fields[5] as String,
      abastecimento: fields[6] as String,
      date: fields[7] as DateTime,
    )
      ..status = fields[8] as bool
      ..paths = (fields[9] as List).cast<PathBlockchain>()
      ..value = fields[10] as String;
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.add)
      ..writeByte(2)
      ..write(obj.vin)
      ..writeByte(3)
      ..write(obj.fuel_B)
      ..writeByte(4)
      ..write(obj.fuel_E)
      ..writeByte(5)
      ..write(obj.usertank)
      ..writeByte(6)
      ..write(obj.abastecimento)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.paths)
      ..writeByte(10)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PathBlockchainAdapter extends TypeAdapter<PathBlockchain> {
  @override
  final int typeId = 15;

  @override
  PathBlockchain read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PathBlockchain(
      dist: fields[0] as String,
      fuel: fields[1] as String,
      time: fields[2] as String,
      timeless: fields[3] as String,
    )..arrlatlong = (fields[5] as List).cast<dynamic>();
  }

  @override
  void write(BinaryWriter writer, PathBlockchain obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dist)
      ..writeByte(1)
      ..write(obj.fuel)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.timeless)
      ..writeByte(5)
      ..write(obj.arrlatlong);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PathBlockchainAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserScoreAdapter extends TypeAdapter<UserScore> {
  @override
  final int typeId = 16;

  @override
  UserScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserScore(
      comp: fields[0] as String,
      freq: fields[1] as String,
      conf: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserScore obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.comp)
      ..writeByte(1)
      ..write(obj.freq)
      ..writeByte(2)
      ..write(obj.conf);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
