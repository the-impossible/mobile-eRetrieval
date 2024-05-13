import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_retrieval/components/delegatedSnackBar.dart';
import 'package:e_retrieval/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAdminAccount extends GetxController {
  DatabaseService databaseService = Get.put(DatabaseService());

  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future createAccount(String type) async {
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
        FirebaseApp secondaryApp = await Firebase.initializeApp(
          name: 'SecondaryApp',
          options: Firebase.app().options,
        );

        FirebaseAuth createAuth = FirebaseAuth.instanceFor(app: secondaryApp);

        var user = await createAuth.createUserWithEmailAndPassword(
          email: "${usernameController.text}@gmail.com",
          password: passwordController.text,
        );

        // Create a new user
        await DatabaseService().createAccountData(user.user!.uid,
            usernameController.text, nameController.text, type);

        // after creating the account, delete the secondary app
        await secondaryApp.delete();

        usernameController.clear();
        nameController.clear();
        passwordController.clear();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            delegatedSnackBar("Account created successfully!", true));
      } else {
        if (snapUsername.docs.isNotEmpty) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              delegatedSnackBar("account already exists!", false));
        }
      }
    } on FirebaseAuthException catch (e) {
      navigator!.pop(Get.context!);
      print("ERROR: $e");
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("account already exist", false));
    } finally {
      navigator!.pop(Get.context!);
    }
  }
}
