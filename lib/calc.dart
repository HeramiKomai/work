import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'main.dart';

class CalcPage extends StatefulWidget {
  const CalcPage({super.key});
  @override
  State<CalcPage> createState() => _CalcPageState();
}

class _CalcPageState extends State<CalcPage> {
  String _distanceLabel = "กำลังคำนวณระยะทาง...";

  @override
  void initState() {
    super.initState();
    _calculateDistance();
  }

  Future<void> _calculateDistance() async {
    try {
      Position pos = await Geolocator.getCurrentPosition();
      double minDistance = double.infinity;
      Store? nearest;

      for (var store in allShops) {
        double dist = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          store.location.latitude,
          store.location.longitude,
        );
        if (dist < minDistance) {
          minDistance = dist;
          nearest = store;
        }
      }

      setState(() {
        _distanceLabel =
            "ใกล้สุด: ${nearest?.name} (${(minDistance / 1000).toStringAsFixed(2)} กม.)";
      });
    } catch (e) {
      setState(() {
        _distanceLabel = "ไม่สามารถระบุระยะทางได้";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ตะกร้าสินค้า")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("food_tab")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          double total = docs.fold(
            0,
            (sum, doc) => sum + (doc['price'] as num).toDouble(),
          );

          return Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: const MapOptions(
                          initialCenter: LatLng(18.2782, 99.4991),
                          initialZoom: 14,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                            markers: allShops
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
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _distanceLabel,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Image.network(
                        data["image_url"] ?? "",
                        width: 50,
                        errorBuilder: (c, e, s) => const Icon(Icons.fastfood),
                      ),
                      title: Text(data["food_name"] ?? "ไม่มีชื่อ"),
                      subtitle: Text("${data["price"]} บาท"),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => docs[index].reference.delete(),
                      ),
                    );
                  },
                ),
              ),
              _buildSummarySection(total),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummarySection(double total) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("ยอดรวมสุทธิ:", style: TextStyle(fontSize: 18)),
              Text(
                "${total.toInt()} บาท",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text("ยืนยันการสั่งซื้อ"),
            ),
          ),
        ],
      ),
    );
  }
}
