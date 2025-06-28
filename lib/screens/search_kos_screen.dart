import 'package:flutter/material.dart';
import 'package:indokos/models/kos_model.dart';
import 'package:indokos/widgets/kos_card.dart';
import 'package:indokos/utils/mock_data.dart';
import 'package:indokos/screens/kos_detail_screen.dart';

class SearchKosScreen extends StatefulWidget {
  final String? filter;

  const SearchKosScreen({super.key, this.filter});

  @override
  State<SearchKosScreen> createState() => _SearchKosScreenState();
}

class _SearchKosScreenState extends State<SearchKosScreen> {
  List<Kos> filteredKosList = [];

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  void _applyFilter() {
    if (widget.filter == 'termurah') {
      filteredKosList = List.from(mockKosList)
        ..sort((a, b) => a.price.compareTo(b.price));
    } else if (widget.filter == 'terbersih') {
      filteredKosList = mockKosList
          .where((kos) => kos.facilities.contains('KM Dalam'))
          .toList();
    } else if (widget.filter == 'tahunan') {
      filteredKosList = mockKosList
          .where((kos) => kos.type == 'tahunan')
          .toList();
    } else if (widget.filter == 'bulanan') {
      filteredKosList = mockKosList
          .where((kos) => kos.type == 'bulanan')
          .toList();
    } else {
      filteredKosList = mockKosList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Kost')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredKosList.length,
        itemBuilder: (context, index) {
          final kos = filteredKosList[index];
          return KosCard(
            kos: kos,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KosDetailScreen(kos: kos),
                ),
              );
            },
            onWishlistChanged: (isWishlisted) {
              setState(() {
                kos.isWishlisted = isWishlisted;
              });
            },
          );
        },
      ),
    );
  }
}
