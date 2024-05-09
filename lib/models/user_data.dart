import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  final String name;
  final String username;
  final String type;
  final DateTime? dateCreated;

  UserData({
    required this.id,
    required this.name,
    required this.username,
    required this.type,
    required this.dateCreated,
  });

  factory UserData.fromJson(DocumentSnapshot snapshot) {
    return UserData(
      id: snapshot.id,
      name: snapshot['name'],
      username: snapshot['username'],
      type: snapshot['type'],
      dateCreated: snapshot['dateCreated'] != null
          ? (snapshot['dateCreated'] as Timestamp).toDate()
          : null,
    );
  }
}
