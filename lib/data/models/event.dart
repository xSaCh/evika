// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'user.dart';

class Event {
  User user;
  String description;
  String title;
  List<String> imageUrls;
  List<String> likedUsersId;
  List<String> comments;
  List<String> eventCategory;
  DateTime eventStartAt;
  DateTime eventEndAt;
  bool registrationRequired;
  List<String> keywords;
  List<String> hashTags;
  List<String> registration;
  int likes;

  Event({
    required this.user,
    required this.description,
    required this.title,
    required this.imageUrls,
    required this.likedUsersId,
    required this.comments,
    required this.eventCategory,
    required this.eventStartAt,
    required this.eventEndAt,
    required this.registrationRequired,
    required this.keywords,
    required this.hashTags,
    required this.registration,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'description': description,
      'title': title,
      'images': imageUrls,
      'likedUsers': likedUsersId,
      'comments': comments,
      'eventCategory': eventCategory,
      'eventStartAt': eventStartAt.toIso8601String(),
      'eventEndAt': eventEndAt.toIso8601String(),
      'registrationRequired': registrationRequired,
      'keywords': keywords,
      'hashTags': hashTags,
      'registration': registration,
      'likes': likes,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      description: map['description'] as String,
      title: map['title'] as String,
      imageUrls: List<String>.from(map['images']),
      likedUsersId: List<String>.from(map['likedUsers']),
      comments: List<String>.from(map['comments']),
      eventCategory: List<String>.from(map['eventCategory']),
      eventStartAt: DateTime.parse(map['eventStartAt']),
      eventEndAt: DateTime.parse(map['eventEndAt']),
      registrationRequired: map['registrationRequired'] as bool,
      keywords: List<String>.from(map['keywords']),
      hashTags: List<String>.from(map['hashTags']),
      registration: List<String>.from(map['registration']),
      likes: map['likes'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) =>
      Event.fromMap(json.decode(source) as Map<String, dynamic>);
}
/*
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      user: User.fromJson(json['user']),
      description: json['description'],
      title: json['title'],
      imageUrls: List<String>.from(json['images']),
      likedUsersId: List<String>.from(json['likedUsers']),
      comments: List<String>.from(json['comments']),
      eventCategory: List<String>.from(json['eventCategory']),
      eventStartAt: DateTime.parse(json['eventStartAt']),
      eventEndAt: DateTime.parse(json['eventEndAt']),
      registrationRequired: json['registrationRequired'],
      keywords: List<String>.from(json['keywords']),
      hashTags: List<String>.from(json['hashTags']),
      registration: List<String>.from(json['registration']),
      likes: json['likes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'description': description,
      'title': title,
      'images': imageUrls,
      'likedUsers': likedUsersId,
      'comments': comments,
      'eventCategory': eventCategory,
      'eventStartAt': eventStartAt.toIso8601String(),
      'eventEndAt': eventEndAt.toIso8601String(),
      'registrationRequired': registrationRequired,
      'keywords': keywords,
      'hashTags': hashTags,
      'registration': registration,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  } */