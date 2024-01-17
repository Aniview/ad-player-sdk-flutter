import 'package:adplayer_flutter_plugin/ad_player.dart';
import 'package:adplayer_flutter_plugin/ad_player_placement.dart';
import 'package:adplayer_flutter_plugin/ad_player_tag.dart';
import 'package:flutter/material.dart';

const pubId = "6487312e2b47b3573702a4a3";
const tagId = "659c179117f2b6626f070678";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AdPlayer.initialize(iosStoreUrl: "https://adplayer-flutter-demo/id1234567");
  await AdPlayer.initializePublisher(publisherId: pubId, tagId: tagId);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter AdPlayer Plugin",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: "Flutter AdPlayer Plugin"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final versionFuture = AdPlayer.getVersion();
  final preloadVideoFuture = AdPlayer.getTagWhenReady(tagId: tagId).then((value) {
    return AdPlayerTag.preloadVideo(tagId).then((value) {
      return value;
    });
  });

  @override
  Widget build(BuildContext context) {
    const padding = 10.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("AdPlayer Flutter Plugin"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(padding),
            child: Column(children: [
              const Text(longString),
              const SizedBox(height: 16),
              FutureBuilder(
                future: versionFuture,
                builder: (context, snapshot) {
                  return Text(snapshot.data ?? "unknown");
                },
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                future: preloadVideoFuture,
                builder: (context, snapshot) {
                  final finished = snapshot.connectionState == ConnectionState.done;
                  return Text(finished ? "Video loaded" : "Video loading...");
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: padding),
                child: AdPlayerPlacementWidget(tagId: tagId),
              ),
              const Text(longString2),
            ]),
          ),
        ),
      ),
    );
  }
}

const String longString =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Suscipit tellus mauris a diam maecenas sed enim. In ornare quam viverra orci sagittis eu volutpat odio facilisis. Praesent semper feugiat nibh sed pulvinar proin gravida hendrerit. Consequat ac felis donec et odio pellentesque diam volutpat. Vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam. Et malesuada fames ac turpis egestas integer eget aliquet. Lectus quam id leo in vitae. Ac orci phasellus egestas tellus rutrum. Orci phasellus egestas tellus rutrum tellus pellentesque eu tincidunt. Cursus in hac habitasse platea dictumst quisque sagittis.\n\nPurus gravida quis blandit turpis cursus in. Dui accumsan sit amet nulla facilisi. Aliquam eleifend mi in nulla posuere sollicitudin. Sit amet mattis vulputate enim nulla aliquet porttitor lacus. Id neque aliquam vestibulum morbi blandit cursus risus at ultrices. Nisl nisi scelerisque eu ultrices vitae auctor eu. Porta nibh venenatis cras sed felis eget velit aliquet. Commodo nulla facilisi nullam vehicula ipsum. Eget aliquet nibh praesent tristique magna sit amet purus gravida. Quam nulla porttitor massa id neque aliquam.";

const String longString2 =
    "Non quam lacus suspendisse faucibus interdum posuere lorem ipsum dolor. Quis ipsum suspendisse ultrices gravida dictum fusce ut. Semper eget duis at tellus at urna condimentum. Quisque id diam vel quam elementum pulvinar. Hendrerit dolor magna eget est lorem ipsum. Imperdiet proin fermentum leo vel orci porta non pulvinar. Vestibulum sed arcu non odio euismod lacinia at quis. Elit scelerisque mauris pellentesque pulvinar pellentesque. Eget nunc lobortis mattis aliquam. Consectetur adipiscing elit ut aliquam purus. Ultrices gravida dictum fusce ut placerat. Malesuada fames ac turpis egestas maecenas. Elit scelerisque mauris pellentesque pulvinar pellentesque. Aliquet risus feugiat in ante metus dictum at. Neque gravida in fermentum et. Est lorem ipsum dolor sit. Hendrerit gravida rutrum quisque non tellus orci ac auctor augue. Sit amet tellus cras adipiscing enim eu turpis egestas pretium. Pulvinar neque laoreet suspendisse interdum consectetur libero id faucibus. Curabitur vitae nunc sed velit dignissim sodales.\n\nFeugiat in ante metus dictum at tempor. Id eu nisl nunc mi ipsum. Amet luctus venenatis lectus magna fringilla. Egestas diam in arcu cursus. Ante in nibh mauris cursus mattis molestie a iaculis. Ac tortor dignissim convallis aenean et tortor at risus viverra. Maecenas volutpat blandit aliquam etiam erat velit scelerisque in. Ipsum a arcu cursus vitae congue mauris rhoncus aenean. Et leo duis ut diam quam nulla porttitor massa id. Cursus euismod quis viverra nibh cras pulvinar mattis.\n\nEu nisl nunc mi ipsum faucibus. Est velit egestas dui id ornare. Nunc vel risus commodo viverra maecenas. Aliquet lectus proin nibh nisl condimentum id venenatis. Pharetra vel turpis nunc eget lorem. Amet dictum sit amet justo donec enim. Dis parturient montes nascetur ridiculus. Cursus vitae congue mauris rhoncus aenean vel. Nec sagittis aliquam malesuada bibendum arcu vitae elementum curabitur vitae. Lorem ipsum dolor sit amet consectetur adipiscing elit ut aliquam.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu. Nunc congue nisi vitae suscipit tellus mauris a. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus. Sed elementum tempus egestas sed sed risus pretium. Ut ornare lectus sit amet. Urna molestie at elementum eu facilisis sed odio morbi quis. Tristique risus nec feugiat in fermentum. Sollicitudin ac orci phasellus egestas tellus. In metus vulputate eu scelerisque felis. Rhoncus dolor purus non enim. Augue neque gravida in fermentum et.\n\nMorbi non arcu risus quis varius quam quisque id. Mi tempus imperdiet nulla malesuada pellentesque elit eget. Id interdum velit laoreet id. Non tellus orci ac auctor augue mauris augue neque gravida. Aliquam ultrices sagittis orci a scelerisque purus semper eget. Dolor sit amet consectetur adipiscing. Tincidunt arcu non sodales neque sodales ut. Nisl vel pretium lectus quam id leo in. Placerat in egestas erat imperdiet sed euismod nisi porta. Mi sit amet mauris commodo quis imperdiet massa. Donec ultrices tincidunt arcu non sodales neque. Sed euismod nisi porta lorem mollis aliquam. Pharetra vel turpis nunc eget lorem dolor sed. Maecenas pharetra convallis posuere morbi leo. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Egestas erat imperdiet sed euismod nisi. Nibh ipsum consequat nisl vel.";
