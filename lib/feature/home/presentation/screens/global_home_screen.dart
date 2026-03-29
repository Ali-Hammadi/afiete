import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/feature/home/presentation/screens/doctors_home_screen.dart';
import 'package:afiete/feature/home/presentation/screens/first_home_screen.dart';
import 'package:afiete/feature/home/presentation/widgets/custom_app_bar.dart';
import 'package:afiete/feature/home/presentation/widgets/custom_find_doctors_app_bar.dart';
import 'package:flutter/material.dart';

class GlobalHomeScreen extends StatefulWidget {
  const GlobalHomeScreen({super.key});

  @override
  State<GlobalHomeScreen> createState() => _GlobalHomeScreenState();
}

class _GlobalHomeScreenState extends State<GlobalHomeScreen> {
  int selectedItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBarList.elementAt(selectedItemIndex),
      body: homeBodyList.elementAt(selectedItemIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 14,
        currentIndex: selectedItemIndex,
        elevation: 0,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.unselectedIconColor,
        onTap: (value) {
          setState(() {
            selectedItemIndex = value;
          });
        },
        iconSize: 28,
        backgroundColor: AppColors.primaryFillColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "People",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_outlined),
            label: "Date",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: "Person",
          ),
        ],
      ),
    );
  }

  List<Widget> homeBodyList = [
    FirstHomeScreen(),
    DoctorsHomeScreen(),
    Container(color: Colors.blue, child: Text("data")),
    Container(color: Colors.black, child: Text("data")),
  ];
  List<PreferredSizeWidget> homeAppBarList = [
    CustomAppBar(),
    CustomFindDoctorsAppBar(),
  ];
}
