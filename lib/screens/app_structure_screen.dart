import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:zwc/screens/settings/settings.dart';

import '../controllers/dashboard_controller.dart';
import 'dashboard/dashboard.dart';
import 'rewards/rewards.dart';
import 'pickup/pickup.dart';

class AppStructureScreen extends StatefulWidget {
  const AppStructureScreen({super.key});
  @override
  State<AppStructureScreen> createState() => _AppStructureScreenState();
}

class _AppStructureScreenState extends State<AppStructureScreen> {
  DateTime? _lastPressedAt;
  int screen = 0;
  final PageController pageController = PageController();

  @override
  void initState() {
    Get.put(DashboardController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (pageController.page == 0) {
            if (_lastPressedAt == null ||
                DateTime.now().difference(_lastPressedAt!) >
                    Duration(seconds: 2)) {
              _lastPressedAt = DateTime.now();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(
                    'Press back button again to exit',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              return false;
            }
            return true;
          }
          pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeIn,
          );
          screen = 0;
          setState(() {});
          return false;
        },
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            DashboardScreen(
              toWalletScreen: () {
                screen = 2;
                setState(() {});
                pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeIn,
                );
              },
            ),
            const PickUpRequest(),
            const RewardsScreen(),
            const SettingsScreenNew()
          ],
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: screen,
          onTap: (index) {
            if (screen == index) return;
            screen = index;
            setState(() {});
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              selectedColor: Colors.green,
              unselectedColor: Colors.green,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.local_shipping),
              title: const Text("Pickup"),
              selectedColor: Colors.green,
              unselectedColor: Colors.green,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.account_balance_wallet_rounded),
              title: const Text("Rewards"),
              selectedColor: Colors.green,
              unselectedColor: Colors.green,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.settings),
              title: const Text("Settings"),
              selectedColor: Colors.grey,
              unselectedColor: Colors.grey,
            ),
          ]),
    );
  }
}
