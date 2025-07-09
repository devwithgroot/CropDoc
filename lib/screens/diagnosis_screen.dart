import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class DiagnosisScreen extends StatefulWidget {
  final File imageFile;

  const DiagnosisScreen({super.key, required this.imageFile});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  Interpreter? _interpreter;
  List<dynamic>? _results;
  bool _isLoading = true;
  String? _error;

  // ignore: constant_identifier_names
  static const int INPUT_SIZE = 224;

  final List<String> _labels = [
    'Healthy',
    'Early blight',
    'Late blight',
    'Leaf Miner',
    'Magnesium Deficiency',
    'Potassium Deficiency',
    'Spotted Wilt Virus',
    'Yellow Leaf Curl Virus',
  ];

  @override
  void initState() {
    super.initState();
    _loadModelAndProcessImage();
  }

  Future<void> _loadModelAndProcessImage() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      await _processImage();
    } catch (e) {
      setState(() {
        _error = 'Failed to load TFLite model: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _processImage() async {
    if (_interpreter == null) {
      setState(() {
        _error = 'TFLite interpreter not loaded.';
        _isLoading = false;
      });
      return;
    }

    try {
      final Uint8List imageBytes = await widget.imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        setState(() {
          _error = 'Failed to decode image.';
          _isLoading = false;
        });
        return;
      }

      img.Image resizedImage = img.copyResize(
        originalImage,
        width: INPUT_SIZE,
        height: INPUT_SIZE,
      );

      Float32List inputBytes =
          Float32List(1 * INPUT_SIZE * INPUT_SIZE * 3); // 1x224x224x3
      int pixelIndex = 0;
      for (int y = 0; y < INPUT_SIZE; y++) {
        for (int x = 0; x < INPUT_SIZE; x++) {
          final pixel = resizedImage.getPixel(x, y);
          final r = pixel.r.toDouble();
          final g = pixel.g.toDouble();
          final b = pixel.b.toDouble();

          inputBytes[pixelIndex++] = r / 255.0;
          inputBytes[pixelIndex++] = g / 255.0;
          inputBytes[pixelIndex++] = b / 255.0;
        }
      }

      List<List<List<List<double>>>> input = [
        List.generate(
          INPUT_SIZE,
          (y) => List.generate(
            INPUT_SIZE,
            (x) => List.generate(
              3,
              (c) => inputBytes[y * INPUT_SIZE * 3 + x * 3 + c],
            ),
          ),
        )
      ];

      final outputTensorShape = _interpreter!.getOutputTensor(0).shape;
      final numClasses = outputTensorShape.last;
      List<List<double>> output = [List.filled(numClasses, 0.0)];

      _interpreter?.run(input, output);

      setState(() {
        _results = output[0];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to process image with TFLite: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagnosis Results"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: $_error',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _results == null || _results!.isEmpty
                  ? const Center(
                      child: Text(
                        "No results found.",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Builder(
                      builder: (context) {
                        final List<double> resultList =
                            _results!.cast<double>();
                        final maxConfidence = resultList.reduce(
                            (a, b) => a > b ? a : b);
                        final maxIndex = resultList.indexOf(maxConfidence);
                        final label = (maxIndex < _labels.length)
                            ? _labels[maxIndex]
                            : 'Unknown';

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Diagnosis Result',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Disease: $label',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Confidence: ${(maxConfidence * 100).toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
