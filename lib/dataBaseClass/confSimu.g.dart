// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confSimu.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfdataAdapter extends TypeAdapter<Confdata> {
  @override
  final int typeId = 9;

  @override
  Confdata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Confdata(
      rpmmax: fields[1] as double,
      rpmmin: fields[0] as double,
      mafmax: fields[13] as double,
      mafmin: fields[12] as double,
      percentmax: fields[15] as int,
      percentmin: fields[14] as int,
      pressmax: fields[7] as double,
      pressmin: fields[6] as double,
      tempaemax: fields[11] as double,
      tempaemin: fields[10] as double,
      templamax: fields[5] as double,
      templamin: fields[4] as double,
      velomax: fields[3] as int,
      velomin: fields[2] as int,
      vin: fields[8] as String,
      on: fields[16] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Confdata obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.rpmmin)
      ..writeByte(1)
      ..write(obj.rpmmax)
      ..writeByte(2)
      ..write(obj.velomin)
      ..writeByte(3)
      ..write(obj.velomax)
      ..writeByte(4)
      ..write(obj.templamin)
      ..writeByte(5)
      ..write(obj.templamax)
      ..writeByte(6)
      ..write(obj.pressmin)
      ..writeByte(7)
      ..write(obj.pressmax)
      ..writeByte(8)
      ..write(obj.vin)
      ..writeByte(10)
      ..write(obj.tempaemin)
      ..writeByte(11)
      ..write(obj.tempaemax)
      ..writeByte(12)
      ..write(obj.mafmin)
      ..writeByte(13)
      ..write(obj.mafmax)
      ..writeByte(14)
      ..write(obj.percentmin)
      ..writeByte(15)
      ..write(obj.percentmax)
      ..writeByte(16)
      ..write(obj.on);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfdataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
