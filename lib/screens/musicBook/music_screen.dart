import 'package:conopot/components/bottom_nav_bar.dart';
import 'package:conopot/constants.dart';
import 'package:conopot/screens/musicBook/chart_screen.dart';
import 'package:conopot/screens/musicBook/musicBook.dart';
import 'package:conopot/size_config.dart';
import 'package:flutter/material.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChartScreen(),
                  ),
                );
              },
              child: Center(
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  child: SizedBox(
                    width: SizeConfig.screenWidth * 0.9,
                    height: SizeConfig.screenHeight * 0.15,
                    child: Center(
                      child: ListTile(
                        leading: Icon(
                          Icons.mic,
                          size: SizeConfig.screenHeight * 0.15 * 0.5,
                        ),
                        title: Text(
                          '인기 차트',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('TJ, 금영의 최신 인기차트 목록입니다'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicBookScreen(),
                  ),
                );
              },
              child: Center(
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  child: SizedBox(
                    width: SizeConfig.screenWidth * 0.9,
                    height: SizeConfig.screenHeight * 0.15,
                    child: Center(
                      child: ListTile(
                        leading: Icon(
                          Icons.music_note_outlined,
                          size: SizeConfig.screenHeight * 0.15 * 0.5,
                        ),
                        title: Text(
                          '노래 검색',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('TJ, 금영의 모든 노래들을 검색할 수 있습니다.'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
