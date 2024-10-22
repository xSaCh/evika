import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginUser {
  String username;
  String email;
  String firstName;
  String lastName;
  String password;
  String role;
  bool emailVerified;
  bool isVerified;
  bool profileCompleted;
  List<String> eventGroups;
  List<String> events;
  List<String> followers;
  List<String> following;
  List<String> interests;
  List<String> preferences;
  List<String> registeredEvents;
  LoginUser({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.role,
    required this.emailVerified,
    required this.isVerified,
    required this.profileCompleted,
    required this.eventGroups,
    required this.events,
    required this.followers,
    required this.following,
    required this.interests,
    required this.preferences,
    required this.registeredEvents,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'role': role,
      'emailVerified': emailVerified,
      'isVerified': isVerified,
      'profileCompleted': profileCompleted,
      'eventGroups': eventGroups,
      'events': events,
      'followers': followers,
      'following': following,
      'interests': interests,
      'preferences': preferences,
      'registeredEvents': registeredEvents,
    };
  }

  factory LoginUser.fromMap(Map<String, dynamic> map) {
    return LoginUser(
      username: map['username'] as String,
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      password: map['password'] as String,
      role: map['role'] as String,
      emailVerified: map['emailVerified'] as bool,
      isVerified: map['isVerified'] as bool,
      profileCompleted: map['profileCompleted'] as bool,
      eventGroups: List<String>.from(map['eventGroups']),
      events: List<String>.from(map['events']),
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
      interests: List<String>.from(map['interests']),
      preferences: List<String>.from(map['preferences']),
      registeredEvents: List<String>.from(map['registeredEvents']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginUser.fromJson(String source) =>
      LoginUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
