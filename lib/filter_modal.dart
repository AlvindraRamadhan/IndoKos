import 'package:flutter/material.dart';
import 'app_theme.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  RangeValues _currentRangeValues = const RangeValues(500000, 3000000);
  String _selectedType = 'putra';
  final Map<String, bool> _facilities = {
    'WiFi': true,
    'AC': false,
    'Kamar Mandi Dalam': true,
    'Parkir': false,
    'Dapur Bersama': false,
    'Laundry': true,
    'Gym': false,
    'Kolam Renang': false,
    'Musholla': true,
    'Security 24 Jam': false
  };
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                onPressed: () => setState(() => _rating = index + 1.0),
              );
            }),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                    onPressed: () {}, child: const Text("Reset")),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Terapkan Filter")),
              )
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
