import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'kos_provider.dart'; // Import KosProvider

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late RangeValues _currentRangeValues;
  late String _selectedType;
  late Map<String, bool> _facilities;
  late double _rating;

  @override
  void initState() {
    super.initState();
    // Initialize state from the provider
    final provider = Provider.of<KosProvider>(context, listen: false);
    _currentRangeValues = provider.priceRange;
    _selectedType = provider.selectedType;
    _rating = provider.minRating;
    _facilities = {
      'WiFi': provider.selectedFacilities.contains('WiFi'),
      'AC': provider.selectedFacilities.contains('AC'),
      'Kamar Mandi Dalam':
          provider.selectedFacilities.contains('Kamar Mandi Dalam'),
      'Parkir': provider.selectedFacilities.contains('Parkir'),
      'Dapur Bersama': provider.selectedFacilities.contains('Dapur Bersama'),
      'Laundry': provider.selectedFacilities.contains('Laundry'),
      'Gym': provider.selectedFacilities.contains('Gym'),
      'Kolam Renang': provider.selectedFacilities.contains('Kolam Renang'),
      'Musholla': provider.selectedFacilities.contains('Musholla'),
      'Security 24 Jam':
          provider.selectedFacilities.contains('Security 24 Jam'),
    };
  }

  void _resetFilter() {
    Provider.of<KosProvider>(context, listen: false).resetFilter();
    Navigator.of(context).pop();
  }

  void _applyFilter() {
    final provider = Provider.of<KosProvider>(context, listen: false);
    final selectedFacilities = _facilities.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    provider.applyFilter(
      type: _selectedType,
      range: _currentRangeValues,
      rating: _rating,
      facilities: selectedFacilities,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // This will fix the bottom overflow issue
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Filter Pencarian",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Rentang Harga (per bulan)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            RangeSlider(
              values: _currentRangeValues,
              min: 0,
              max: 5000000,
              divisions: 50,
              activeColor: AppTheme.primaryColor,
              labels: RangeLabels(
                'Rp ${_currentRangeValues.start.round()}',
                'Rp ${_currentRangeValues.end.round()}',
              ),
              onChanged: (RangeValues values) {
                setState(() => _currentRangeValues = values);
              },
            ),
            const SizedBox(height: 16),
            const Text("Jenis Kos",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'putra', label: Text('Putra')),
                ButtonSegment(value: 'putri', label: Text('Putri')),
                ButtonSegment(value: 'campur', label: Text('Campur')),
              ],
              selected: {_selectedType},
              onSelectionChanged: (newSelection) =>
                  setState(() => _selectedType = newSelection.first),
            ),
            const SizedBox(height: 24),
            const Text("Fasilitas",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _facilities.keys.map((String key) {
                return FilterChip(
                  label: Text(key),
                  selected: _facilities[key]!,
                  onSelected: (bool value) {
                    setState(() => _facilities[key] = value);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text("Rating Minimal",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: Colors.amber,
                  ),
                  onPressed: () => setState(() => _rating = (index + 1.0)),
                );
              }),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: _resetFilter, child: const Text("Reset")),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                      onPressed: _applyFilter,
                      child: const Text("Terapkan Filter")),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
