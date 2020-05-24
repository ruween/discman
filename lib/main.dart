import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

typedef void OnError(Exception exception);

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LocalAudio(),
  ));
}

class LocalAudio extends StatefulWidget {
  @override
  _LocalAudioState createState() => _LocalAudioState();
}

class _LocalAudioState extends State<LocalAudio> {
  Duration _duration = Duration();
  Duration _position = Duration();
  var isPlaying = false;
  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          playerUi(context),
        ],
      ),
    );
  }

  Widget playerUi(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
             child: IconButton(
                icon: Icon(
                  Icons.fast_rewind,
                  color: Colors.black,
                ),
                onPressed: () => seekBackward(),
              ),
            ),
            Expanded(
              child: isPlaying
                  ? IconButton(
                      icon: Icon(
                        Icons.pause_circle_outline,
                        size: 40.0,
                      ),
                      onPressed: () {
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                        advancedPlayer.pause();
                      })
                  : IconButton(
                      icon: Icon(
                        Icons.play_circle_outline,
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                        audioCache.play('play.mp3');
                      }),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(
                  Icons.fast_forward,
                  color: Colors.black,
                ),
                onPressed: () => seekForward(),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: slider(),
            ),
          ],
        )
      ]),
    );
  }

  Widget slider() {
    return SliderTheme(
      data: SliderThemeData(
        thumbColor: Colors.black,
        inactiveTrackColor: Colors.grey,
        activeTrackColor: Colors.black,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
      ),
      child: Slider.adaptive(
          value: _position.inSeconds.toDouble(),
          min: 0.0,
          max: _duration.inSeconds.toDouble(),
          onChanged: (double value) {
            setState(() {
              seekToSecond(value.toInt());
              value = value;
            });
          }),
    );
  }

   void seekBackward(){ //seek backward 3 seconds
    Duration newPosition = Duration();
    Duration val = Duration(milliseconds: 3000);
    newPosition = _position - val;
    advancedPlayer.seek(newPosition);
  }

  void seekForward(){ //seek forward 3 seconds
    Duration newPosition = Duration();
    Duration val = Duration(milliseconds: 3000);
    newPosition = _position + val;
    advancedPlayer.seek(newPosition);
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    advancedPlayer.seek(newDuration);
  }
}
