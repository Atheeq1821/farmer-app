import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:image/image.dart' as img;

class ModelHelper {
  late OnnxRuntime _ort;
  late OrtSession _session;

  Future<void> loadModel() async {
    _ort = OnnxRuntime();
    _session = await _ort.createSessionFromAsset('assets/model/mobilenet_v3_quantized.onnx');
  }

  // Helper function for softmax
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

    // Print all output tensors
    print('Total outputs: ${outputs.length}');
    for (final name in outputs.keys) {
      final value = outputs[name];
      final data = await value!.asList();
      print("Output '$name': $data");
    }

    // For prediction, use the first output (update if your logic changes)
    final firstOutput = await outputs.values.first.asList();
    // Flatten: [ [x, y] ] -> [x, y]
    List<double> flatLogits = (firstOutput as List)
        .expand((v) => (v as List).cast<double>())
        .toList();

    // Print logits
    print('Logits: $flatLogits');

    // Calculate softmax probabilities
    List<double> probs = softmax(flatLogits);
    print('Softmax probabilities: $probs');

    // Get highest probability and its class
    int predictedIndex = probs.indexOf(probs.reduce(math.max));
    double predictedProb = probs[predictedIndex];
    int finalprobability = predictedProb.round();
    print('finalprobability : $finalprobability');
    String predictedClass = predictedProb*100 >= 70 ? "Leaf" : "Not a Leaf";

    print('Predicted class: $predictedClass');
    print('Probability for predicted class: $predictedProb');

    // Optionally, return both the class and probability
    return "$predictedClass (probability: ${(predictedProb * 100).toStringAsFixed(2)}%)";
  }
}
