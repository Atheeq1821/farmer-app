import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../features/AI_Model/controllers/model_helper.dart';

class InputImagePage extends StatefulWidget {
  const InputImagePage({Key? key}) : super(key: key);

  @override
  State<InputImagePage> createState() => _InputImagePageState();
}

class _InputImagePageState extends State<InputImagePage> {
  Uint8List? _imageBytes;
  String? _prediction;
  bool _loading = false;
  final ModelHelper _modelHelper = ModelHelper();

  @override
  void initState() {
    super.initState();
    _modelHelper.loadModel();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _prediction = null;
      });
    }
  }

  Future<void> _runModel() async {
    if (_imageBytes == null) return;

    setState(() {
      _loading = true;
    });

    final result = await _modelHelper.runModelOnImage(_imageBytes!);

    setState(() {
      _prediction = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaf Detector')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_imageBytes != null)
              Column(
                children: [
                  Image.memory(_imageBytes!, height: 250),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loading ? null : _runModel,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text('Proceed'),
                  ),
                ],
              )
            else
              const Text('Please select or capture an image.'),
            const SizedBox(height: 20),
            if (_prediction != null)
              Text(
                'Prediction: $_prediction',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}