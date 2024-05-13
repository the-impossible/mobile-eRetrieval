import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_retrieval/components/delegatedSnackBar.dart';
import 'package:e_retrieval/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class GetQuestionController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());

  File? file;
  String? fileName;

  TextEditingController semesterController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController sessionController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  Future uploadQuestion() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // generate uuid
    String uid = const Uuid().v4();
    // upload past question

    bool isSuccessful = await databaseService.uploadQuestion(
      uid,
      file!,
      fileName!,
      courseController.text,
      sessionController.text,
      semesterController.text,
      levelController.text,
    );

    if (isSuccessful) {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Past Question Uploaded Successfully!", true));
      courseController.clear();
      sessionController.clear();
      semesterController.clear();
      levelController.clear();
      Get.back();
    } else {
      navigator!.pop(Get.context!);
    }
  }
}
