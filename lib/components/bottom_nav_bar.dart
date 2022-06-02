import 'package:conopot/constants.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/models/NavItem.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;

    return Consumer<NavItems>(
      builder: (context, navItems, child) => Container(
        padding: EdgeInsets.symmetric(horizontal: defaultSize * 3),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            offset: Offset(0, -7),
            blurRadius: 30,
            color: Color(0xFF4B1A39).withOpacity(0.2),
          )
        ]),
        child: SafeArea(
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                navItems.items.length,
                (index) => buildIconNavBarItem(
                  isActive: navItems.selectedIndex == index ? true : false,
                  icon: navItems.items[index].icon,
                  title: navItems.items[index].title,
                  press: () {
                    navItems.changeNavIndex(index: index);
                    if (index == 1) {
                      Future.delayed(Duration.zero, () {
                        Provider.of<MusicSearchItemLists>(context,
                                listen: false)
                            .initChart();
                      });
                    } else {
                      Future.delayed(Duration.zero, () {
                        Provider.of<MusicSearchItemLists>(context,
                                listen: false)
                            .initBook();
                      });
                    }
                    if (navItems.items[index].destinationChecker())
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              navItems.items[index].destination,
                        ),
                      );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column buildIconNavBarItem(
      {required String icon,
      required String title,
      required VoidCallback press,
      bool isActive = false}) {
    return Column(
      children: [
        IconButton(
          icon: SvgPicture.asset(
            icon,
            color: isActive ? kPrimaryColor : Color(0xFFD1D4D4),
            height: 22,
          ),
          onPressed: press,
        ),
        Text(
          title,
          style: TextStyle(
              color: isActive ? kTextColor : kTextLightColor, fontSize: 10),
        ),
      ],
    );
  }
}
