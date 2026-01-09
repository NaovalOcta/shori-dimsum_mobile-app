import 'package:get/get.dart';

class MenuNavBarClass {
  RxList<bool> navItemSelectionStateList = [ true, false, false, false ].obs;
  
  void toggleNavSelectionState(int newIndex) {
    int currIndex = navItemSelectionStateList.indexOf(true);
    if(newIndex == currIndex) return;
    if(newIndex != -1) navItemSelectionStateList[newIndex] = true;
    navItemSelectionStateList[currIndex] = false;
  }

  int getSelectedNavIndex() { return navItemSelectionStateList.indexOf(true); }

  void resetNavItemSelection() {
    navItemSelectionStateList[navItemSelectionStateList.indexOf(true)] = false;
    navItemSelectionStateList[0] = true;
  }
}

class HomeController extends GetxController {
  final MenuNavBarClass navbarClass = MenuNavBarClass();
}