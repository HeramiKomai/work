import 'package:flutter/material.dart';

class VideoItem {
  final String title;
  final String videoId;
  final Color color;

  const VideoItem({
    required this.title,
    required this.videoId,
    required this.color,
  });

  String get launchUrl => 'https://youtu.be/$videoId';

  String get thumbnailUrl =>
      'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
}

const List<VideoItem> foodVideos = [
  const VideoItem(
    title: 'ผัดกะเพราหมูสับ (อาหารคาว)',
    videoId: 'J5dU30alSTQ',
    color: Colors.green,
  ),
  const VideoItem(
    title: 'ขนมบัวลอย (อาหารหวาน)',
    videoId: 'qrfCv-BJGbs',
    color: Colors.pink,
  ),
];
