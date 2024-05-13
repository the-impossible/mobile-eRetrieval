import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_retrieval/models/past_question.dart';
import 'package:e_retrieval/models/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../components/delegatedSnackBar.dart';
import 'package:permission_handler/permission_handler.dart';

class DatabaseService extends GetxController {
  String? uid;
  DatabaseService({this.uid});

  UserData? userData;

  // collection reference
  var usersCollection = FirebaseFirestore.instance.collection("Users");
  var pastQuestionCollection =
      FirebaseFirestore.instance.collection("PastQuestion");
  var filesCollection = FirebaseStorage.instance.ref();
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

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
  ) async {
    usersCollection.doc(uid).update({
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
  // Stream<String?> getProfileImage(String path) {
  //   try {
  //     Future.delayed(const Duration(milliseconds: 10000));
  //     return filesCollection.child(path).getDownloadURL().asStream();
  //   } catch (e) {
  //     return Stream.value(null);
  //   }
  // }

  // Stream<String?> getProfileImage(String path) async* {
  //   try {
  //     // Construct the reference to the file
  //     // Reference ref = filesCollection.child(path);
  //     firebase_storage.Reference ref = filesCollection.child(path);

  //     // Get the download URL of the file
  //     print("GOT: HERE");
  //     print("GOT: $ref");
  //     String? downloadUrl = await ref.getDownloadURL();
  //     print("GOT: $downloadUrl");

  //     // Emit the download URL to the stream
  //     yield downloadUrl;
  //   } catch (e) {
  //     // Emit null if there's an error
  //     yield null;
  //   }
  // }

  Stream<String?> getProfileImage(String path) async* {
    // Create a StreamController
    StreamController<String?> controller = StreamController<String?>();

    try {
      // Construct the reference to the file
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(path);

      // Get the download URL of the file
      String downloadUrl = await ref.getDownloadURL();
      print("GOT: $downloadUrl");

      // Emit the download URL to the stream
      controller.add(downloadUrl);

      // Close the stream after emitting the value
      controller.close();
    } catch (e) {
      // Emit null if there's an error
      controller.addError(e);

      // Close the stream in case of error
      controller.close();
    }

    // Return the stream
    yield* controller.stream;
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
  Future createAccountData(
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
        'type': type,
        'isCompleted': false,
        'dateCreated': FieldValue.serverTimestamp(),
      },
    );
  }

  // Update student profile
  Future<bool> updateStudentProfile(
    String uid,
    String name,
  ) async {
    usersCollection.doc(uid).update({
      "name": name,
    });
    return true;
  }

// Upload Files
  Future<bool> uploadPDF(String? uid, File file, String fileName) async {
    filesCollection.child("files/$uid/$fileName").putFile(file);
    return true;
  }

  //Upload Questions
  Future uploadQuestion(
    String uid,
    File file,
    String fileName,
    String course,
    String session,
    String semester,
    String level,
  ) async {
    try {
      await uploadPDF(uid, file, fileName);
      await pastQuestionCollection.doc(uid).set(
        {
          'course': course,
          'session': session,
          'semester': semester,
          'level': level,
          'fileName': fileName,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get uploaded past question
  Stream<List<PastQuestions>> getPastQuestions(
      String session, String semester, String level) {
    return pastQuestionCollection
        .where('session', isEqualTo: session)
        .where('semester', isEqualTo: semester)
        .where('level', isEqualTo: level)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => PastQuestions.fromJson(doc)).toList(),
        );
  }

  // Get uploaded past question
  Stream<List<UserData>> getUsersAccount(String type) {
    return usersCollection.snapshots().map(
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

  // Delete Question
  Future<bool> deletePastQuestion(String questionId, String fileId) async {
    try {
      final DocumentReference documentRef =
          pastQuestionCollection.doc(questionId);
      final DocumentSnapshot snapshot = await documentRef.get();
      var ref = filesCollection.child('files/$fileId/');

      if (snapshot.exists) {
        await documentRef.delete();
        await ref.delete();
        return true;
      } else {
        return false; // Document with specified ID does not exist
      }
    } catch (e) {
      print("Error deleting past question: $e");
      return false;
    }
  }

  // Delete User
  Future<bool> deleteUser(String userId) async {
    try {
      final DocumentReference documentRef = usersCollection.doc(userId);
      final DocumentSnapshot snapshot = await documentRef.get();
      var ref = filesCollection.child(userId);

      if (snapshot.exists) {
        await documentRef.delete();
        await ref.delete();
        return true;
      } else {
        return false; // Document with specified ID does not exist
      }
    } catch (e) {
      print("Error deleting user account: $e");
      return false;
    }
  }
}
