// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pidDiscoveryClass.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class pidsDiscAdapter extends TypeAdapter<pidsDisc> {
  @override
  final int typeId = 11;

  @override
  pidsDisc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return pidsDisc(
      pid: fields[0] as String,
      title: fields[1] as String,
    )
      ..lenght = fields[2] as int
      ..unit = fields[3] as String
      ..description = fields[4] as String
      ..status = fields[5] as bool
      ..ativo = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, pidsDisc obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.pid)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.lenght)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.ativo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is pidsDiscAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
