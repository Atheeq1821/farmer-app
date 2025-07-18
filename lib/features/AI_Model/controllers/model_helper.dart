import 'dart:typed_data';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:image/image.dart' as img;

class ModelHelper {
  late OnnxRuntime _ort;
  late OrtSession _session; // Use OrtSession for the session type

  Future<void> loadModel() async {
    _ort = OnnxRuntime();
    _session = await _ort.createSessionFromAsset('assets/model/mobilenet_v3_quantized.onnx');
  }

  Future<String> runModelOnImage(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) return "Invalid image";

    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    // Create Float32 input [1, 3, 224, 224]
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
    final outputs = await _session.run(inputs);  // Use _session here
    final outputList = await outputs.values.first.asList();

    int predictedIndex = outputList[0][0] > outputList[0][1] ? 0 : 1;
    return predictedIndex == 0 ? "Leaf" : "Not a Leaf";
  }
}
