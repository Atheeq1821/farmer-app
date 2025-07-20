import 'dart:convert';
import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class AllFarmersScreen extends StatefulWidget {
  const AllFarmersScreen({super.key});

  @override
  State<AllFarmersScreen> createState() => _AllFarmersScreenState();
}

class _AllFarmersScreenState extends State<AllFarmersScreen> {
  List farmers = [];

  @override
  void initState() {
    super.initState();
    _fetchFarmers();
  }

  Future<void> _fetchFarmers() async {
    final db = await mongo.Db.create("mongodb://admin:svastha%402025@82.25.110.239:27017/agriculture?authSource=admin");
    await db.open();
    final collection = db.collection('crops');
    final data = await collection.find().toList();
    await db.close();

    setState(() {
      farmers = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.color2,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/logo/logo_svastha.png', height: 30),
            const SizedBox(width: 12),
            const Text('All Farmers', style: TextStyle(color: AppPallete.bgColor,fontWeight: FontWeight.bold),),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            width: double.infinity,
            color: Colors.green[300],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              "Total farmers - ${farmers.length}",
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: farmers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: farmers.length,
        separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final farmer = farmers[index];
          final name = farmer['farmer'] ?? {};
          final location = farmer['location'] ?? {};
          final cropInfo = farmer['crop_info'] ?? {};
          final chemical = farmer['chemical'] ?? {};

          return InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                isScrollControlled: true,
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Text(name['name'] ?? 'Farmer Name',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 8),
                          Text("👤 Father: ${name['father_name'] ?? 'N/A'}"),
                          Text("🆔 Code: ${farmer['code'] ?? 'N/A'}"),
                          Text("📍 District: ${location['district'] ?? 'N/A'}"),
                          Text("🏡 Village: ${location['village'] ?? 'N/A'}"),
                          Text("📦 Area: ${farmer['acre'] ?? 'N/A'}"),
                          Text("👨‍🔬 Assigned To: ${farmer['assigned_to'] ?? 'N/A'}"),
                          Divider(),
                          Text("🌱 Sowing Date: ${cropInfo['sowing_date']?.toString().split('T').first ?? 'N/A'}"),
                          Text("🌾 Harvest Status: ${cropInfo['harvest_status'] ?? 'N/A'}"),
                          Text("📉 Risk Status: ${farmer['risk_status'] ?? 'N/A'}"),
                          Divider(),
                          Text("🧪 Chemical: ${chemical['name'] ?? 'N/A'}"),
                          Text("🧪 Date: ${chemical['application_date']?.toString().split('T').first ?? 'N/A'}"),
                          Text("📝 Remarks: ${farmer['remarks'] ?? 'N/A'}"),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              );
            },

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}.",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${name['name'] ?? 'name'} - ${farmer['code'] ?? 'ID'} - ${location['district'] ?? 'District'} - ${location['village'] ?? 'Village'}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        },

      ),
    );
  }
}
