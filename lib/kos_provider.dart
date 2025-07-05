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
    KosData(
      id: '5',
      name: 'Griya Kencana Putra',
      address: 'Jl. Merdeka No. 101, Bandung',
      price: 950000,
      rating: 4.5,
      reviewCount: 78,
      image:
          'https://images.pexels.com/photos/2082087/pexels-photo-2082087.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      facilities: ['WiFi', 'Parkir', 'Dapur Bersama'],
      type: 'putra',
      distance: '3.5 km',
      isWishlisted: false,
    ),
    KosData(
      id: '6',
      name: 'Wisma Cendana Putri',
      address: 'Jl. Diponegoro No. 22, Surabaya',
      price: 1300000,
      rating: 4.8,
      reviewCount: 112,
      image:
          'https://images.pexels.com/photos/2102587/pexels-photo-2102587.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      facilities: ['WiFi', 'AC', 'Kamar Mandi Dalam', 'Laundry'],
      type: 'putri',
      distance: '1.1 km',
      isWishlisted: true,
    ),
    KosData(
      id: '7',
      name: 'Urban Living Campur',
      address: 'Jl. Kaliurang KM 5, Yogyakarta',
      price: 1600000,
      rating: 4.7,
      reviewCount: 188,
      image:
          'https://images.pexels.com/photos/271816/pexels-photo-271816.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      facilities: [
        'WiFi',
        'AC',
        'Kamar Mandi Dalam',
        'Parkir',
        'Dapur Bersama',
        'Security 24 Jam'
      ],
      type: 'campur',
      distance: '0.8 km',
      isWishlisted: false,
    ),
    KosData(
      id: '8',
      name: 'Kos Barokah Putra',
      address: 'Jl. Pahlawan No. 5, Semarang',
      price: 800000,
      rating: 4.3,
      reviewCount: 65,
      image:
          'https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      facilities: ['Kamar Mandi Dalam', 'Parkir'],
      type: 'putra',
      distance: '2.5 km',
      isWishlisted: false,
    ),
  ];

  List<KosData> get allKos => _kosItems;

  List<KosData> get wishlistedKos =>
      _kosItems.where((kos) => kos.isWishlisted).toList();

  String _searchQuery = '';
  String _selectedType = 'all';
  RangeValues _priceRange = const RangeValues(0, 5000000);
  double _minRating = 0;
  List<String> _selectedFacilities = [];

  String get searchQuery => _searchQuery;
  String get selectedType => _selectedType;
  RangeValues get priceRange => _priceRange;
  double get minRating => _minRating;
  List<String> get selectedFacilities => _selectedFacilities;

  void applyFilter(
      {String? query,
      String? type,
      RangeValues? range,
      double? rating,
      List<String>? facilities}) {
    _searchQuery = query ?? _searchQuery;
    _selectedType = type ?? _selectedType;
    _priceRange = range ?? _priceRange;
    _minRating = rating ?? _minRating;
    _selectedFacilities = facilities ?? _selectedFacilities;
    notifyListeners();
  }

  void resetFilter() {
    _searchQuery = '';
    _selectedType = 'all';
    _priceRange = const RangeValues(0, 5000000);
    _minRating = 0;
    _selectedFacilities = [];
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

    filtered = filtered
        .where((kos) =>
            kos.price >= _priceRange.start && kos.price <= _priceRange.end)
        .toList();

    if (_minRating > 0) {
      filtered = filtered.where((kos) => kos.rating >= _minRating).toList();
    }

    if (_selectedFacilities.isNotEmpty) {
      filtered = filtered
          .where((kos) => _selectedFacilities
              .every((facility) => kos.facilities.contains(facility)))
          .toList();
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
