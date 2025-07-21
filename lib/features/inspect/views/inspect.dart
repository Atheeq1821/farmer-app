import 'package:farmer_app/core/themes/app_pallete.dart';
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
          Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(19, 10,19,10),
                decoration: BoxDecoration(
                  color: AppPallete.color5,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    )
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Farmer name - ID",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.white
                          ),),
                        Icon(Icons.check)
                      ],
                    ),
                    Row(
                      children: [
                        Text("Total Field - 20AC",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppPallete.color4
                          ),
                        ),
                        SizedBox(width: 15,),
                        Text("Cultivable - 10AC",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppPallete.color4
                          ),
                        ),
                        Spacer()

                      ],
                    )
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -12),
                child: Container(
                  padding: EdgeInsets.fromLTRB(19, 10,19,10),
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppPallete.color2,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.home,color: Colors.white,size: 35,),
                          Icon(Icons.abc,color: Colors.white,size: 35,),
                          Icon(Icons.access_alarms,color: Colors.white,size: 35,),
                          Icon(Icons.home,color: Colors.white,size: 35,),
                          Icon(Icons.abc,color: Colors.white,size: 35,),
                          Icon(Icons.access_alarms,color: Colors.white,size: 35,)
                        ],
                      ),
                      Container(
                        
                        child: Text(""),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}