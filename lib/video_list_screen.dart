import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'video_data.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  Future<void> _launchUrl(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถเปิด URL ได้: $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildVideoItem(BuildContext context, VideoItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _launchUrl(item.launchUrl, context),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  item.thumbnailUrl,
                  width: 300,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 300,
                    height: 180,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.videocam_off,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 60.0,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _launchUrl(item.launchUrl, context),
            style: ElevatedButton.styleFrom(
              backgroundColor: item.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: Text('คลิกเพื่อดู: ${item.title}'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('วิดีโอสูตรอาหาร'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: foodVideos.map((item) {
              return _buildVideoItem(context, item);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
