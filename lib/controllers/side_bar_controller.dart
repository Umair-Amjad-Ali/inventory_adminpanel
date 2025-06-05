import 'package:get/get.dart';

class SidebarController extends GetxController {
  RxBool isCollapsed = false.obs;

  void toggleSidebar() {
    isCollapsed.value = !isCollapsed.value;
  }

  void closeSidebarIfSmallScreen(double width) {
    if (width < 800) {
      isCollapsed.value = true;
    }
  }
}
