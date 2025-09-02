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
      ..blockchain = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, wallet obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.add)
      ..writeByte(1)
      ..write(obj.site)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.blockchain);
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
      evento: fields[0] as String,
      data: fields[1] as String,
    )..paths = (fields[2] as List).cast<Path>();
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.evento)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.paths);
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
      comb: fields[1] as String,
      date: fields[2] as String,
      timeless: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PathBlockchain obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dist)
      ..writeByte(1)
      ..write(obj.comb)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.timeless);
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
