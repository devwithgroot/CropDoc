// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnosis_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiagnosisModelAdapter extends TypeAdapter<DiagnosisModel> {
  @override
  final int typeId = 0;

  @override
  DiagnosisModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiagnosisModel(
      disease: fields[0] as String,
      confidence: fields[1] as double,
      dateTime: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DiagnosisModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.disease)
      ..writeByte(1)
      ..write(obj.confidence)
      ..writeByte(2)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiagnosisModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
