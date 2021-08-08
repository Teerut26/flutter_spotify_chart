import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:web_scraper/web_scraper.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light));
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Spotify Chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> ? dataListTitleG;
  List<Map<String, dynamic>> ? dataListArtistG;
  List<Map<String, dynamic>> ? dataListCoverG;
  List<Map<String, dynamic>> ? dataListStreamsG;

  List<Map<String, dynamic>> ? dataListTitleTH;
  List<Map<String, dynamic>> ? dataListArtistTH;
  List<Map<String, dynamic>> ? dataListCoverTH;
  List<Map<String, dynamic>> ? dataListStreamsTH;

  void initState(){
    super.initState();
    getDataG();
    // getDataTH();
  }

  Future<void> getDataG() async{
    final webScraper = WebScraper('https://spotifycharts.com');
    await webScraper.loadWebPage('/regional/global/daily/latest');
    List<Map<String, dynamic>> title = await webScraper.getElement('#content > div > div > div > span > table > tbody > tr > td.chart-table-track > strong', ['']);
    List<Map<String, dynamic>> artist = await webScraper.getElement('#content > div > div > div > span > table > tbody > tr > td.chart-table-track > span', ['']);
    List<Map<String, dynamic>> cover = await webScraper.getElement('#content > div > div > div > span > table > tbody > tr > td.chart-table-image > a > img', ['src']);
    List<Map<String, dynamic>> streams = await webScraper.getElement('#content > div > div > div > span > table > tbody > tr > td.chart-table-streams', ['']);
    // var data = await res.body;
    // var temp = await data.map((e) => {
    //   "title":e["title"].toString()
    // }).toList();
    print(title);
    setState(() {
      dataListTitleG = title;
      dataListArtistG = artist;
      dataListCoverG = cover;
      dataListStreamsG = streams;
    });
  }

  Future<void> getDataTH() async{
    final webScraper2 = WebScraper('https://spotifycharts.com');
    await webScraper2.loadWebPage('/regional/th/daily/lates');
    List<Map<String, dynamic>> title = await webScraper2.getElement('#content > div > div > div > span > table > tbody > tr > td.chart-table-track > strong', ['']);
    List<Map<String, dynamic>> artist = await webScraper2.getElement('#content > div > div > div > span > table > tbody > tr > td.chart-table-track > span', ['']);
    List<Map<String, dynamic>> cover = await webScraper2.getElement('#content > div > div > div > span > table > tbody > tr > td.chart-table-image > a > img', ['src']);
    List<Map<String, dynamic>> streams = await webScraper2.getElement('#content > div > div > div > span > table > tbody > tr > td.chart-table-streams', ['']);
    print(title);
    setState(() {
      dataListTitleTH = title;
      dataListArtistTH = artist;
      dataListCoverTH = cover;
      dataListStreamsTH = streams;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              // Image(image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Spotify_logo_without_text.svg/600px-Spotify_logo_without_text.svg.png"),width: 30,),
              Icon(Icons.music_note_rounded,size: 30,),
              SizedBox(width: 5,),
              Text(widget.title),
            ],
          ),
          // bottom: TabBar(
          //   tabs: [
          //     Tab(
          //         child: Center(
          //         child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [Icon(Icons.language_rounded),SizedBox(width: 5), Text("Global")],
          //       ),
          //     )),
          //     // Tab(
          //     //     child: Center(
          //     //     child: Row(
          //     //     mainAxisAlignment: MainAxisAlignment.center,
          //     //     children: [Icon(Icons.location_on_rounded),SizedBox(width: 5),Text("Thailand")],
          //     //   ),
          //     // )),
          //   ],
          // ),
        ),
        body: dataListTitleG != null ? Global() : Text("Loading..."),
      ),
    );
  }
  Widget Global() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(itemCount: dataListTitleG!.length, itemBuilder: (BuildContext context, int index){
            return Column(
              children: [
                ListTile(
                  leading: Image(image: NetworkImage("${dataListCoverG![index]["attributes"]["src"]}")),
                  title: Text("${index+1}. ${dataListTitleG![index]["title"]}"),
                subtitle: Text("${dataListArtistG![index]["title"]}"),
                trailing: Text("${dataListStreamsG![index]["title"]}"),
                ),
                Divider(height: 2,)
              ],
            );
          }),
        ),
        
      ],
    );
  }

  Widget Thailand() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(itemCount: dataListTitleTH!.length, itemBuilder: (BuildContext context, int index){
            return Column(
              children: [
                ListTile(
                  leading: Image(image: NetworkImage("${dataListCoverTH![index]["attributes"]["src"]}")),
                  title: Text("${index+1}. ${dataListTitleTH![index]["title"]}"),
                subtitle: Text("${dataListArtistTH![index]["title"]}"),
                trailing: Text("${dataListStreamsTH![index]["title"]}"),
                ),
                Divider(height: 2,)
              ],
            );
          }),
        ),
        
      ],
    );
  }
}
