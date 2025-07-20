import 'package:flutter/material.dart';
import '../../../HomeGrid_Icon_ViewPages/All_Farmers.dart';
import '../map_container/farmer_route_map.dart';
import 'package:farmer_app/core/themes/app_pallete.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Dummy data rows (add dynamically if needed)
  final List<List<String>> farmerData = [
    ['1. Farmer 1', 'District', 'Village'],
    ['2. Farmer 2', 'District', 'Village'],
    ['3. Farmer 3', 'District', 'Village'],
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppPallete.color2,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo/logo_svastha.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(Icons.menu, color: Colors.white),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: BoxDecoration(color: AppPallete.color2),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.green),
                  ),
                  SizedBox(width: 20),
                  Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade800, Colors.green.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Welcome user name", style: TextStyle(color: Colors.white)),
                    Text("Role in Svastha", style: TextStyle(color: Colors.white)),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'TODAYS FARMERS ENROLEMENT',
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 100,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppPallete.color3,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text("Date", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Table(
                              columnWidths: const {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    tableHeaderCell("Farmer name"),
                                    tableHeaderCell("District"),
                                    tableHeaderCell("Village"),
                                  ],
                                ),
                                ...farmerData.map((row) => TableRow(
                                  children: row
                                      .map((cell) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 4),
                                    child: Text(cell, textAlign: TextAlign.center),
                                  ))
                                      .toList(),
                                )),
                              ],
                            ),
                             // Your custom map widget
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                FarmerRouteMap(),
                SizedBox(height: 30),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 16,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    dashboardItem(Icons.track_changes, "My Farmers"),
                    dashboardItem(Icons.add_box, "Add New"),
                    dashboardItem(Icons.pedal_bike, "Pending"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AllFarmersScreen()),
                        );
                      },
                      child: dashboardItem(Icons.groups, "All Farmers"),
                    ),
                    dashboardItem(Icons.warning_amber, "Risk Manage"),
                    dashboardItem(Icons.work_history, "My works"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tableHeaderCell(String text) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(text, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
  );

  Widget dashboardItem(IconData iconData, String title) {
    return Container(
      width: 120,
      height: 120,
      // margin: const EdgeInsets.all(5),

      decoration: BoxDecoration(
        color: AppPallete.bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(

              decoration: BoxDecoration(
              color: AppPallete.color1,
                borderRadius: BorderRadius.circular(18)
              ),  
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 30,
                // padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(0),
                    top: Radius.circular(4)
                  ),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
