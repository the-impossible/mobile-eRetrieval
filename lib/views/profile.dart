import 'dart:io';
import 'package:e_retrieval/components/delegatedForm.dart';
import 'package:e_retrieval/components/delegatedSnackBar.dart';
import 'package:e_retrieval/components/delegatedText.dart';
import 'package:e_retrieval/components/error.dart';
import 'package:e_retrieval/controller/logoutController.dart';
import 'package:e_retrieval/controller/profileController.dart';
import 'package:e_retrieval/models/user_data.dart';
import 'package:e_retrieval/routes/routes.dart';
import 'package:e_retrieval/services/database.dart';
import 'package:e_retrieval/utils/constant.dart';
import 'package:e_retrieval/utils/form_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  File? image;
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = Get.put(DatabaseService());
  ProfileController profileController = Get.put(ProfileController());
  LogoutController logoutController = Get.put(LogoutController());

  Future pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      setState(() {
        image = File(pickedFile.path);
        profileController.image = image;
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          delegatedSnackBar("Failed to Capture image: $e", false));
    }
  }

  @override
  void initState() {
    profileController.nameController.text = databaseService.userData!.name;
    profileController.usernameController.text =
        databaseService.userData!.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                        stream: databaseService.getUserProfile(
                            FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Return a loading indicator while the future is still loading
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Constants.primaryColor),
                            );
                          } else if (snapshot.hasError) {
                            return const ErrorScreen();
                          } else if (snapshot.hasData) {
                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    StreamBuilder<String?>(
                                        stream: databaseService.getProfileImage(
                                            FirebaseAuth
                                                .instance.currentUser!.uid),
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
                                  text: profileController.nameController.text,
                                  fontSize: 20,
                                  fontName: 'InterBold',
                                ),
                                const SizedBox(height: 5),
                                DelegatedText(
                                  text: profileController
                                      .usernameController.text
                                      .toUpperCase(),
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
                                      profileController.nameController,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          profileController.updateAccount();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Constants.primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25))),
                                      child: DelegatedText(
                                          text: "Save Changes", fontSize: 18),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 5, top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DelegatedText(
                                        text: "reset Password?",
                                        fontSize: 15,
                                        color: Constants.darkColor,
                                      ),
                                      TextButton(
                                        onPressed: () => Get.toNamed(Routes.resetPassword),
                                        child: DelegatedText(
                                          text: "Reset?",
                                          fontSize: 15,
                                          color: Constants.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                (databaseService.userData!.type == "adm")
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            DelegatedText(
                                              text: "Admin Account?",
                                              fontSize: 15,
                                              color: Constants.darkColor,
                                            ),
                                            TextButton(
                                              onPressed: () => Get.toNamed(Routes.createAdmin),
                                              // => Get.toNamed(
                                              // Routes.createAdmin)
                                              child: DelegatedText(
                                                text: "Create Now",
                                                fontSize: 15,
                                                color: Constants.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                TextButton(
                                  onPressed: () => {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Logout'),
                                          content: const Text(
                                              'Are you sure you want to logout? '),
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
                                                logoutController.signOut();
                                              },
                                              child: const Text('Log out'),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  },
                                  child: DelegatedText(
                                    text: "Logout ",
                                    fontSize: 20,
                                    fontName: "InterBold",
                                    color: Constants.primaryColor,
                                  ),
                                ),
                              ],
                            );
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
