#  CropDoc – Plant Disease Detection

CropDoc is a Flutter-based mobile app that helps farmers and gardeners identify plant diseases from images using on-device machine learning. Built for speed, offline access, and future scalability.

---

## 🔧 Features

-  Capture or upload plant images
-  On-device disease prediction using TFLite
-  Shows disease name & confidence
-  Lists causes and remedies
-  Stores diagnosis history locally (Hive)

---

##  Tech Stack

- **Flutter** (with null safety)
- **TensorFlow Lite** (for local ML inference)
- **Hive** (local storage for history)
- **image_picker**, **permission_handler**

---

##  Getting Started

```bash
flutter pub get
flutter run
```
> Place your .tflite model in assets/model/

##  Project Structure
```
lib/
├── main.dart
├── models/
│   └── diagnosis.dart          # DiseaseResult model (same for local + cloud)
├── services/
│   ├── storage_service.dart    # LOCAL (Hive)
│   └── cloud_service.dart      # Placeholder for Firebase (future)
├── screens/
│   ├── home_screen.dart
│   ├── image_preview_screen.dart
│   ├── diagnosis_screen.dart
│   └── history_screen.dart
├── widgets/
│   └── result_card.dart
├── ml/
│   └── model_service.dart      # TFLite loading/inference
```

##  Author

Developed by [Sandeep](https://github.com/devwithgroot)

