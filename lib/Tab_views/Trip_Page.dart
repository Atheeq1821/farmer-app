import 'dart:convert';
import 'dart:io';

import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'Rough_viewriskassessment.dart';

class RiskAssessment extends StatefulWidget {
  @override
  _RiskAssessmentState createState() => _RiskAssessmentState();
}

class _RiskAssessmentState extends State<RiskAssessment> {
  String? cropVariety;
  String? previousCrop;
  String? seedType;
  String? landMethod;
  String? farmerCorrect;
  File? _capturedImage;
  String? _imageBase64;

  final List<String> cropOptions = ['Paddy', 'Wheat', 'Millet'];
  final List<String> prevCropOptions = ['Cotton', 'Sugarcane', 'Groundnut'];

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox("risk_assessment");
  }


  Future<void> _captureImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final imageTemp = File(pickedFile.path);
      final bytes = await imageTemp.readAsBytes();
      setState(() {
        _capturedImage = imageTemp;
        _imageBase64 = base64Encode(bytes);
      });
    }
  }




  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );
  }

  void _saveDataToHive() async {
    _showLoadingDialog();
    try {
      final box = Hive.box("risk_assessment");

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw "Location services are disabled.";

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw "Location permission denied.";
      }
      if (permission == LocationPermission.deniedForever) {
        throw "Location permission permanently denied.";
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      List existingList = box.get("entries", defaultValue: []);

      existingList.add({
        "cropVariety": cropVariety,
        "previousCrop": previousCrop,
        "seedType": seedType,
        "landMethod": landMethod,
        "farmerCorrect": farmerCorrect,
        "imageBase64": _imageBase64,
        "timestamp": DateTime.now().toIso8601String(),
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
      });

      await box.put("entries", existingList);

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Assessment saved!")),
      );

      setState(() {
        cropVariety = null;
        previousCrop = null;
        seedType = null;
        landMethod = null;
        farmerCorrect = null;
        _capturedImage = null;
        _imageBase64 = null;
      });
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget buildDropdown(String hint, List<String> options, String? value,
      void Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade100),
        borderRadius: BorderRadius.circular(8),
        color: Colors.green.shade50,
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint),
        isExpanded: true,
        underline: SizedBox(),
        items: options
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildToggleGroup(String label, List<String> options, String? selected,
      void Function(String) onSelected) {
    return Wrap(
      spacing: 8,
      children: options.map((e) {
        final isSelected = selected == e;
        return ChoiceChip(
          label: Text(e),
          selected: isSelected,
          onSelected: (_) => onSelected(e),
          selectedColor: Colors.green.shade300,
          backgroundColor: Colors.green.shade50,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Risk-Assessment", style: TextStyle(color: AppPallete.bgColor)),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.menu),
          )
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo/logo_svastha.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
        backgroundColor: AppPallete.color2,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "Visit no : 1\nPre-Sowing / Seedling stage survey",
              style: TextStyle(color: Colors.green[900]),
            ),
            SizedBox(height: 20),

            Text("1. What is the crop variety used ?"),
            SizedBox(height: 8),
            buildDropdown("-- Tap to select --", cropOptions, cropVariety,
                    (val) => setState(() => cropVariety = val)),

            SizedBox(height: 20),

            Text("2. What is the previous crop?"),
            SizedBox(height: 8),
            buildDropdown("-- Tap to select --", prevCropOptions, previousCrop,
                    (val) => setState(() => previousCrop = val)),

            SizedBox(height: 20),

            Text("3. Are you using certified seeds?"),
            SizedBox(height: 8),
            buildToggleGroup("Seed Type", ["Certified", "Not Certified"],
                seedType, (val) => setState(() => seedType = val)),

            SizedBox(height: 20),

            Text("4. Land preparation methods"),
            SizedBox(height: 8),
            buildToggleGroup("Land Method", ["NO", "Fym/Com", "Mixed"],
                landMethod, (val) => setState(() => landMethod = val)),

            SizedBox(height: 20),

            Text("5. Is Farmers provided details correct or not?"),
            SizedBox(height: 8),
            buildToggleGroup("Farmer Details", ["Yes", "Not sure", "No"],
                farmerCorrect, (val) => setState(() => farmerCorrect = val)),

            SizedBox(height: 30),

            Text("6. Capture a photo of the crop/field"),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _captureImage,
              icon: Icon(Icons.camera_alt),
              label: Text("Capture Image"),
              style: ElevatedButton.styleFrom(backgroundColor: AppPallete.color2),
            ),
            if (_capturedImage != null) ...[
              SizedBox(height: 10),
              Center(
                child: Container(
                  height: 150,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _capturedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveDataToHive,
              child: Text("Save Assessment", style: TextStyle(color: AppPallete.color2)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ViewRiskAssessmentScreen()),
                );
              },
              child: Text("View Saved Data", style: TextStyle(color: AppPallete.color2)),
            ),
          ],
        ),
      ),
    );
  }
}
