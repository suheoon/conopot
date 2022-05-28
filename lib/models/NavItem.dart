import 'package:conopot/screens/chart/chart_screen.dart';
import 'package:conopot/screens/home/home_screen.dart';
import 'package:conopot/screens/musicBook/musicBook.dart';
import 'package:flutter/material.dart';

class NavItem {
  final int id;
  final String icon;
  final String title;
  final Widget destination;

  NavItem(
      {required this.id,
      required this.icon,
      required this.title,
      required this.destination});

  //If there is no destination then it help us
  bool destinationChecker() {
    if (destination != null) {
      return true;
    }
    return false;
  }
}

// If we made any changes here Provider package rebuid those widget those use this NavItems
class NavItems extends ChangeNotifier {
  // By default first one is selected
  int selectedIndex = 0;

  void changeNavIndex({required int index}) {
    selectedIndex = index;
    // if any changes made it notify widgets that use the value
    notifyListeners();
  }

  List<NavItem> items = [
    NavItem(
      id: 1,
      icon: "assets/icons/home.svg",
      title: "홈",
      destination: HomeScreen(),
    ),
    NavItem(
      id: 2,
      icon: "assets/icons/chart.svg",
      title: "인기 차트",
      destination: ChartScreen(),
    ),
    NavItem(
      id: 3,
      icon: "assets/icons/book.svg",
      title: "노래 검색",
      destination: MusicBookScreen(),
    ),
  ];
}
