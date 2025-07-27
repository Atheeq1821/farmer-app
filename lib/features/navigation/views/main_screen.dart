import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:farmer_app/features/home/views/home-page.dart';
import 'package:farmer_app/features/navigation/controllers/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Tab_views/AI_Page.dart';
import '../../../Tab_views/Inspect_page/Inspect.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static final List<Widget> _pages = [
    HomeView(),

  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      body: _pages[0], // Always show HomeView as base
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppPallete.color2,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                ref.read(bottomNavProvider.notifier).state = 0;
                break;
              case 1:
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => RiskAssessment()),
                // );
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (_)=> InspectPage()));
                break;
              case 3:
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => InputImagePage()),
                );
                break;
            }
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: [
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset('assets/svgs/Home.svg'),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset('assets/svgs/Journey.svg'),
              ),
              label: 'Trip',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset('assets/svgs/Scarecrow.svg'),
              ),
              label: 'Inspect',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset('assets/svgs/Procure.svg'),
              ),
              label: 'Procure',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset('assets/svgs/Camera.svg'),
              ),
              label: 'AI',
            ),
          ],
        ),
      ),
    );
  }
}
