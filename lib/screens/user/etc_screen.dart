import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/global/size_config.dart';
import 'package:conopot/models/note_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EtcScreen extends StatelessWidget {
  EtcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    var loginState = Provider.of<NoteState>(context, listen: true).isLogined;
    var backUpDate = Provider.of<NoteState>(context, listen: true).backUpDate;
    return Scaffold(
      appBar: AppBar(
        title: Text("기타", style: TextStyle(color: kPrimaryWhiteColor)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultSize),
          child: Column(children: [
            SizedBox(height: defaultSize * 3),
            //로그아웃 버튼
            (loginState == true)
                ? InkWell(
                    onTap: () {
                      Provider.of<NoteState>(context, listen: false)
                          .showAccountDialog(context, "logout");
                    },
                    splashColor: Colors.transparent,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: defaultSize * 1.5),
                      child: Row(children: [
                        Text("로그아웃",
                            style: TextStyle(
                              color: kPrimaryWhiteColor,
                              fontSize: defaultSize * 1.5,
                              fontWeight: FontWeight.w500,
                            )),
                      ]),
                    ),
                  )
                : SizedBox.shrink(),
            (loginState == true)
                ? SizedBox(height: defaultSize * 3)
                : SizedBox.shrink(),
            //회원탈퇴 버튼
            (loginState == true)
                ? InkWell(
                    onTap: () {
                      Provider.of<NoteState>(context, listen: false)
                          .showAccountDialog(context, "delete");
                    },
                    splashColor: Colors.transparent,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: defaultSize * 1.5),
                      child: Row(children: [
                        Text("탈퇴하기",
                            style: TextStyle(
                              color: kPrimaryWhiteColor,
                              fontSize: defaultSize * 1.5,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(height: defaultSize * 1.5),
                      ]),
                    ),
                  )
                : SizedBox.shrink(),
            (loginState == true)
                ? SizedBox(height: defaultSize * 2)
                : SizedBox(height: defaultSize)
          ]),
        ),
      ),
    );
  }
}
