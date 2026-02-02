import 'package:flutter/material.dart';
import 'video_list_screen.dart'; // ของคนที่ 1
import 'main2.dart'; // ของคนที่ 2
import 'main3.dart'; // ของคนที่ 3

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: MainMenu()),
);

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รวม App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'เลือกแอปที่ต้องการเข้าชม',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),

            _buildMenuButton(
              context,
              title: 'แอปสูตรอาหาร (ณัฐชนน)',
              color: Colors.teal,
              screen: const VideoListScreen(),
            ),

            const SizedBox(height: 15),

            _buildMenuButton(
              context,
              title: 'วิดีโอทำอาหาร (วริศรา)',
              color: Colors.blueAccent,
              screen: const VideoPage(),
            ),

            const SizedBox(height: 15),

            // ปุ่มคนที่ 3
            _buildMenuButton(
              context,
              title: 'สอนทำอาหาร (ทรงศักดิ์)',
              color: const Color.fromARGB(255, 96, 94, 116),
              screen: const FoodVideoPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required Color color,
    required Widget screen,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(color: color, width: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
        ),
        onPressed: () {
          // เพิ่มคำสั่งให้กดแล้วข้ามไปหน้านั้นๆ
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
