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

  DiagnosisModel({
    required this.disease,
    required this.confidence,
    required this.dateTime,
  });
}
