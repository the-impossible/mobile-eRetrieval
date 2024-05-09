import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_retrieval/models/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../components/delegatedSnackBar.dart';

class DatabaseService extends GetxController {
  String? uid;
  DatabaseService({this.uid});

  UserData? userData;

  // collection reference
  var usersCollection = FirebaseFirestore.instance.collection("Users");
  var pastQuestionCollection =
      FirebaseFirestore.instance.collection("PastQuestion");
  var filesCollection = FirebaseStorage.instance.ref();

  //get user and populate the userData model
  Future<UserData?> getUser(String uid) async {
    // Query database to get user type
    final snapshot = await usersCollection.doc(uid).get();
    // Return user type as string
    if (snapshot.exists) {
      userData = UserData.fromJson(snapshot);
      return UserData.fromJson(snapshot);
    }
    return null;
  }

  // Update user profile
  Future<bool> updateProfile(
    String uid,
    String name,
    String age,
    String gender,
    String token,
  ) async {
    usersCollection.doc(uid).update({
      "age": age,
      "gender": gender,
      "name": name,
      "token": token,
    });
    return true;
  }

  // Update student profile
  Future<bool> updateStudentProfile(
    String uid,
    String name,
    String age,
    String gender,
  ) async {
    usersCollection.doc(uid).update({
      "age": age,
      "gender": gender,
      "name": name,
    });
    return true;
  }

  // update user profile image
  Future<bool> updateImage(File? image, String path) async {
    filesCollection.child(path).putFile(image!);
    return true;
  }

  // Get profile image
  Stream<String?> getProfileImage(String path) {
    try {
      Future.delayed(const Duration(milliseconds: 3600));
      return filesCollection.child(path).getDownloadURL().asStream();
    } catch (e) {
      return Stream.value(null);
    }
  }

  // Get a user profile
  Stream<UserData?> getUserProfile(String uid) {
    return usersCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserData.fromJson(snapshot);
      }
      return null;
    });
  }

  Future<UserData?> getStudentProfile(String uid) async {
    try {
      var snapshot = await usersCollection.doc(uid).get();
      if (snapshot.exists) {
        return UserData.fromJson(snapshot);
      }
      return null;
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  // Set Image
  Future<bool> setImage(String? uid) async {
    final ByteData byteData = await rootBundle.load("assets/user.png");
    final Uint8List imageData = byteData.buffer.asUint8List();
    filesCollection.child("$uid").putData(imageData);
    return true;
  }

  //Create user
  Future createStudentData(
    String uid,
    String username,
    String name,
    String college,
    String department,
    String session,
    String type,
  ) async {
    await setImage(uid);
    return await usersCollection.doc(uid).set(
      {
        'username': username,
        'name': name,
        'college': college,
        'department': department,
        'session': session,
        'type': type,
        'isCompleted': false,
        'gender': "",
        'age': "",
        'token': "",
        'dateCreated': FieldValue.serverTimestamp(),
      },
    );
  }

  //Create user
  Future createAdminData(
    String uid,
    String username,
    String name,
    String type,
  ) async {
    await setImage(uid);
    return await usersCollection.doc(uid).set(
      {
        'username': username,
        'name': name,
        'college': "",
        'department': "",
        'session': "",
        'type': type,
        'isCompleted': false,
        'gender': "",
        'age': "",
        'token': "",
        'dateCreated': FieldValue.serverTimestamp(),
      },
    );
  }

  // Get student accounts
  Stream<List<UserData>> getAccounts(
      String type, String session, String college) {
    return usersCollection
        .where('type', isEqualTo: type)
        .where('session', isEqualTo: session)
        .where('college', isEqualTo: college)
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => UserData.fromJson(doc)).toList(),
        );
  }

  // Get image
  Future<String?> getImage(String uid) async {
    try {
      final url = await filesCollection.child(uid).getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
}
