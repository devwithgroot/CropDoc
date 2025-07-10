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
      cause: fields[3] as String,
      symptoms: fields[4] as String,
      cure: fields[5] as String,
      treatment: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DiagnosisModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.disease)
      ..writeByte(1)
      ..write(obj.confidence)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.cause)
      ..writeByte(4)
      ..write(obj.symptoms)
      ..writeByte(5)
      ..write(obj.cure)
      ..writeByte(6)
      ..write(obj.treatment);
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
