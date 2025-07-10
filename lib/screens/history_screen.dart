import 'package:flutter/material.dart';
//import '../models/diagnosis_model.dart';
import '../services/storage_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = StorageService().getAllDiagnoses();

    return Scaffold(
      appBar: AppBar(title: const Text("Diagnosis History")),
      body: history.isEmpty
          ? const Center(child: Text("No history found."))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(item.disease),
                    subtitle: Text("Confidence: ${(item.confidence * 100).toStringAsFixed(2)}%"),
                    trailing: Text(
                      "${item.dateTime.day}/${item.dateTime.month} ${item.dateTime.hour}:${item.dateTime.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
