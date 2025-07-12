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

  void _saveToHistory() {
    if (_diseaseInfo == null || _diagnosisResult == null || _confidence == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Diagnosis info not available to save.")),
      );
      return;
    }

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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Diagnosis saved to history!")),
    );
  }

  Widget _buildConfidenceIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            value: _confidence!,
            strokeWidth: 10,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
        ),
        Text(
          "${(_confidence! * 100).toStringAsFixed(1)}%",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String title, String value, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(value, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Diagnosis Result",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildConfidenceIndicator(),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _diagnosisResult!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F9F5),
      appBar: AppBar(
        title: const Text(
          'Diagnosis Result 🌿',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      floatingActionButton: _isLoading || _diagnosisResult == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _saveToHistory,
              icon: const Icon(Icons.save_alt),
              label: const Text("Save to History"),
              backgroundColor: Colors.teal.shade50,
            ),
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
                  ? const Center(child: Text("No result found"))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDiagnosisCard(),
                          const SizedBox(height: 24),
                          if (_diseaseInfo != null) ...[
                            _buildInfoTile('Cause', _diseaseInfo!['cause'] ?? 'N/A', Colors.orange),
                            _buildInfoTile('Symptoms', _diseaseInfo!['symptoms'] ?? 'N/A', Colors.deepPurple),
                            _buildInfoTile('Cure', _diseaseInfo!['cure'] ?? 'N/A', Colors.teal),
                            _buildInfoTile('Treatment', _diseaseInfo!['treatment'] ?? 'N/A', Colors.red),
                          ],
                        ],
                      ),
                    ),
    );
  }
}
