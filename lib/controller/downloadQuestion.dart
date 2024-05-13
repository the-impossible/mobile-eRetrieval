import 'dart:io';
import 'package:dio/dio.dart';
import 'package:e_retrieval/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadQuestionController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());

  Future<File?> downloadFile(String url, String name) async {
    try {
      final appStorage = await getApplicationDocumentsDirectory();

      final file = File("${appStorage.path}/$name");

      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: Duration.zero,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }

  Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);

    if (file == null) return;

    OpenFile.open(file.path);
  }

  Future downloadQuestionFile(String fileId, String fileName) async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // get file
    var filesCollection = FirebaseStorage.instance.ref();
    Reference ref = filesCollection.child('files/$fileId/').child(fileName);

    // Get the download URL of the file
    String downloadUrl = await ref.getDownloadURL();

    openFile(url: downloadUrl, fileName: fileName);
    navigator!.pop(Get.context!);

  }
}
