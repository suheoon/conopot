import 'package:conopot/components/bottom_nav_bar.dart';
import 'package:conopot/models/MusicSearchItemLists.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MusicSearchItemLists>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('HomeBody'),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
