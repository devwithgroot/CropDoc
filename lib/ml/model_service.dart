import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

class ModelService {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  static const int _inputSize = 224;

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

  Future<void> init() async {
    if (_isModelLoaded) return;

    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      _isModelLoaded = true;
      debugPrint('✅ TFLite model loaded successfully.');
    } catch (e) {
      debugPrint('❌ Failed to load TFLite model: $e');
      rethrow;
    }
  }

  Future<Map<String, double>> predict(File imageFile) async {
    if (!_isModelLoaded || _interpreter == null) {
      throw Exception('Model not loaded. Call init() first.');
    }

    try {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) throw Exception('Failed to decode image.');

      final img.Image resizedImage = img.copyResize(originalImage,
          width: _inputSize, height: _inputSize);

      final Float32List input = Float32List(_inputSize * _inputSize * 3);
      int pixelIndex = 0;

      for (int y = 0; y < _inputSize; y++) {
        for (int x = 0; x < _inputSize; x++) {
          final pixel = resizedImage.getPixel(x, y);
          input[pixelIndex++] = pixel.r / 255.0;
          input[pixelIndex++] = pixel.g / 255.0;
          input[pixelIndex++] = pixel.b / 255.0;
        }
      }

      final inputTensor = input.reshape([1, _inputSize, _inputSize, 3]);
      final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

      _interpreter!.run(inputTensor, output);

      final Map<String, double> results = {};
      for (int i = 0; i < _labels.length; i++) {
        results[_labels[i]] = output[0][i];
      }

      return results;
    } catch (e) {
      debugPrint('❌ Prediction failed: $e');
      rethrow;
    }
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isModelLoaded = false;
    debugPrint('🛑 TFLite interpreter closed.');
  }
}
