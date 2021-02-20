import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_beta/tracks.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';

class MusicPlayer extends StatefulWidget {
  Function changeTrack;
  SongInfo songInfo;
  final GlobalKey<MusicPlayerState> key;

  MusicPlayer({this.songInfo, this.changeTrack, this.key}) : super(key: key);

  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer>
    with AutomaticKeepAliveClientMixin<MusicPlayer> {
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  String status = 'hidden';

  final AudioPlayer player = AudioPlayer();

  void initState() {
    super.initState();

    setSong(widget.songInfo);
    MediaNotification.setListener('pause', () {
      setState(() => status = 'pause');
      changeStatus();
    });

    MediaNotification.setListener('play', () {
      setState(() => status = 'play');
      changeStatus();
    });

    MediaNotification.setListener('next', () {
      widget.changeTrack(true);
    });

    MediaNotification.setListener('prev', () {
      widget.changeTrack(false);
    });

    MediaNotification.setListener('select', () {});
  }

  void dispose() {
    super.dispose();
    stopNoti();
    player?.dispose();
  }

  void setSong(SongInfo songInfo) async {
    widget.songInfo = songInfo;
    showNoti();
    await player.setUrl(widget.songInfo.uri);

    currentValue = minimumValue;
    maximumValue = player.duration.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });

    isPlaying = false;

    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);

        if (currentValue >= maximumValue) {
          widget.changeTrack(true);
        }
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  bool get wantKeepAlive => true;

  void showNoti() {
    MediaNotification.showNotification(
        title: widget.songInfo.title, author: widget.songInfo.artist);
  }

  void pauseNoti() {
    MediaNotification.showNotification(
        title: widget.songInfo.title,
        author: widget.songInfo.artist,
        isPlaying: false);
  }

  void stopNoti() {
    MediaNotification.hideNotification();
  }

  @override
  Widget build(context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.black,
            )),
        title: Text(
          '${widget.songInfo.title}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(

 decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bee1.jpg'),
                    fit: BoxFit.cover)),

        child:Stack(
         
            children: <Widget>[
              Positioned(

left: 100,
top: 80,

                              child: Container(
                  color: Colors.green,
                  child: CircleAvatar(
                    radius: 95,
                    backgroundColor: Colors.white,
                    backgroundImage: widget.songInfo.albumArtwork == null
                        ? AssetImage('assets/images/bee.png')
                        : FileImage(File(widget.songInfo.albumArtwork)),
                  ),
                ),
              ),
              Container(
                color: Colors.red,
                margin: EdgeInsets.fromLTRB(10, 100, 0, 10),
                child: Text(
                  widget.songInfo.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            Positioned(
              top: 300,
                              child: Container(
                      color: Colors.blue,
                  margin: EdgeInsets.fromLTRB(0, 20, 6, 0),
                  child: Text(
                    widget.songInfo.artist,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Container(
                    
                child: Slider(
                  inactiveColor: Colors.black12,
                  activeColor: Colors.black,
                  min: minimumValue,
                  max: maximumValue,
                  value: currentValue,
                  onChanged: (value) {
                    currentValue = value;

                    player.seek(Duration(milliseconds: currentValue.round()));
                  },
                ),
              ),
              Container(
                color: Colors.pink,
                transform: Matrix4.translationValues(0, -5, 0),
                margin: EdgeInsets.fromLTRB(30, 0, 29, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentTime,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      endTime,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Container(
                    color: Colors.indigo,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.skip_previous,
                        color: Colors.black,
                        size: 55,
                      ),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.changeTrack(false);
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                        size: 75,
                      ),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        changeStatus();
                        pauseNoti();
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.skip_next,
                        color: Colors.black,
                        size: 55,
                      ),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.changeTrack(true);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 25, 10, 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.favorite,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.playlist_add,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}
