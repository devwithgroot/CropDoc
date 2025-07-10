import 'package:hive/hive.dart';

part 'diagnosis_model.g.dart';

@HiveType(typeId: 0)
class DiagnosisModel extends HiveObject {
  @HiveField(0)
  final String disease;

  @HiveField(1)
  final double confidence;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final String cause;

  @HiveField(4)
  final String symptoms;

  @HiveField(5)
  final String cure;

  @HiveField(6)
  final String treatment;

  DiagnosisModel({
    required this.disease,
    required this.confidence,
    required this.dateTime,
    required this.cause,
    required this.symptoms,
    required this.cure,
    required this.treatment,
  });
}
