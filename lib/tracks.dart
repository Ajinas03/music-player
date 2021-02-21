import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_beta/music_player.dart';

class Tracks extends StatefulWidget {
  _TracksState createState() => _TracksState();
}

class _TracksState extends State<Tracks>
    with AutomaticKeepAliveClientMixin<Tracks> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];

  int currentIndex = 0;
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();

  void initState() {
    super.initState();
    getTracks();
  }

  void getTracks() async {
    songs = await audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != songs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState.setSong(songs[currentIndex]);
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100].withOpacity(0.2),
          backgroundImage: AssetImage('assets/images/bee.png'),
        ),
        // Icon(Icons.music_note, color: Colors.black),
        title: Text(
          'All Songs',
          style: TextStyle(color: Colors.blue[100]),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bee1.jpg'),
                    fit: BoxFit.cover)),

            // color: Colors.white,
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: songs.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  backgroundImage: songs[index].albumArtwork == null
                      ? AssetImage('assets/images/bee.png') 
                      
                      : FileImage(File(songs[index].albumArtwork)),
                ),
                title: Text(
                  songs[index].title,
                  style: TextStyle(color: Colors.blue[100]),
                ),
                subtitle: Text(
                  songs[index].artist,
                  style: TextStyle(color: Colors.blue[100]),
                ),
                onTap: () {
                  currentIndex = index;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MusicPlayer(
                            changeTrack: changeTrack,
                            songInfo: songs[currentIndex],
                            key: key,
                          )));
                },
                onLongPress: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('please tap on the song to play it'),
                  ));
                },
                tileColor: Colors.blue.withOpacity(0.2),
              ),
            ),
          ),
          // Container(
          //     height: 79,
          //     width: 900,
          //     color: Colors.red.withOpacity(0.5),
          //     child: ListTile(
          //       leading: CircleAvatar(
          //         radius: 40,
          //         backgroundColor: Colors.grey,
          //       ),
          //       title: Text('Now Playing'),
          //       onTap: () {
          //         Navigator.of(context).push(MaterialPageRoute(
          //             builder: (context) => MusicPlayer(
          //                   songInfo: songs[currentIndex],
          //                   key: key,
          //                 )));
          //       },
          //       trailing: GestureDetector(
          //           child: Icon(
          //             Icons.play_arrow,
          //             size: 47,
          //             color: Colors.black,
          //           ),
          //           onTap: () {
          //             print("hi guys");
          //           }),
          //     )),
        ],
      ),
    );
  }
}
