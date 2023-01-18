import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPage extends StatefulWidget {
  MusicPage({Key? key, required this.songModel}) : super(key: key);

  AudioPlayer? audioPlayer;

  SongModel songModel;
  final OnAudioQuery onAudioQuery = OnAudioQuery();

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  late AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  Duration currentPosition = const Duration();
  Duration musicLengh = const Duration();
  void setUp() {
    player.onPositionChanged.listen((p) {
      setState(() {
        currentPosition = p;
      });
    });
    player.onDurationChanged.listen((d) {
      setState(() {
        musicLengh = d;
      });
    });
  }

  

  @override
  void initState() {
    playMusic();
    isPlaying =true;
    // player.setSource(AssetSource('amr.mp3'));
    setUp();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
          stop();
        },icon: const Icon(Icons.arrow_back)),

        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                height: 280,
                width: 280,
                //padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/YaAnaYaLa.jpg',
                        ))),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Expanded(
                   child: Text(
                    widget.songModel.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                 ),
                const Spacer(

                ),
                Expanded(child: IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)))
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              verticalDirection: VerticalDirection.down,
              children:  [
                Text(
                  '${widget.songModel.artist}',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${currentPosition.inSeconds}'),
                Expanded(
                  flex: 3,
                  child: Slider(
                      value: currentPosition.inSeconds.toDouble(),
                      max: musicLengh.inSeconds.toDouble(),
                      activeColor: Colors.blue,
                      inactiveColor: Colors.blue[300],
                      onChanged: (onChanged) {
                        seek(onChanged.toInt());
                      }),
                ),
                Text('${musicLengh.inMinutes}'),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.repeat)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.skip_previous,
                      size: 35,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (!isPlaying) {
                          playMusic();
                          isPlaying = true;
                        } else {
                          pause();
                          isPlaying = false;
                        }
                      });
                    },
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_circle,
                        size: 35)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_next, size: 35)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.list)),
              ],
            )
          ],
        ),
      ),
    );
  }

  void playMusic() {


    player.play(UrlSource(widget.songModel.data));
    //player.play(AssetSource('amr.mp3'));
    widget.songModel.uri;
    
    print('play');
  }

  void pause() {
    player.pause();
  }
  void stop() {
    player.stop();
  }

  void seek(int sc) {
    player.seek(Duration(seconds: sc));
  }
}
