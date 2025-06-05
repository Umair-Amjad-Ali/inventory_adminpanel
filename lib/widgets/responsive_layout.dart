import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget sidebar;
  final Widget content;

  const ResponsiveLayout({
    super.key,
    required this.sidebar,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      drawer: isSmall ? Drawer(child: sidebar) : null,
      body: Row(
        children: [
          // Sidebar on large screens
          if (!isSmall) SizedBox(width: 200, child: sidebar),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top App Bar
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (isSmall)
                        Builder(
                          builder: (context) {
                            return IconButton(
                              icon: Icon(Icons.menu),
                              onPressed:
                                  () => Scaffold.of(context).openDrawer(),
                            );
                          },
                        ),
                      Text("Admin Dashboard", style: TextStyle(fontSize: 18)),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: Colors.grey[700],
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // Main Screen Content
                Expanded(child: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
