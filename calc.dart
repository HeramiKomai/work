import 'package:flutter/material.dart';
import 'video_list_screen.dart'; // ของคนที่ 1
import 'main2.dart'; // ของคนที่ 2 (VideoPage)
import 'main3.dart'; // ของคนที่ 3 (FoodVideoPage)

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    ));

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รวม App ของทีม', style: TextStyle(fontWeight: FontWeight.bold)),
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

            // ปุ่มของคนที่ 1 - วิดีโอสูตรอาหาร (ใช้ VideoListScreen)
            _buildMenuButton(
              context, 
              title: 'แอปสูตรอาหาร (คนที่ 1)', 
              color: Colors.teal, 
              screen: const VideoListScreen(), 
            ),
            
            const SizedBox(height: 15),

            // ปุ่มของคนที่ 2 - วิดีโอการทำอาหาร (ใช้ VideoPage)
            _buildMenuButton(
              context, 
              title: 'วิดีโอทำอาหาร (คนที่ 2)', 
              color: Colors.blueAccent, 
              screen: const VideoPage(), 
            ),

            const SizedBox(height: 15),

            // ปุ่มของคนที่ 3 - วิดีโอการทำอาหาร (ใช้ FoodVideoPage)
            _buildMenuButton(
              context, 
              title: 'สอนทำอาหาร (คนที่ 3)', 
              color: const Color.fromARGB(255, 96, 94, 116), 
              screen: const FoodVideoPage(), 
            ),
          ],
        ),
      ),
    );
  }

  // แก้ไขฟังก์ชันสร้างปุ่มให้สมบูรณ์
  Widget _buildMenuButton(BuildContext context, {required String title, required Color color, required Widget screen}) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(color: color, width: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}