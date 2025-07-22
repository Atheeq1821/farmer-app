import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';
import 'Inspect_Container.dart';
import 'Inspect_Form/Trip_Page.dart';

class InspectPage extends StatelessWidget {
  const InspectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Text("Inspect", style: TextStyle(color: AppPallete.bgColor,fontWeight: FontWeight.bold)),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logo/logo_svastha.png',
              fit: BoxFit.contain,
              height: 32,
            ),

          ),
          backgroundColor: AppPallete.color2,
        ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/elements/Background.png'),fit: BoxFit.fill)

        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "INSPECT",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppPallete.color2,
                      fontSize: 30,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 70,
                    height: 4,
                    decoration: BoxDecoration(color: AppPallete.color2),
                  )
                ],
              ),
              SizedBox(height: 20),

              // Wrapping each InspectContainer with GestureDetector
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RiskAssessment()),
                  );
                },
                child: InspectContainer(),
              ),
              SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RiskAssessment()),
                  );
                },
                child: InspectContainer(),
              ),
              SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RiskAssessment()),
                  );
                },
                child: InspectContainer(),
              ),
            ],
          ),
        ),
      ),

    );
  }
}