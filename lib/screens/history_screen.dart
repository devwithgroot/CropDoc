// import 'package:flutter/material.dart';
// import '../services/storage_service.dart';
// import '../models/diagnosis_model.dart';

// class HistoryScreen extends StatelessWidget {
//   const HistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<DiagnosisModel> history = StorageService().getAllDiagnoses();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Diagnosis History")),
//       body: history.isEmpty
//           ? const Center(child: Text("No history found."))
//           : ListView.builder(
//               itemCount: history.length,
//               itemBuilder: (context, index) {
//                 final item = history[index];

//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   child: Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             item.disease,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Confidence: ${(item.confidence * 100).toStringAsFixed(2)}%",
//                             style: const TextStyle(fontSize: 14, color: Colors.black87),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "Date: ${item.dateTime.day}/${item.dateTime.month}/${item.dateTime.year} "
//                             "${item.dateTime.hour}:${item.dateTime.minute.toString().padLeft(2, '0')}",
//                             style: const TextStyle(fontSize: 12, color: Colors.grey),
//                           ),
//                           const SizedBox(height: 12),
//                           _infoRow("Cause", item.cause, Colors.orange),
//                           _infoRow("Symptoms", item.symptoms, Colors.deepPurple),
//                           _infoRow("Cure", item.cure, Colors.teal),
//                           _infoRow("Treatment", item.treatment, Colors.redAccent),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   Widget _infoRow(String title, String value, Color color) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
//           ),
//           const SizedBox(height: 4),
//           Text(value, style: const TextStyle(fontSize: 14)),
//         ],
//       ),
//     );
//   }
// }


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
      appBar: AppBar(title: const Text("Diagnosis History")),
      body: history.isEmpty
          ? const Center(child: Text("No history found."))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final isExpanded = expandedIndices.contains(index);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            expandedIndices.remove(index);
                          } else {
                            expandedIndices.add(index);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.disease,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Date: ${item.dateTime.day}/${item.dateTime.month}/${item.dateTime.year} "
                              "${item.dateTime.hour}:${item.dateTime.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            if (isExpanded) ...[
                              const Divider(height: 20, color: Colors.black12),
                              _infoRow("Confidence", "${(item.confidence * 100).toStringAsFixed(2)}%", Colors.blueAccent),
                              _infoRow("Cause", item.cause, Colors.orange),
                              _infoRow("Symptoms", item.symptoms, Colors.deepPurple),
                              _infoRow("Cure", item.cure, Colors.teal),
                              _infoRow("Treatment", item.treatment, Colors.red),
                            ],
                            Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _infoRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
