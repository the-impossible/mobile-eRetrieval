import 'dart:io';
import 'package:e_retrieval/components/delegatedDropDown.dart';
import 'package:e_retrieval/components/delegatedForm.dart';
import 'package:e_retrieval/components/delegatedSnackBar.dart';
import 'package:e_retrieval/components/delegatedText.dart';
import 'package:e_retrieval/components/error.dart';
import 'package:e_retrieval/controller/studentDetailController.dart';
import 'package:e_retrieval/models/user_data.dart';
import 'package:e_retrieval/routes/routes.dart';
import 'package:e_retrieval/services/database.dart';
import 'package:e_retrieval/utils/constant.dart';
import 'package:e_retrieval/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class StudentDetailsPage extends StatefulWidget {
  const StudentDetailsPage({super.key});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  File? image;
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = Get.put(DatabaseService());
  StudentDetailController studentDetailController =
      Get.put(StudentDetailController());

  Future pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      setState(() {
        image = File(pickedFile.path);
        studentDetailController.image = image;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Failed to Capture image: $e", false));
    }
  }

  void getStudentData() async {
    studentDetailController.userID = Get.arguments['userID'] ?? "";
    UserData? studentData =
        await databaseService.getStudentProfile(Get.arguments['userID'] ?? "");
    studentDetailController.usernameController.text = studentData!.username;
    studentDetailController.nameController.text = studentData.name;
  }

  @override
  void initState() {
    getStudentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: DelegatedText(
              text: "Student Details",
              fontSize: 20,
              color: Constants.basicColor,
              fontName: "InterBold",
            ),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              color: Constants.basicColor,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                              'Are you sure you want to delete user? '),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                databaseService
                                    .deleteUser(Get.arguments['userID'] ?? "");
                                Get.back();
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    size: 35,
                    color: Constants.basicColor,
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Constants.basicColor,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: StreamBuilder<UserData?>(
                        stream: databaseService
                            .getUserProfile(Get.arguments['userID'] ?? ""),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const ErrorScreen();
                          } else if (snapshot.hasData) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final accountData = snapshot.data!;
                              return Column(
                                children: [
                                  Stack(
                                    children: [
                                      StreamBuilder<String?>(
                                          stream:
                                              databaseService.getProfileImage(
                                                  Get.arguments['userID'] ??
                                                      ""),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: CircleAvatar(
                                                  maxRadius: 60,
                                                  minRadius: 60,
                                                  child: ClipOval(
                                                    child: Image.asset(
                                                      "assets/user.png",
                                                      width: 160,
                                                      height: 160,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else if (snapshot.hasData) {
                                              return Center(
                                                child: CircleAvatar(
                                                  maxRadius: 60,
                                                  minRadius: 60,
                                                  child: ClipOval(
                                                    child: (image != null)
                                                        ? Image.file(
                                                            image!,
                                                            width: 160,
                                                            height: 160,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.network(
                                                            snapshot.data!,
                                                            width: 160,
                                                            height: 160,
                                                            fit: BoxFit.cover,
                                                            // colorBlendMode: BlendMode.darken,
                                                          ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 90,
                                          left: 80,
                                        ),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () => pickImage(),
                                            child: const CircleAvatar(
                                              backgroundColor:
                                                  Constants.whiteColor,
                                              child: Icon(
                                                Icons.add_a_photo,
                                                color: Constants.primaryColor,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  DelegatedText(
                                    text: accountData.name,
                                    fontSize: 20,
                                    fontName: 'InterBold',
                                  ),
                                  const SizedBox(height: 10),
                                  DelegatedText(
                                    text: accountData.username,
                                    fontSize: 20,
                                    fontName: 'InterBold',
                                  ),
                                  const SizedBox(height: 5),
                                  DelegatedText(
                                    text: 'submit form below to update profile',
                                    fontSize: 15,
                                    fontName: 'InterMed',
                                  ),
                                  const SizedBox(height: 30),
                                  delegatedForm(
                                    fieldName: 'Name',
                                    icon: Icons.person,
                                    hintText: 'Enter Full name',
                                    validator: FormValidator.validateName,
                                    isSecured: false,
                                    formController:
                                        studentDetailController.nameController,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            studentDetailController
                                                .updateAccount();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Constants.primaryColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25))),
                                        child: DelegatedText(
                                            text: "Update Account",
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const ErrorScreen();
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
