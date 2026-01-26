import 'package:flutter/material.dart';
import 'video_list_screen.dart'; // ของคนที่ 1 (ณัฐชนน)
import 'main2.dart'; // ของคนที่ 2 (วริศรา)
import 'main3.dart'; // ของคนที่ 3 (ทรงศักดิ์)

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false, 
    home: MainMenu()
  ),
);

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // พื้นหลังสีเทาอ่อนให้ปุ่มดูเด่น
      appBar: AppBar(
        title: const Text(
          'รวม App ของทีม',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.apps_rounded, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 10),
            Text(
              'เลือกแอปที่ต้องการเข้าชม',
              style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),

            // ปุ่มคนที่ 1
            _buildMenuButton(
              context,
              title: 'แอปสูตรอาหาร (ณัฐชนน)',
              subtitle: 'เมนูกะเพรา & บัวลอย',
              icon: Icons.restaurant_menu,
              color: Colors.teal,
              screen: const VideoListScreen(),
            ),

            const SizedBox(height: 20),

            // ปุ่มคนที่ 2
            _buildMenuButton(
              context,
              title: 'วิดีโอทำอาหาร (วริศรา)',
              subtitle: 'ปลาหมึกผัดไข่เค็ม & ลืมกลืน',
              icon: Icons.ondemand_video_rounded,
              color: Colors.blueAccent,
              screen: const VideoPage(),
            ),

            const SizedBox(height: 20),

            // ปุ่มคนที่ 3
            _buildMenuButton(
              context,
              title: 'สอนทำอาหาร (ทรงศักดิ์)',
              subtitle: 'ข้าวผัดไข่ & ลอดช่อง',
              icon: Icons.fastfood_rounded,
              color: const Color.fromARGB(255, 96, 94, 116),
              screen: const FoodVideoPage(),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างปุ่มเมนูที่ปรับปรุงใหม่
  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}