import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoPage(),
    );
  }
}

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  Future<void> openVideo(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'ไม่สามารถเปิดวิดีโอได้';
    }
  }

  /// widget แสดงรูปคลิป + ปุ่มกด
  Widget videoItem({
    required String title,
    required String imageUrl,
    required String videoUrl,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// รูปคลิป (กดได้)
            GestureDetector(
              onTap: () => openVideo(videoUrl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 60,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// ปุ่มกดเล่นวิดีโอ
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('เล่นวิดีโอ'),
                onPressed: () => openVideo(videoUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('วิดีโอการทำอาหาร')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// 🍲 อาหารคาว
            videoItem(
              title: 'อาหารคาว: ปลาหมึกผัดไข่เค็ม',
              imageUrl: 'https://img.youtube.com/vi/lTKAvsgAVKE/0.jpg',
              videoUrl: 'https://www.youtube.com/watch?v=lTKAvsgAVKE',
            ),

            const SizedBox(height: 20),

            /// 🍰 อาหารหวาน
            videoItem(
              title: 'อาหารหวาน: ลืมกลืน',
              imageUrl: 'https://img.youtube.com/vi/EZ9_NwDfiR4/0.jpg',
              videoUrl: 'https://www.youtube.com/watch?v=EZ9_NwDfiR4',
            ),
          ],
        ),
      ),
    );
  }
}
