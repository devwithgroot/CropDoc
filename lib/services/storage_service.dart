import 'package:hive/hive.dart';
import '../models/diagnosis_model.dart';

class StorageService {
  final Box<DiagnosisModel> _box = Hive.box<DiagnosisModel>('diagnosisBox');

  void saveDiagnosis(DiagnosisModel diagnosis) {
    _box.add(diagnosis);
  }

  List<DiagnosisModel> getAllDiagnoses() {
    return _box.values.toList().reversed.toList();
  }
}
