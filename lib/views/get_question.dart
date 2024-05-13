import 'package:e_retrieval/components/delegatedSnackBar.dart';
import 'package:e_retrieval/components/delegatedText.dart';
import 'package:e_retrieval/controller/getQuestionController.dart';
import 'package:e_retrieval/routes/routes.dart';
import 'package:e_retrieval/services/database.dart';
import 'package:e_retrieval/utils/constant.dart';
import 'package:e_retrieval/utils/form_validators.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetPastQuestion extends StatefulWidget {
  const GetPastQuestion({super.key});

  @override
  State<GetPastQuestion> createState() => _GetPastQuestionState();
}

class _GetPastQuestionState extends State<GetPastQuestion> {
  GetQuestionController getQuestionController =
      Get.put(GetQuestionController());

  final _formKey = GlobalKey<FormState>();

  DatabaseService databaseService = Get.put(DatabaseService());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DelegatedText(
            text: "Retrieve Past Question Paper",
            fontSize: 18,
            color: Constants.darkColor,
            fontName: "InterBold",
          ),
          elevation: 0,
          backgroundColor: Constants.basicColor,
          actions: [
            (databaseService.userData!.type == 'adm')
                ? Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(
                      onPressed: () => Get.toNamed(Routes.uploadQuestion),
                      icon: const Icon(
                        Icons.add_circle,
                        size: 35,
                        color: Constants.primaryColor,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
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
                          'assets/search.svg',
                          width: 50,
                          height: 130,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Session(),
                      const SizedBox(height: 20),
                      const Semester(),
                      const SizedBox(height: 20),
                      const Level(),
                      const SizedBox(height: 20),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: size.width,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (getQuestionController
                                      .sessionController.text.isEmpty ||
                                  getQuestionController
                                      .semesterController.text.isEmpty ||
                                  getQuestionController
                                      .levelController.text.isEmpty) {
                                ScaffoldMessenger.of(Get.context!).showSnackBar(
                                    delegatedSnackBar(
                                        "All fields is required!", false));
                              } else {
                                Get.toNamed(Routes.questionList, arguments: {
                                  'session': getQuestionController
                                      .sessionController.text,
                                  'semester': getQuestionController
                                      .semesterController.text,
                                  'level': getQuestionController
                                      .levelController.text,
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primaryColor,
                          ),
                          child: DelegatedText(
                            fontSize: 15,
                            text: 'Get Past Questions',
                            color: Constants.basicColor,
                          ),
                        ),
                      ),
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
      hint: const Text('Select Levels'),
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
