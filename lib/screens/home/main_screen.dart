import 'package:conopot/components/custom_page_route.dart';
import 'package:conopot/constants.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/screens/chart/fitch_screen.dart';
import 'package:conopot/screens/fitch/fitchMeasure.dart';
import 'package:conopot/screens/fitch/fitchChoice.dart';
import 'package:conopot/screens/home/home_screen.dart';
import 'package:conopot/screens/musicBook/chart_screen.dart';
import 'package:conopot/screens/musicBook/music_screen.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    FitchScreen(),
    MusicScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedLabelStyle: TextStyle(fontSize: 11),
          unselectedLabelStyle: TextStyle(fontSize: 11),
          selectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                color: kTextColor,
                height: 22,
              ),
              label: '홈',
              activeIcon: SvgPicture.asset(
                'assets/icons/home.svg',
                color: kPrimaryColor,
                height: 22,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/chart.svg',
                color: kTextColor,
                height: 22,
              ),
              label: '옥타브 차트',
              activeIcon: SvgPicture.asset(
                'assets/icons/chart.svg',
                color: kPrimaryColor,
                height: 22,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/book.svg',
                color: kTextColor,
                height: 22,
              ),
              label: '노래 검색',
              activeIcon: SvgPicture.asset(
                'assets/icons/book.svg',
                color: kPrimaryColor,
                height: 22,
              ),
            ),
          ],
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
          MusicScreen(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

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
