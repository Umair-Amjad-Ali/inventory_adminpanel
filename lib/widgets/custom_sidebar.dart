import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_adminpanel/controllers/side_bar_controller.dart';
import '../controllers/nav_controller.dart';

class CustomSidebar extends StatelessWidget {
  final NavController navController = Get.find();
  final SidebarController sidebarController = Get.put(SidebarController());

  final List<Map<String, dynamic>> menuSections = [
    {
      "label": "GENERAL",
      "items": [
        {"title": "Inventory", "icon": Icons.inventory_2},
        {"title": "Stations & Trucks", "icon": Icons.local_shipping},
      ],
    },
    {
      "label": "MANAGEMENT",
      "items": [
        {"title": "User Management", "icon": Icons.people_alt},
        {"title": "Payment", "icon": Icons.payments},
        {"title": "Battery Section", "icon": Icons.battery_full},
      ],
    },
  ];

  CustomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final sidebarWidth = (screenWidth * 0.2).clamp(160.0, 240.0);
    final topIconHeight = (screenHeight * 0.15).clamp(100.0, 140.0);
    final avatarRadius = (topIconHeight * 0.25).clamp(24.0, 36.0);
    final isSmallScreen = screenWidth < 800;

    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(3, 0),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Icon
          Container(
            height: topIconHeight,
            color: Colors.blueGrey[900],
            child: Center(
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Colors.blue[400],
                child: Icon(
                  Icons.dashboard_customize,
                  size: avatarRadius,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Sidebar items
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: screenHeight * 0.01),
              children:
                  menuSections.map((section) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: sidebarWidth * 0.07,
                            vertical: screenHeight * 0.01,
                          ),
                          child: Text(
                            section['label'],
                            style: TextStyle(
                              fontSize: (screenWidth * 0.01).clamp(11.0, 13.0),
                              color: Colors.grey[400],
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        ...List.generate(section['items'].length, (index) {
                          final item = section['items'][index];
                          final flatIndex =
                              menuSections
                                  .takeWhile((s) => s != section)
                                  .fold(
                                    0,
                                    (sum, s) =>
                                        sum + (s['items'] as List).length,
                                  ) +
                              index;

                          return Obx(() {
                            bool selected =
                                navController.selectedIndex.value == flatIndex;
                            return InkWell(
                              onTap: () {
                                navController.changePage(flatIndex);
                                if (isSmallScreen) {
                                  sidebarController.isCollapsed.value = true;
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      selected
                                          ? Colors.blueGrey[700]
                                          : Colors.transparent,
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.005,
                                    horizontal: sidebarWidth * 0.05,
                                  ),
                                  leading: Icon(
                                    item['icon'],
                                    size: (screenWidth * 0.015).clamp(
                                      18.0,
                                      24.0,
                                    ),
                                    color:
                                        selected
                                            ? Colors.white
                                            : Colors.grey[300],
                                  ),
                                  title: Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontSize: (screenWidth * 0.012).clamp(
                                        13.0,
                                        15.0,
                                      ),
                                      color:
                                          selected
                                              ? Colors.white
                                              : Colors.grey[200],
                                      fontWeight:
                                          selected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        }),
                      ],
                    );
                  }).toList(),
            ),
          ),

          // Logout button
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01,
              horizontal: sidebarWidth * 0.05,
            ),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red[200]),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red[100],
                  fontWeight: FontWeight.w600,
                  fontSize: (screenWidth * 0.012).clamp(13.0, 15.0),
                ),
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
