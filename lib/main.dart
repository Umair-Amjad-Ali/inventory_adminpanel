import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_adminpanel/controllers/authentication/auth_controller.dart';
import 'package:inventory_adminpanel/screens/auth/login_screen.dart';
import 'package:inventory_adminpanel/screens/truck/truck_screen.dart';
import 'firebase_options.dart';
import 'controllers/nav_controller.dart';
import 'screens/aa_member_screen.dart';
import 'screens/station_truck_screen.dart';
import 'screens/user_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/battery_screen.dart';
import 'widgets/custom_sidebar.dart';
import 'widgets/responsive_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  Get.put(AuthController());

  runApp(const AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return GetMaterialApp(
      title: 'Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Obx(() {
        return auth.isLoggedIn.value ? AdminHomePage() : LoginScreen();
      }),
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
    TruckScreen(),
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
