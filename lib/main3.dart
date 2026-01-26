import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FoodVideoPage(),
    );
  }
}

class FoodVideoPage extends StatefulWidget {
  const FoodVideoPage({super.key});

 
  @override
  State<FoodVideoPage> createState() => _FoodVideoPageState();
}

class _FoodVideoPageState extends State<FoodVideoPage> {
  late YoutubePlayerController savoryController;
  late YoutubePlayerController dessertController;

  
  @override
  void initState() {
    super.initState();

    savoryController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          'https://youtu.be/chwvx3YdXfA?si=wsJhnSWslSmLcnGM')!,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );

    dessertController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          'https://youtu.be/qej7tgIMgwg?si=5Mc_6JPxkjE1TJRU')!,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
  }

  @override
  void dispose() {
    savoryController.dispose();
    dessertController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('วิดีโอการทำอาหาร'),
        backgroundColor: const Color.fromARGB(255, 96, 94, 116),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(' ข้าวผัดไข่', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          YoutubePlayer(controller: savoryController),
          const SizedBox(height: 20),
          const Text(' ลอดช่องใบเตยน้ำกะทิ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          YoutubePlayer(controller: dessertController),
        ],
      ),
    );
  }
}
