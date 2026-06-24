import 'package:expense_tracker/screens/analytics_screen.dart';
import 'package:expense_tracker/screens/dashboard_screen.dart';
import 'package:expense_tracker/screens/setting_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  int currentIndex = 0;

  final screens = [
    const DashboardScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      body:
      screens[currentIndex],

      bottomNavigationBar:
      BottomNavigationBar(
        currentIndex:
        currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex =
                index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon:
            Icon(Icons.home),
            label:
            'Dashboard',
          ),
          BottomNavigationBarItem(
            icon:
            Icon(Icons.pie_chart),
            label:
            'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
