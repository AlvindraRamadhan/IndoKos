import 'package:flutter/material.dart';

class FacilityChip extends StatelessWidget {
  final String facility;

  const FacilityChip({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(facility),
      backgroundColor: const Color(0xFFE0F7FA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }
}
