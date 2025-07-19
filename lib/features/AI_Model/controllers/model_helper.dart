import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:image/image.dart' as img;

class ModelHelper {
  late OnnxRuntime _ort;
  late OrtSession _session;
  late OrtSession _severitySession;

  Future<void> loadModel() async {
    _ort = OnnxRuntime();
    _session = await _ort.createSessionFromAsset('assets/model/mobilenet_v3_quantized.onnx');
    _severitySession = await _ort.createSessionFromAsset('assets/model/mobilenet_v3_severity_quantized.onnx');
  }

  List<double> softmax(List<double> logits) {
    final exps = logits.map((x) => math.exp(x)).toList();
    final sumExps = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sumExps).toList();
  }

  Future<String> runModelOnImage(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) return "Invalid image";

    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    // Prepare input [1, 3, 224, 224]
    List<List<List<List<double>>>> input = List.generate(
      1, (_) => List.generate(
      3, (_) => List.generate(
      224, (_) => List.filled(224, 0.0),
    ),
    ),
    );

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        var pixel = resizedImage.getPixel(x, y);
        input[0][0][y][x] = pixel.r.toDouble() / 255.0;
        input[0][1][y][x] = pixel.g.toDouble() / 255.0;
        input[0][2][y][x] = pixel.b.toDouble() / 255.0;
      }
    }

    final inputs = {
      'input': await OrtValue.fromList(input, [1, 3, 224, 224]),
    };

    final outputs = await _session.run(inputs);
    final firstOutput = await outputs.values.first.asList();

    List<double> flatLogits = (firstOutput as List)
        .expand((v) => (v as List).cast<double>())
        .toList();

    List<double> probs = softmax(flatLogits);
    int predictedIndex = probs.indexOf(probs.reduce(math.max));
    double predictedProb = probs[predictedIndex];
    String predictedClass = predictedProb * 100 >= 70 ? "Leaf" : "Not a Leaf";

    print('Predicted class: $predictedClass');
    print('Probability for predicted class: $predictedProb');

    if (predictedClass == "Leaf") {
      // Run severity model
      final severityOutputs = await _severitySession.run(inputs);
      final severityRaw = await severityOutputs.values.first.asList();

      List<double> severityLogits = (severityRaw as List)
          .expand((v) => (v as List).cast<double>())
          .toList();

      List<double> severityProbs = softmax(severityLogits);
      int severityIndex = severityProbs.indexOf(severityProbs.reduce(math.max));

      print('[INFO] Inference Results:');
      print(" - Output 'output': shape=(1, ${severityLogits.length}), dtype=float32");
      print("   Raw Output: $severityLogits");
      print("   Softmax Probabilities: $severityProbs");
      print("   Predicted Class: $severityIndex -> severity_$severityIndex");

      return "$predictedClass (probability: ${(predictedProb * 100).toStringAsFixed(2)}%) | Severity: severity_$severityIndex";
    } else {
      return "Not a Leaf. Please retake the picture.";
    }
  }

}

