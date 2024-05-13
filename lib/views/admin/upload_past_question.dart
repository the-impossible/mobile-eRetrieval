import 'dart:convert';
import 'dart:io';
import 'package:e_retrieval/components/delegatedForm.dart';
import 'package:e_retrieval/components/delegatedSnackBar.dart';
import 'package:e_retrieval/components/delegatedText.dart';
import 'package:e_retrieval/controller/getQuestionController.dart';
import 'package:e_retrieval/services/database.dart';
import 'package:e_retrieval/utils/constant.dart';
import 'package:e_retrieval/utils/form_validators.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadPastQuestion extends StatefulWidget {
  const UploadPastQuestion({super.key});

  @override
  State<UploadPastQuestion> createState() => _UploadPastQuestionState();
}

class _UploadPastQuestionState extends State<UploadPastQuestion> {
  GetQuestionController getQuestionController =
      Get.put(GetQuestionController());

  final _formKey = GlobalKey<FormState>();

  DatabaseService databaseService = Get.put(DatabaseService());

  PlatformFile? pickedFile;
  String selected = "No selected file";
  String preSelected = "";

  Future _pickPDF() async {
    setState(() {
      selected = "No selected file";
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );

    // if no file is found
    if (result == null) return;

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    pickedFile = result.files.first;

    if (pickedFile!.path != null && pickedFile!.path!.isNotEmpty) {

      preSelected = "File Selected!";
      setState(() {
        isDisabled = false;
      });

    } else {
      preSelected = "No selected file";

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(delegatedSnackBar("No File Selected!", false));
    }

    setState(() {
      selected = preSelected;
    });

    navigator!.pop(Get.context!);
  }

  void uploadFile() {
    getQuestionController.fileName = pickedFile!.name;
    getQuestionController.file = File(pickedFile!.path!);
    getQuestionController.uploadQuestion();
    setState(() {
      isDisabled = true;
      selected = "No selected file";
    });
  }

  bool isDisabled = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DelegatedText(
            text: "Upload Past Question Paper",
            fontSize: 18,
            color: Constants.darkColor,
            fontName: "InterBold",
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: Constants.darkColor,
            ),
          ),
          elevation: 0,
          backgroundColor: Constants.basicColor,
        ),
        backgroundColor: Constants.basicColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                        child: SvgPicture.asset(
                          'assets/create.svg',
                          width: 50,
                          height: 130,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: size.width * .4,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  _pickPDF();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primaryColor,
                                ),
                                child: DelegatedText(
                                  fontSize: 15,
                                  text: 'Select File',
                                  color: Constants.whiteColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DelegatedText(
                              text: selected,
                              fontSize: 15,
                              fontName: "InterBold",
                              color: Constants.darkColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      delegatedForm(
                        fieldName: 'Course Title',
                        icon: Icons.abc,
                        hintText: 'Enter course title',
                        validator: FormValidator.validateCourse,
                        formController: getQuestionController.courseController,
                        isSecured: false,
                      ),
                      const SizedBox(height: 20),
                      const Session(),
                      const SizedBox(height: 20),
                      const Semester(),
                      const SizedBox(height: 20),
                      const Level(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              (isDisabled)
                                  ? ScaffoldMessenger.of(Get.context!)
                                      .showSnackBar(delegatedSnackBar(
                                          "Select upload file", false))
                                  : uploadFile();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primaryColor,
                          ),
                          child: DelegatedText(
                            fontSize: 15,
                            text: 'Upload Past Question',
                            color: Constants.basicColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Session Dropdown
class Session extends StatefulWidget {
  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

List<String> sessions = [
  '2022/2023',
  '2021/2022',
];

class _SessionState extends State<Session> {
  GetQuestionController getQuestionController =
      Get.put(GetQuestionController());

  @override
  Widget build(BuildContext context) {
    String? sessionValue;

    return DropdownButtonFormField<String>(
      validator: FormValidator.validateField,
      decoration: const InputDecoration(
        fillColor: Constants.basicColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Constants.darkColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Constants.darkColor,
          ),
        ),
      ),
      value: sessionValue,
      hint: const Text('Select Session'),
      onChanged: (String? newValue) {
        setState(() {
          sessionValue = newValue!;
          getQuestionController.sessionController.text = newValue;
        });
      },
      items: sessions
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }
}

// Semester Dropdown
class Semester extends StatefulWidget {
  const Semester({super.key});

  @override
  State<Semester> createState() => _SemesterState();
}

List<String> semesters = [
  'First Semester',
  'Second Semester',
];

class _SemesterState extends State<Semester> {
  GetQuestionController getQuestionController =
      Get.put(GetQuestionController());

  @override
  Widget build(BuildContext context) {
    String? semesterValue;

    return DropdownButtonFormField<String>(
      validator: FormValidator.validateField,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Constants.darkColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Constants.darkColor,
          ),
        ),
      ),
      value: semesterValue,
      hint: const Text('Select Semester'),
      onChanged: (String? newValue) {
        setState(() {
          semesterValue = newValue!;
          getQuestionController.semesterController.text = newValue;
        });
      },
      items: semesters
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }
}

// Level Dropdown
class Level extends StatefulWidget {
  const Level({super.key});

  @override
  State<Level> createState() => _LevelState();
}

List<String> levels = [
  '100 Level',
  '200 Level',
  '300 Level',
  '400 Level',
];

class _LevelState extends State<Level> {
  GetQuestionController getQuestionController =
      Get.put(GetQuestionController());

  @override
  Widget build(BuildContext context) {
    String? levelValue;

    return DropdownButtonFormField<String>(
      validator: FormValidator.validateField,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Constants.darkColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Constants.darkColor,
          ),
        ),
      ),
      value: levelValue,
      hint: const Text('Select Level'),
      onChanged: (String? newValue) {
        setState(() {
          levelValue = newValue!;
          getQuestionController.levelController.text = newValue;
        });
      },
      items: levels
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }
}
