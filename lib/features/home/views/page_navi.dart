import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';

class PageNavigation extends StatelessWidget {
  const PageNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
                            padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Column(
                      
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 18, 30,18),
                                  decoration: BoxDecoration(
                                    color: AppPallete.color2,
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Icon(Icons.accessibility,color: Colors.white,size: 50,),
                                ),
                                SizedBox(height: 2,),
                                Text("My Farmers",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppPallete.color2
                                ),
                                )
                              ],
                            ),
                          );
  }
}