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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppPallete.color2,
        currentIndex: currentIndex,
        onTap: (index) => ref.read(bottomNavProvider.notifier).state = index,
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
            icon: SvgPicture.asset('assets/svgs/Camera.svg'), 
            label: 'AI',
          ),
        ],
      ),
    );
  }
}
