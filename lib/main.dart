import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:inventory_adminpanel/firebase_options.dart';
import 'controllers/nav_controller.dart';
import 'widgets/custom_sidebar.dart';
import 'widgets/responsive_layout.dart';
import 'screens/aa_member_screen.dart';
import 'screens/station_truck_screen.dart';
import 'screens/user_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/battery_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Admin Panel',
      theme: ThemeData.dark(),
      home: AdminHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminHomePage extends StatelessWidget {
  final NavController navController = Get.put(NavController());

  final List<Widget> pages = [
    AaMemberScreen(),
    StationTruckScreen(),
    UserScreen(),
    PaymentScreen(),
    BatteryScreen(),
  ];

  AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        sidebar: CustomSidebar(),
        content: Obx(() => pages[navController.selectedIndex.value]),
      ),
    );
  }
}
