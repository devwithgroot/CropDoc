import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cropdoc/ml/model_service.dart';
import 'package:cropdoc/services/cloud_service.dart';
import 'package:cropdoc/services/storage_service.dart';
import 'package:cropdoc/models/diagnosis_model.dart';

class DiagnosisScreen extends StatefulWidget {
  final File imageFile;

  const DiagnosisScreen({super.key, required this.imageFile});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  String? _diagnosisResult;
  double? _confidence;
  Map<String, dynamic>? _diseaseInfo;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _performDiagnosis();
  }

  Future<void> _performDiagnosis() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _diagnosisResult = null;
      _confidence = null;
      _diseaseInfo = null;
    });

    try {
      final modelService = ModelService();
      await modelService.init();

      final result = await modelService.predict(widget.imageFile);

      if (result.isEmpty) {
        setState(() {
          _error = 'No results found.';
          _isLoading = false;
        });
        return;
      }

      final best = result.entries.reduce((a, b) => a.value > b.value ? a : b);

      final cloudService = CloudService();
      final info = await cloudService.getDiseaseInfo(best.key);

      setState(() {
        _diagnosisResult = best.key;
        _confidence = best.value;
        _diseaseInfo = info;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error during diagnosis: $e';
        _isLoading = false;
      });
    }
  }

  Widget buildInfoCard(String title, String value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color.withOpacity(0.1),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: color)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  void _showSaveDialog() {
    if (_diseaseInfo == null || _diagnosisResult == null || _confidence == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Diagnosis info not available to save.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Save Report?"),
        content: const Text("Do you want to save this diagnosis report to history?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No")),
          TextButton(
            onPressed: () {
              final diagnosis = DiagnosisModel(
                disease: _diagnosisResult!,
                confidence: _confidence!,
                dateTime: DateTime.now(),
                cause: _diseaseInfo!['cause'] ?? 'N/A',
                symptoms: _diseaseInfo!['symptoms'] ?? 'N/A',
                cure: _diseaseInfo!['cure'] ?? 'N/A',
                treatment: _diseaseInfo!['treatment'] ?? 'N/A',
              );

              StorageService().saveDiagnosis(diagnosis);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Diagnosis saved!")),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Diagnosis Result")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _diagnosisResult == null
                  ? const Center(child: Text("No diagnosis result found."))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Diagnosis Result',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Disease: $_diagnosisResult',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Confidence: ${(_confidence! * 100).toStringAsFixed(2)}%',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.save),
                                    label: const Text("Save Diagnosis"),
                                    onPressed: _showSaveDialog,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_diseaseInfo != null) ...[
                            buildInfoCard('Cause', _diseaseInfo!['cause'] ?? 'N/A', Colors.orange),
                            buildInfoCard('Symptoms', _diseaseInfo!['symptoms'] ?? 'N/A', Colors.deepPurple),
                            buildInfoCard('Cure', _diseaseInfo!['cure'] ?? 'N/A', Colors.teal),
                            buildInfoCard('Treatment', _diseaseInfo!['treatment'] ?? 'N/A', Colors.red),
                          ],
                        ],
                      ),
                    ),
    );
  }
}
