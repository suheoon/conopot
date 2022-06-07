import 'package:conopot/models/navbar_items.dart';
import 'package:conopot/screens/chart/pitch_screen.dart';
import 'package:conopot/screens/home/home_screen.dart';
import 'package:conopot/screens/musicBook/music_screen.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  /// 선택된 네비게이션 위젯 (0, 1, 2)

  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    FitchScreen(),
    const MusicScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedLabelStyle: const TextStyle(fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          selectedItemColor: Colors.black,
          items: navbarItems,

          /// BottomNavigationBarItem List
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      body: Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
        ],
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          HomeScreen(),
          FitchScreen(),
          const MusicScreen(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    /// (offstage == false) -> 트리에서 완전히 제거된다.
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) {
              var route = routeBuilders[routeSettings.name];
              if (route != null) {
                return route(context);
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}
