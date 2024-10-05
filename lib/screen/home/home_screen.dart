import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:hospital_fe/screen/doctor/doctor_screen.dart';
import 'package:hospital_fe/screen/nurse/nurse_screen.dart';
import 'package:hospital_fe/screen/patient/patient_screen.dart';
import 'package:hospital_fe/screen/statistic/statistic_screen.dart';
import 'package:hospital_fe/screen/visit/visit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    super.initState();
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.blue.withOpacity(0.1),
              selectedColor: Colors.grey.withOpacity(0.08),
              arrowOpen: Colors.black,
              selectedTitleTextStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              selectedIconColor: Colors.black,
              unselectedIconColor: Colors.black54,
              unselectedTitleTextStyle: const TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.w600),
              showHamburger: false,
              iconSize: 24,
              backgroundColor: Colors.grey.withOpacity(0.08),
              openSideMenuWidth: 200,
            ),
            items: [
              SideMenuItem(
                title: 'Lần khám',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.list),
              ),
              SideMenuItem(
                title: 'Bác sỹ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.man),
              ),
              SideMenuItem(
                title: 'Y tá',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.woman),
              ),
              SideMenuItem(
                title: 'Bệnh nhân',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.person),
              ),
              SideMenuItem(
                title: 'Thống kê',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.bar_chart),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                VisitScreen(),
                DoctorScreen(),
                NurseScreen(),
                PatientScreen(),
                StatisticScreen()
              ],
            ),
          )
        ],
      ),
    );
  }
}
