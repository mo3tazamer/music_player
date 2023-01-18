import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_player/pages/music_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MyAudioList extends StatefulWidget {
  const MyAudioList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAudioList();
  }
}

class _MyAudioList extends State<MyAudioList> {
  final OnAudioQuery _onAudioQuery = OnAudioQuery();

  void getPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _onAudioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _onAudioQuery.permissionsRequest();

        setState(() {});
      }
    }
  }
  // void getDataTest()async{
  //  List<SongModel> ss = await  _onAudioQuery.('',uriType:UriType.INTERNAL ,
  //     orderType:OrderType.DESC_OR_GREATER ,
  //     sortType:SongSortType.ALBUM ,
  //   );
  //
  // }

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
        appBar: AppBar(
          elevation: 5,
            title: const Text(" list from Storage"),
            backgroundColor: Colors.transparent),
        body: FutureBuilder<List<SongModel>>(
          future: _onAudioQuery.querySongs(
              sortType: null,
              ignoreCase: true,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL),
          builder: (context, items) {
            if (items.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (items.data!.isEmpty) {
              return const Center(child: Text('no songs found'));
            }
            return ListView.builder(itemCount:items.data!.length ,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MusicPage(songModel: items.data![index])),
                  );
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),

                    clipBehavior: Clip.antiAlias,
                    color: Colors.transparent,
                    borderOnForeground: true,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(items.data![index].displayName,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          Text('${items.data![index].artist}',style: const TextStyle(fontSize: 12),),
                        ],
                      ),
                    )),
              );
            });
          },
        ));
  }
}

// ListTile(
// trailing: Text(items.data![index].displayName),
// title: Text(items.data![index].title),
// subtitle: Text('${items.data![index].album}'),
// )
