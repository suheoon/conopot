import 'package:conopot/firebase/analytics_config.dart';
import 'package:conopot/global/theme_colors.dart';
import 'package:conopot/models/music_state.dart';
import 'package:conopot/models/note_state.dart';
import 'package:conopot/models/youtube_player_state.dart';
import 'package:conopot/screens/musicBook/components/musicbook_search_bar.dart';
import 'package:conopot/screens/note/components/note_search_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  @override
  void initState() {
    Analytics_config().addNotePageView();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(
      onWillPop: () async {
        if (Provider.of<YoutubePlayerState>(context, listen: false)
            .isHomeTab) {
          Provider.of<YoutubePlayerState>(context, listen: false)
              .youtubeInit(
                  Provider.of<NoteState>(context, listen: false).notes,
                  Provider.of<MusicState>(context, listen: false)
                      .youtubeURL);
          Provider.of<YoutubePlayerState>(context, listen: false)
              .openPlayer();
          Provider.of<YoutubePlayerState>(context, listen: false).refresh();
        }
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("노래 추가",
              style: TextStyle(fontWeight: FontWeight.w700)),
          centerTitle: true,
          leading: BackButton(
            color: kPrimaryLightWhiteColor,
            onPressed: () {
              if (Provider.of<YoutubePlayerState>(context, listen: false)
                  .isHomeTab) {
                Provider.of<YoutubePlayerState>(context, listen: false)
                    .youtubeInit(
                        Provider.of<NoteState>(context, listen: false).notes,
                        Provider.of<MusicState>(context,
                                listen: false)
                            .youtubeURL);
                Provider.of<YoutubePlayerState>(context, listen: false)
                    .openPlayer();
                Provider.of<YoutubePlayerState>(context, listen: false)
                    .refresh();
              }
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Consumer<MusicState>(
          builder: (
            context,
            musicList,
            child,
          ) =>
              Column(
            children: [
              SearchBar(musicList: musicList),
              NoteSearchList(musicList: musicList),
            ],
          ),
        ),
      ),
    );
  }
}
