import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'firebase_options.dart';
import 'calc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

// โมเดลข้อมูลร้านค้า
class Store {
  final String name;
  final LatLng location;
  Store({required this.name, required this.location});
}

// โมเดลข้อมูลอาหารที่ระบุสาขาที่มีขาย
class FoodItem {
  final String name;
  final int price;
  final String imageUrl;
  final String category;
  final String description;
  final String videoId;
  final List<Store> availableAt; // ระบุว่าเมนูนี้มีที่ร้านไหนบ้าง

  FoodItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.videoId,
    required this.availableAt,
  });
}

// 1. กำหนดรายชื่อสาขาทั้งหมด
final List<Store> allShops = [
  Store(
    name: "กระบี่อันดามัน อาหารปักษ์ใต้",
    location: const LatLng(18.2782, 99.4991),
  ),
  Store(
    name: "อาหารตามสั่งลุงกับป้า",
    location: const LatLng(18.2780, 99.4990),
  ),
  Store(
    name: "รสดี ต้มเลือดหมู บะหมี่เกี้ยว",
    location: const LatLng(18.2795, 99.4991),
  ),
];

// 2. กำหนดรายการอาหารและระบุว่า "อยู่ที่ร้านไหน"
final List<FoodItem> foodMenu = [
  FoodItem(
    name: "หมูนุ่มผัดกระเทียม",
    price: 45,
    imageUrl:
        "https://img.wongnai.com/p/1920x0/2021/01/14/db4ab9bc2b294ffd9d433cda20103972.jpg",
    category: "ของคาว",
    description: "หมูนุ่มชิ้นโต ผัดคลุกเคล้ากระเทียมเจียวกรอบ หอมฟุ้งติดจมูก",
    videoId: "PaqmKrj60zI",
    availableAt: [allShops[0], allShops[1]], // มีขายที่สาขา 1 และ 2
  ),
  FoodItem(
    name: "บะหมี่เกี๊ยวแห้ง",
    price: 50,
    imageUrl:
        "https://lh3.googleusercontent.com/gps-cs-s/AG0ilSz6y2yLytg-NKtqKNqFvYt3HhBj8uIkJSf8pPoiHZdg5_mTfyH6hEfj1AXTf4zqKBS3aH99AMGtzI6P9hglJUgnh7TrDgCnTqJUbslzLWw1Ne4rrqU4rSkD0C27S3ZyY8DT2BCoEg=w172-h224-p-k-no",
    category: "ของคาว",
    description: "บะหมี่เกี๊ยวแห้งรสเข้มข้น หอมน้ำมันเจียว ปรุงจัดจ้านถึงใจ",
    videoId: "_GtNoYKPPxQ",
    availableAt: [allShops[0]], // มีขายที่สาขา 1
  ),
  FoodItem(
    name: "กะเพราไก่ไข่ดาว",
    price: 35,
    imageUrl:
        "https://fit-d.com/image_webp/f?src=./uploads/food/afb2ccb7050c6a64d52b7e3736d3a6f8.jpg",
    category: "ของคาว",
    description: "ผัดกะเพราสูตรโบราณ รสชาติจัดจ้าน",
    videoId: "040gpENCw_Q",
    availableAt: [allShops[0], allShops[1]], // มีขายที่สาขา 1 และ 2
  ),
  FoodItem(
    name: "ข้าวขาหมู",
    price: 60,
    imageUrl:
        "https://recipe.sgethai.com/wp-content/uploads/2025/06/040625-pork-leg-stew-with-rice-cover.webp",
    category: "ของคาว",
    description: "ขาหมูตุ๋นเปื่อยยุ่ย ละลายในปาก เคี่ยวเข้าเนื้อรสกลมกล่อม",
    videoId: "DKBDJu_2u8o",
    availableAt: [allShops[1]], // มีขายที่สาขา 2
  ),
  FoodItem(
    name: "บัวลอยไข่หวาน",
    price: 25,
    imageUrl:
        "https://img.wongnai.com/p/1968x0/2019/08/11/ec78ce9851df4449b6ccc3452192b9a7.jpg",
    category: "ของหวาน",
    description: "บัวลอยแป้งนุ่มหนึบ กะทิสดหอม",
    videoId: "5IQLYXCBDp8",
    availableAt: [allShops[2], allShops[1]], //สาขา3//2
  ),
  FoodItem(
    name: "ลอดช่อง",
    price: 20,
    imageUrl:
        "https://arit.kpru.ac.th/ap2/local/contents/Food_kpp/thumbs/thumb_2(5286).webp",
    category: "ของหวาน",
    description: "ลอดช่องน้ำกะทิ หอมมันหวานกำลังดี เย็นฉ่ำชื่นใจ",
    videoId: "WP6c32Ha_aI",
    availableAt: [allShops[0]], //สาขา1
  ),
  FoodItem(
    name: "ไอติมกะทิ",
    price: 25,
    imageUrl:
        "https://recipe.sgethai.com/wp-content/uploads/2025/04/cover-coconut-ice-cream-1.webp",
    category: "ของหวาน",
    description: "ไอติมกะทิสูตรโบราณ คั้นสดจากมะพร้าวแท้ หอมอบควันเทียน",
    videoId: "VSTiadJcUzU",
    availableAt: [allShops[2]], //สาขา3
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestore = FirebaseFirestore.instance;
  String _gpsStatus = "กำลังระบุตำแหน่ง...";
  String _distanceInfo = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      Store? nearestStore;
      double minDistance = double.infinity;

      for (var store in allShops) {
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          store.location.latitude,
          store.location.longitude,
        );
        if (distance < minDistance) {
          minDistance = distance;
          nearestStore = store;
        }
      }

      setState(() {
        _gpsStatus =
            "พิกัดของคุณ: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
        _distanceInfo =
            "ใกล้สุด: ${nearestStore?.name} (${(minDistance / 1000).toStringAsFixed(2)} กม.)";
      });
    }
  }

  void _showFoodDetails(FoodItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  VideoPlayerWidget(videoId: item.videoId),
                  const SizedBox(height: 20),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${item.price} บาท",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 30),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "📍 ร้านที่มีเมนูนี้จำหน่าย (${item.availableAt.length} แห่ง):",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: item.availableAt.first.location,
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                            // วนลูปแสดงหมุด "เฉพาะร้านที่มีเมนูนี้ขาย"
                            markers: item.availableAt
                                .map(
                                  (store) => Marker(
                                    point: store.location,
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 35,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _addToCart(item);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Text(
                        "เพิ่มลงตะกร้าสินค้า",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addToCart(FoodItem item) async {
    await firestore.collection("food_tab").add({
      "food_name": item.name,
      "price": item.price,
      "image_url": item.imageUrl,
      "category": item.category,
      "timestamp": FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("เพิ่ม ${item.name} ลงตะกร้าแล้ว")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Komai Food & Map"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalcPage()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.blue.shade50,
            child: ListTile(
              leading: const Icon(Icons.my_location, color: Colors.blue),
              title: Text(
                _distanceInfo.isEmpty ? "กำลังหาตำแหน่ง..." : _distanceInfo,
              ),
              subtitle: Text(_gpsStatus),
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader("เมนูแนะนำ", Icons.restaurant),
          // สร้างรายการอาหารจากลิสต์ foodMenu
          ...foodMenu.map((item) => _buildFoodTile(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepOrange),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildFoodTile(FoodItem item) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(item.name),
        subtitle: Text("${item.price} บาท"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showFoodDetails(item),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoId;
  const VideoPlayerWidget({super.key, required this.videoId});
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
