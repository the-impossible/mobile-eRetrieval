import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_retrieval/components/delegatedSnackBar.dart';
import 'package:e_retrieval/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountController extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());

  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future createAccount() async {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      QuerySnapshot snapUsername = await FirebaseFirestore.instance
          .collection('Users')
          .where("username", isEqualTo: usernameController.text)
          .get();

      if (snapUsername.docs.length != 1) {
        var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: "${usernameController.text}@gmail.com",
            password: passwordController.text);

        // Create a new user
        await databaseService.createAccountData(user.user!.uid,
            usernameController.text, nameController.text, 'std');

        ScaffoldMessenger.of(Get.context!).showSnackBar(
            delegatedSnackBar("Accounts created successfully!", true));

        usernameController.clear();
        nameController.clear();
        passwordController.clear();
      } else {
        if (snapUsername.docs.isNotEmpty) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              delegatedSnackBar("Registration number already exists!", false));
        }
      }
    } on FirebaseAuthException catch (e) {
      navigator!.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar(e.message.toString(), false));
    } catch (e) {
      navigator!.pop(Get.context!);
      print("object ${e.toString()}");
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar(e.toString(), false));
    } finally {
      navigator!.pop(Get.context!);
    }
  }
}
