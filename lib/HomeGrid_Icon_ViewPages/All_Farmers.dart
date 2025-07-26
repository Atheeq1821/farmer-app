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
  int currentPage = 1;
  int itemsPerPage = 10;

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
      currentPage = 1;
    });
  }

  List get paginatedFarmers {
    final start = (currentPage - 1) * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, farmers.length);
    return farmers.sublist(start, end);
  }

  int get totalPages => (farmers.length / itemsPerPage).ceil();

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
            const Text('All Farmers', style: TextStyle(color: AppPallete.bgColor,fontWeight: FontWeight.bold)),
            const Spacer(),
            DropdownButton<int>(
              dropdownColor: AppPallete.color2,
              value: itemsPerPage,
              style: const TextStyle(color: Colors.white),
              underline: SizedBox(),
              iconEnabledColor: Colors.white,
              items: [10, 25, 50, 100].map((value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text("Show $value"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  itemsPerPage = value!;
                  currentPage = 1;
                });
              },
            ),
          ],
        ),
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

      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/elements/Background.png'),fit: BoxFit.fill)
        ),
        child: farmers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: paginatedFarmers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final farmer = paginatedFarmers[index];
                  final name = farmer['farmer'] ?? {};
                  final location = farmer['location'] ?? {};
                  final cropInfo = farmer['crop_info'] ?? {};
                  final chemical = farmer['chemical'] ?? {};

                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        isScrollControlled: true,
                        builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 40,
                                      height: 4,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Text(name['name'] ?? 'Farmer Name',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  const SizedBox(height: 8),
                                  Text("👤 Father: ${name['father_name'] ?? 'N/A'}"),
                                  Text("🆔 Code: ${farmer['code'] ?? 'N/A'}"),
                                  Text("📍 District: ${location['district'] ?? 'N/A'}"),
                                  Text("🏡 Village: ${location['village'] ?? 'N/A'}"),
                                  Text("📦 Area: ${farmer['acre'] ?? 'N/A'}"),
                                  Text("👨‍🔬 Assigned To: ${farmer['assigned_to'] ?? 'N/A'}"),
                                  const Divider(),
                                  Text("🌱 Sowing Date: ${cropInfo['sowing_date']?.toString().split('T').first ?? 'N/A'}"),
                                  Text("🌾 Harvest Status: ${cropInfo['harvest_status'] ?? 'N/A'}"),
                                  Text("📉 Risk Status: ${farmer['risk_status'] ?? 'N/A'}"),
                                  const Divider(),
                                  Text("🧪 Chemical: ${chemical['name'] ?? 'N/A'}"),
                                  Text("🧪 Date: ${chemical['application_date']?.toString().split('T').first ?? 'N/A'}"),
                                  Text("📝 Remarks: ${farmer['remarks'] ?? 'N/A'}"),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 78,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(184, 246, 168, 1.0),
                        borderRadius: BorderRadius.circular(8),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${((currentPage - 1) * itemsPerPage) + index + 1}. ",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name['name'] ?? 'Farmer Name',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "${farmer['code'] ?? 'ID'} |  ${location['village'] ?? 'Village'}, ${location['district'] ?? 'District'}",
                                  style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(

              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.green[300],
              child: Row(
                children: [
                  IconButton(
                    onPressed: currentPage > 1
                        ? () => setState(() => currentPage--)
                        : null,
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(totalPages, (index) {
                          final page = index + 1;
                          return GestureDetector(
                            onTap: () => setState(() => currentPage = page),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: currentPage == page
                                    ? AppPallete.color2
                                    : Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "$page",
                                style: TextStyle(
                                  color: currentPage == page
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: currentPage < totalPages
                        ? () => setState(() => currentPage++)
                        : null,
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// old model

// import 'dart:convert';
// import 'package:farmer_app/core/themes/app_pallete.dart';
// import 'package:flutter/material.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo;
//
// class AllFarmersScreen extends StatefulWidget {
//   const AllFarmersScreen({super.key});
//
//   @override
//   State<AllFarmersScreen> createState() => _AllFarmersScreenState();
// }
//
// class _AllFarmersScreenState extends State<AllFarmersScreen> {
//   List farmers = [];
//   int currentPage = 1;
//   int itemsPerPage = 10;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchFarmers();
//   }
//
//   Future<void> _fetchFarmers() async {
//     final db = await mongo.Db.create("mongodb://admin:svastha%402025@82.25.110.239:27017/agriculture?authSource=admin");
//     await db.open();
//     final collection = db.collection('crops');
//     final data = await collection.find().toList();
//     await db.close();
//
//     setState(() {
//       farmers = data;
//       currentPage = 1;
//     });
//   }
//
//   List get paginatedFarmers {
//     final start = (currentPage - 1) * itemsPerPage;
//     final end = (start + itemsPerPage).clamp(0, farmers.length);
//     return farmers.sublist(start, end);
//   }
//
//   int get totalPages => (farmers.length / itemsPerPage).ceil();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppPallete.color2,
//         automaticallyImplyLeading: false,
//         title: Row(
//           children: [
//             Image.asset('assets/logo/logo_svastha.png', height: 30),
//             const SizedBox(width: 12),
//             const Text('All Farmers', style: TextStyle(color: AppPallete.bgColor,fontWeight: FontWeight.bold),),
//             const Spacer(),
//             DropdownButton<int>(
//               dropdownColor: AppPallete.color2,
//               value: itemsPerPage,
//               style: const TextStyle(color: Colors.white),
//               underline: SizedBox(),
//               iconEnabledColor: Colors.white,
//               items: [10, 25, 50, 100].map((value) {
//                 return DropdownMenuItem<int>(
//                   value: value,
//                   child: Text("Show $value"),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   itemsPerPage = value!;
//                   currentPage = 1;
//                 });
//               },
//             ),
//           ],
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(30),
//           child: Container(
//             width: double.infinity,
//             color: Colors.green[300],
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//             child: Text(
//               "Total farmers - ${farmers.length}",
//               style: const TextStyle(color: Colors.black87),
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: farmers.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           Expanded(
//             child: ListView.separated(
//               padding: const EdgeInsets.all(12),
//               itemCount: paginatedFarmers.length,
//               separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
//               itemBuilder: (context, index) {
//                 final farmer = paginatedFarmers[index];
//                 final name = farmer['farmer'] ?? {};
//                 final location = farmer['location'] ?? {};
//                 final cropInfo = farmer['crop_info'] ?? {};
//                 final chemical = farmer['chemical'] ?? {};
//
//                 return InkWell(
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                       ),
//                       isScrollControlled: true,
//                       builder: (_) {
//                         return Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: SingleChildScrollView(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Center(
//                                   child: Container(
//                                     width: 40,
//                                     height: 4,
//                                     margin: EdgeInsets.only(bottom: 12),
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[300],
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                 ),
//                                 Text(name['name'] ?? 'Farmer Name',
//                                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//                                 SizedBox(height: 8),
//                                 Text("👤 Father: ${name['father_name'] ?? 'N/A'}"),
//                                 Text("🆔 Code: ${farmer['code'] ?? 'N/A'}"),
//                                 Text("📍 District: ${location['district'] ?? 'N/A'}"),
//                                 Text("🏡 Village: ${location['village'] ?? 'N/A'}"),
//                                 Text("📦 Area: ${farmer['acre'] ?? 'N/A'}"),
//                                 Text("👨‍🔬 Assigned To: ${farmer['assigned_to'] ?? 'N/A'}"),
//                                 Divider(),
//                                 Text("🌱 Sowing Date: ${cropInfo['sowing_date']?.toString().split('T').first ?? 'N/A'}"),
//                                 Text("🌾 Harvest Status: ${cropInfo['harvest_status'] ?? 'N/A'}"),
//                                 Text("📉 Risk Status: ${farmer['risk_status'] ?? 'N/A'}"),
//                                 Divider(),
//                                 Text("🧪 Chemical: ${chemical['name'] ?? 'N/A'}"),
//                                 Text("🧪 Date: ${chemical['application_date']?.toString().split('T').first ?? 'N/A'}"),
//                                 Text("📝 Remarks: ${farmer['remarks'] ?? 'N/A'}"),
//                                 SizedBox(height: 20),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "${((currentPage - 1) * itemsPerPage) + index + 1}.",
//                         style: const TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           "${name['name'] ?? 'name'} - ${farmer['code'] ?? 'ID'} - ${location['district'] ?? 'District'} - ${location['village'] ?? 'Village'}",
//                           style: const TextStyle(fontSize: 15),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 12),
//             color: Colors.grey[100],
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   onPressed: currentPage > 1
//                       ? () => setState(() => currentPage--)
//                       : null,
//                   icon: Icon(Icons.arrow_back_ios),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: List.generate(totalPages, (index) {
//                         final page = index + 1;
//                         return GestureDetector(
//                           onTap: () => setState(() => currentPage = page),
//                           child: Container(
//                             margin: EdgeInsets.symmetric(horizontal: 4),
//                             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: currentPage == page ? AppPallete.color2 : Colors.white,
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               "$page",
//                               style: TextStyle(
//                                 color: currentPage == page ? Colors.white : Colors.black,
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: currentPage < totalPages
//                       ? () => setState(() => currentPage++)
//                       : null,
//                   icon: Icon(Icons.arrow_forward_ios),
//                 ),
//               ],
//             ),
//           )
//
//
//         ],
//       ),
//     );
//   }
// }
