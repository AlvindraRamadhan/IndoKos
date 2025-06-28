class Booking {
  final String id;
  final String kosId;
  final String kosName;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final double totalPrice;
  final String paymentMethod;

  Booking({
    required this.id,
    required this.kosId,
    required this.kosName,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalPrice,
    required this.paymentMethod,
  });
}
