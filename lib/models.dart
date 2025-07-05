import 'dart:convert';
import 'dart:io';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String provider;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.provider,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'name': name,
        'avatar': avatar,
        'provider': provider
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      avatar: map['avatar'],
      provider: map['provider']);

  String toJson() => json.encode(toMap());
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}

class KosData {
  final String id;
  final String name;
  final String address;
  final int price;
  final double rating;
  final int reviewCount;
  final String image;
  final List<String> facilities;
  final String type;
  final String distance;
  bool isWishlisted;

  KosData({
    required this.id,
    required this.name,
    required this.address,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.image,
    required this.facilities,
    required this.type,
    required this.distance,
    this.isWishlisted = false,
  });
}

class BookingHistoryItem {
  final String id,
      kosName,
      kosAddress,
      kosImage,
      checkInDate,
      status,
      bookingDate,
      paymentMethod;
  final int duration, totalAmount;

  BookingHistoryItem({
    required this.id,
    required this.kosName,
    required this.kosAddress,
    required this.kosImage,
    required this.checkInDate,
    required this.duration,
    required this.totalAmount,
    required this.status,
    required this.bookingDate,
    required this.paymentMethod,
  });
}

class NotificationItem {
  final String id, title, message, type;
  final DateTime timestamp;
  bool isRead;
  final String? actionUrl;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.actionUrl,
  });
}

class PromoItem {
  final String id, title, subtitle, image;

  PromoItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

class ChatRoom {
  final String id, name, avatar, lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  ChatRoom({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
  });
}

class ChatMessage {
  final String id, senderId, message;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.message,
    required this.timestamp,
  });
}

class KosSubmission {
  String name, address, city, type, price, description;
  List<String> facilities, rules;
  List<File> images;
  String contactName, contactPhone, contactEmail;

  KosSubmission({
    this.name = '',
    this.address = '',
    this.city = '',
    this.type = 'putra',
    this.price = '',
    this.description = '',
    List<String>? facilities,
    List<String>? rules,
    List<File>? images,
    this.contactName = '',
    this.contactPhone = '',
    this.contactEmail = '',
    // FIX: Removed unnecessary 'this.' qualifier
  })  : facilities = facilities ?? [],
        rules = rules ?? [],
        images = images ?? [];
}

class BookingData {
  String checkInDate;
  int duration;
  String fullName, phone, email, idNumber, emergencyContact;
  String additionalNotes;

  BookingData({
    this.checkInDate = '',
    this.duration = 1,
    this.fullName = '',
    this.phone = '',
    this.email = '',
    this.idNumber = '',
    this.emergencyContact = '',
    this.additionalNotes = '',
  });
}
