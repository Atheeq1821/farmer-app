import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:farmer_app/features/home/views/home-page.dart';
import 'package:farmer_app/features/inspect/views/inspect.dart';
import 'package:farmer_app/features/navigation/controllers/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});
  static final List<Widget> _pages = [
    HomeView(),
    InspectPage()
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppPallete.color2
        ),
        child: BottomNavigationBar(
          backgroundColor: AppPallete.color2,
          currentIndex: currentIndex,
          onTap: (index) => ref.read(bottomNavProvider.notifier).state = index,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          type: BottomNavigationBarType.fixed, 
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/svgs/Home.svg'),  
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:  SvgPicture.asset('assets/svgs/Journey.svg'),
              label: 'Trip',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/svgs/Scarecrow.svg'), 
              label: 'Inspect',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home), 
              label: 'Procure',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppPallete.color2,
              icon: SvgPicture.asset('assets/svgs/Camera.svg'), 
              label: 'AI',
            ),
          ],
        ),
      ),
    );
  }
}
