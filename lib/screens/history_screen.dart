import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/diagnosis_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<DiagnosisModel> history = StorageService().getAllDiagnoses();
  final Set<int> expandedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Diagnosis History 🌿',
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
      body: history.isEmpty
          ? const Center(
              child: Text(
                "No history found.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final isExpanded = expandedIndices.contains(index);
                final confidence = (item.confidence * 100).toStringAsFixed(1);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 3,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        isExpanded
                            ? expandedIndices.remove(index)
                            : expandedIndices.add(index);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Circular confidence indicator
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 65,
                                    width: 65,
                                    child: CircularProgressIndicator(
                                      value: item.confidence,
                                      strokeWidth: 6,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                                    ),
                                  ),
                                  Text(
                                    "$confidence%",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.disease,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Diagnosed on: ${item.dateTime.day}/${item.dateTime.month}/${item.dateTime.year} "
                                      "${item.dateTime.hour}:${item.dateTime.minute.toString().padLeft(2, '0')}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isExpanded ? Icons.expand_less : Icons.expand_more,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                          if (isExpanded) ...[
                            const Divider(height: 30),
                            _buildInfoSection("Cause", item.cause, Colors.orange),
                            _buildInfoSection("Symptoms", item.symptoms, Colors.deepPurple),
                            _buildInfoSection("Cure", item.cure, Colors.green),
                            _buildInfoSection("Treatment", item.treatment, Colors.redAccent),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoSection(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
