import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ViewRiskAssessmentScreen extends StatefulWidget {
  @override
  _ViewRiskAssessmentScreenState createState() => _ViewRiskAssessmentScreenState();
}

class _ViewRiskAssessmentScreenState extends State<ViewRiskAssessmentScreen> {
  List assessments = [];

  @override
  void initState() {
    super.initState();
    _loadAssessments();
  }

  Future<void> _loadAssessments() async {
    final box = Hive.box("risk_assessment");
    final data = box.get("entries", defaultValue: []);
    setState(() {
      assessments = List.from(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Risk Assessments"),
        backgroundColor: Colors.green[800],
      ),
      body: assessments.isEmpty
          ? Center(child: Text("No assessments found."))
          : ListView.builder(
        itemCount: assessments.length,
        itemBuilder: (context, index) {
          final item = assessments[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Crop Variety: ${item['cropVariety'] ?? 'N/A'}"),
                  Text("Previous Crop: ${item['previousCrop'] ?? 'N/A'}"),
                  Text("Seed Type: ${item['seedType'] ?? 'N/A'}"),
                  Text("Land Method: ${item['landMethod'] ?? 'N/A'}"),
                  Text("Farmer Correct: ${item['farmerCorrect'] ?? 'N/A'}"),
                  Text("Timestamp: ${item['timestamp'] ?? 'N/A'}"),
                ],
              ),
            ),
          );
        },

      ),

    );
  }
}
