import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:farmer_app/features/home/views/home-page.dart';
import 'package:farmer_app/features/navigation/controllers/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});
  static final List<Widget> _pages = [
    HomeView(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      body: _pages[currentIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: AppPallete.color2,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (index) => ref.read(bottomNavProvider.notifier).state = index,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            items: [
              BottomNavigationBarItem(
                icon:SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    'assets/svgs/Home.svg',
                    // color: Colors.white, // required if you want to color it
                  ),
                ),
                // icon: Icon(Icons.home_filled),
                label: 'Home',
                // backgroundColor: Colors.blue
              ),
              BottomNavigationBarItem(
                icon:SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset(
                  'assets/svgs/Journey.svg',
                  // color: Colors.white, // required if you want to color it
                ),
              ),
                // icon: Icon(Icons.trip_origin),
                label: 'Trip',
              ),
              BottomNavigationBarItem(
                // icon: SvgPicture.asset('assets/svgs/Scarecrow.svg'),
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    'assets/svgs/Scarecrow.svg',
                    // color: Colors.white, // required if you want to color it
                  ),
                ),
                label: 'Inspect',
              ),
              BottomNavigationBarItem(
                icon:SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    'assets/svgs/Procure.svg',
                    // color: Colors.white, // required if you want to color it
                  ),
                ),
                label: 'Procure',
              ),
              BottomNavigationBarItem(
                icon:SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset(
                  'assets/svgs/Camera.svg',
                  // color: Colors.white, // required if you want to color it
                ),
              ),
                label: 'AI',
              ),
            ],
          ),
        )

    );
  }
}
