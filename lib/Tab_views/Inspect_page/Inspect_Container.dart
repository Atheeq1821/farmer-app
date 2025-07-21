import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InspectContainer extends StatelessWidget {
  const InspectContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    SvgPicture.asset('assets/svgs/Sowing.svg',width: 35,height: 30,),
                    SvgPicture.asset('assets/svgs/Tractor.svg',width: 35,height: 30,),
                    SvgPicture.asset('assets/svgs/Leaf.svg',width: 35,height: 30,),
                    SvgPicture.asset('assets/svgs/Spray.svg',width: 35,height: 30,),
                    SvgPicture.asset('assets/svgs/Harvest.svg',width: 35,height: 30,),
                    SvgPicture.asset('assets/svgs/Semi_Truck.svg',width: 35,height: 30,),

                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: 7,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)
                  ),

                )
              ],
            ),
          ),
        )
      ],
    );
  }
}