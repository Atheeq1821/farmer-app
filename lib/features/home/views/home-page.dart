import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:farmer_app/features/home/views/page_navi.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: AppPallete.bgColor,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: BoxDecoration(color: AppPallete.color2),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                  SizedBox(width: 20,),
                  Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
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
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hello UserName",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          
                          ),
                          Text(
                            "Role in svastha",
                            style: TextStyle(
                              color: Colors.black
                            ),
                            )
                      
                        ],
                      ),
                      SizedBox(height: 25,),
                      Text(
                        'TODAY\'S FARMERS ENROLEMENT',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.w700,
                          color: AppPallete.color2,
                          fontSize: 32,
                        ),
                      ),
                      Container(
                        
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        alignment: Alignment.centerRight,
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
                                    bottomLeft: Radius.circular(20) 
                                  )
                                ),
                                child: Center(child: Text("Date",style: TextStyle(color: Colors.white),)),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Table(
                              // border: TableBorder.all(color: Colors.grey,width: 1),
                              columnWidths: const{
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(
                                  // decoration: BoxDecoration(color: AppPallete.color2),
                                  children:[
                                    Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: Text('Farmer name', style: TextStyle(fontWeight: FontWeight.bold, ),textAlign: TextAlign.center,),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: Text('District', style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: Text('Village', style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                    )
                                  ]
                                )
                              ],
                            ),
                            
                          ],
                        ), 
                        
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PageNavigation(),
                          PageNavigation(),
                          PageNavigation(),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PageNavigation(),
                          PageNavigation(),
                          PageNavigation(),
                        ],
                      )

              
                    ],
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
