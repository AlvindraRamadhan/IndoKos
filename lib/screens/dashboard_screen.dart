import 'package:flutter/material.dart';
import 'package:indokos/widgets/bottom_nav_bar.dart';
import 'package:indokos/widgets/recommendation_card.dart';
import 'package:indokos/utils/mock_data.dart';
import 'package:indokos/screens/search_kos_screen.dart';
import 'package:indokos/screens/notification_screen.dart';
import 'package:indokos/screens/submit_kos_screen.dart';
import 'package:indokos/screens/booking_history_screen.dart';
import 'package:indokos/screens/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hi, Adam Bimantara',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Mau Cari Kost-kostan?',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 24),

              // Rekomendasi Kos Terbersih
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rekomendasi Kos Terbersih',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SearchKosScreen(filter: 'terbersih')),
                      );
                    },
                    child: const Text('Open',
                        style: TextStyle(color: Color(0xFF00B8A9))),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: mockKosList
                      .where((kos) => kos.facilities.contains('KM Dalam'))
                      .map((kos) => RecommendationCard(kos: kos))
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Termurah Section
              const Text('Termurah',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilterChip(
                    label: const Text('Tahunan'),
                    onSelected: (bool value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SearchKosScreen(filter: 'tahunan')),
                      );
                    },
                  ),
                  FilterChip(
                    label: const Text('Bulanan'),
                    onSelected: (bool value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SearchKosScreen(filter: 'bulanan')),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SubmitKosScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B8A9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Ajukan kos',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Riwayat Pemesanan
              const Text('Riwayat Pemesanan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Kost Aisyah Palembang',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text('1 januari 2022 - 1 januari 2023'),
                      const Text('Palembang, Sumatra Selatan'),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BookingHistoryScreen()),
                              );
                            },
                            child: const Text('Lihat Semua',
                                style: TextStyle(color: Color(0xFF00B8A9)))),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Rekomendasi Terbaik
              const Text('Rekomendasi Terbaik',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: mockKosList
                      .where((kos) => kos.rating >= 4.0)
                      .map((kos) => RecommendationCard(kos: kos))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            // Chat
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BookingHistoryScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
