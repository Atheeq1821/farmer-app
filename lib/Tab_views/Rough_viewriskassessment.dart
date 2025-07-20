import 'dart:convert';
import 'dart:io';

import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ViewRiskAssessmentScreen extends StatefulWidget {
  @override
  _ViewRiskAssessmentScreenState createState() => _ViewRiskAssessmentScreenState();
}

class _ViewRiskAssessmentScreenState extends State<ViewRiskAssessmentScreen> {
  List assessments = [];
  double uploadProgress = 0.0;
  bool isUploadingAll = false;

  @override
  void initState() {
    super.initState();
    _loadAssessments();
  }

  Future<void> _loadAssessments() async {
    final box = Hive.box("risk_assessment");
    setState(() {
      assessments = List.from(box.get("entries", defaultValue: []));
    });
  }

  Future<void> _uploadEntryToMongoDB(int index) async {
    final item = assessments[index];

    try {
      _showUploadDialog();

      final db = await mongo.Db.create("mongodb://admin:svastha%402025@82.25.110.239:27017/agriculture?authSource=admin");
      await db.open();
      final collection = db.collection("visits");

      final document = Map<String, dynamic>.from(item);
      final result = await collection.insertOne(document);
      await db.close();

      Navigator.of(context).pop();

      if (result.isSuccess) {
        setState(() {
          assessments.removeAt(index);
        });

        final box = Hive.box("risk_assessment");
        await box.put("entries", assessments);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Entry uploaded to MongoDB and removed locally.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Upload failed. Not removed.")),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error uploading to MongoDB: $e")),
      );
    }
  }

  Future<void> _uploadAllEntries() async {
    if (assessments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No datas are avilable")),
    );
      return;
    }
    setState(() => isUploadingAll = true);

    final db = await mongo.Db.create("mongodb://admin:svastha%402025@82.25.110.239:27017/agriculture?authSource=admin");
    await db.open();
    final collection = db.collection("visits");

    for (int i = 0; i < assessments.length; i++) {
      final item = Map<String, dynamic>.from(assessments[i]);
      try {
        await collection.insertOne(item);
      } catch (e) {
        print("Upload failed for index $i: $e");
      }
      setState(() {
        uploadProgress = (i + 1) / assessments.length;
      });
    }

    await db.close();

    setState(() {
      assessments.clear();
      isUploadingAll = false;
    });
    final box = Hive.box("risk_assessment");
    await box.put("entries", assessments);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ All entries uploaded successfully.")),
    );
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _deleteEntry(int index) async {
    setState(() {
      assessments.removeAt(index);
    });

    final box = Hive.box("risk_assessment");
    await box.put("entries", assessments);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Entry deleted.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Assessments"),
        backgroundColor: Colors.green[800],
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_upload),
            tooltip: "Upload All",
            onPressed: _uploadAllEntries,
          )
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: assessments.length,
            itemBuilder: (context, index) {
              final item = assessments[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item['imageBase64'] != null && item['imageBase64'].toString().isNotEmpty)
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 200,
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              base64Decode(item['imageBase64']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ListTile(
                      title: Text("Crop: ${item['cropVariety']} \nPrev: ${item['previousCrop']}\nSeed: ${item['seedType']} \nLand: ${item['landMethod']} \nFarmer: ${item['farmerCorrect']}"),
                      subtitle: Text("Time: ${item['timestamp']}\nLat: ${item['latitude']}\nLong: ${item['longitude']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.cloud_upload, color: Colors.green),
                            onPressed: () => _uploadEntryToMongoDB(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEntry(index),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (isUploadingAll)
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                padding: EdgeInsets.all(16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: uploadProgress,
                      strokeWidth: 6,
                    ),
                    Text(
                      "${(uploadProgress * 100).toStringAsFixed(1)}%",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )

        ],
      ),
    );
  }
}
