import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:farmer_app/features/inspect/views/inspect_farmer.dart';
import 'package:flutter/material.dart';

class InspectPage extends StatelessWidget {
  const InspectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
      child: Column(
        children: [
          Row(
            children: [
              Text("INSPECT"),
              Container(
                width: 70,
                decoration: BoxDecoration(
                  color: AppPallete.color2
                ),
              )
              
            ],
          ),
          SizedBox(height: 20,),
          InspectContainer(),
          SizedBox(height: 20,),
          InspectContainer(),
          SizedBox(height: 20,),
          InspectContainer(),
          SizedBox(height: 20,),
          
        ],
      ),
    );
  }
}