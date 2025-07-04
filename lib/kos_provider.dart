import 'package:flutter/material.dart';
import 'models.dart';

class KosProvider with ChangeNotifier {
  final List<KosData> _kosItems = [
    KosData(
      id: '1',
      name: 'Kos Melati Residence',
      address: 'Jl. Sudirman No. 123, Jakarta Pusat',
      price: 1500000,
      rating: 4.8,
      reviewCount: 156,
      image:
          'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      facilities: [
        'WiFi',
        'AC',
        'Kamar Mandi Dalam',
        'Parkir',
        'Dapur Bersama',
        'Laundry'
      ],
      type: 'putri',
      distance: '0.5 km',
      isWishlisted: false,
    ),
    KosData(
      id: '2',
      name: 'Kos Mawar Indah',
      address: 'Jl. Gatot Subroto No. 45, Jakarta Selatan',
      price: 1200000,
      rating: 4.6,
      reviewCount: 89,
      image:
          'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      facilities: ['WiFi', 'Kamar Mandi Dalam', 'Parkir'],
      type: 'putra',
      distance: '1.2 km',
      isWishlisted: true,
    ),
    KosData(
      id: '3',
      name: 'Kos Anggrek Premium',
      address: 'Jl. Thamrin No. 78, Jakarta Pusat',
      price: 2000000,
      rating: 4.9,
      reviewCount: 234,
      image:
          'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      facilities: [
        'WiFi',
        'AC',
        'Kamar Mandi Dalam',
        'Parkir',
        'Gym',
        'Kolam Renang',
        'Security 24 Jam'
      ],
      type: 'campur',
      distance: '2.1 km',
      isWishlisted: false,
    ),
    KosData(
      id: '4',
      name: 'Kos Dahlia Syariah',
      address: 'Jl. Kuningan No. 34, Jakarta Selatan',
      price: 1800000,
      rating: 4.7,
      reviewCount: 167,
      image:
          'https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      facilities: ['WiFi', 'AC', 'Kamar Mandi Dalam', 'Musholla', 'Parkir'],
      type: 'putri',
      distance: '1.8 km',
      isWishlisted: false,
    ),
  ];

  List<KosData> get allKos => _kosItems;
  List<KosData> get wishlistedKos =>
      _kosItems.where((kos) => kos.isWishlisted).toList();

  String _searchQuery = '';
  String _selectedType = 'all';

  String get searchQuery => _searchQuery;
  String get selectedType => _selectedType;

  void filterKos(String query, String type) {
    _searchQuery = query;
    _selectedType = type;
    notifyListeners();
  }

  List<KosData> get filteredKos {
    List<KosData> filtered = _kosItems;
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((kos) =>
              kos.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              kos.address.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    if (_selectedType != 'all') {
      filtered = filtered.where((kos) => kos.type == _selectedType).toList();
    }
    return filtered;
  }

  KosData findById(String id) {
    return _kosItems.firstWhere((kos) => kos.id == id,
        orElse: () => _kosItems.first);
  }

  void toggleWishlist(String id) {
    final kosIndex = _kosItems.indexWhere((kos) => kos.id == id);
    if (kosIndex != -1) {
      _kosItems[kosIndex].isWishlisted = !_kosItems[kosIndex].isWishlisted;
      notifyListeners();
    }
  }
}
