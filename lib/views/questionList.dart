import 'dart:io';

import 'package:e_retrieval/components/delegatedSnackBar.dart';
import 'package:e_retrieval/components/delegatedText.dart';
import 'package:e_retrieval/controller/downloadQuestion.dart';
import 'package:e_retrieval/models/past_question.dart';
import 'package:e_retrieval/models/user_data.dart';
import 'package:e_retrieval/services/database.dart';
import 'package:e_retrieval/utils/constant.dart';
import 'package:e_retrieval/utils/title_case.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class GetPastQuestionList extends StatefulWidget {
  const GetPastQuestionList({super.key});

  @override
  State<GetPastQuestionList> createState() => _GetPastQuestionListState();
}

class _GetPastQuestionListState extends State<GetPastQuestionList> {
  DatabaseService databaseService = Get.put(DatabaseService());
  DownloadQuestionController downloadQuestionController =
      Get.put(DownloadQuestionController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DelegatedText(
            text: "Past Question List",
            fontSize: 20,
            color: Constants.darkColor,
            fontName: "InterBold",
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
            color: Constants.darkColor,
          ),
          elevation: 0,
          backgroundColor: Constants.basicColor,
        ),
        backgroundColor: Constants.basicColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                children: [
                  DelegatedText(
                    text: "click to download any file",
                    fontSize: 18,
                    truncate: false,
                    fontName: "InterMed",
                    color: Constants.darkColor,
                  ),
                  SizedBox(
                    height: size.height * .7,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          StreamBuilder<List<PastQuestions>>(
                            stream: databaseService.getPastQuestions(
                              "${Get.arguments?['session'] ?? ''}",
                              "${Get.arguments?['semester'] ?? ''}",
                              "${Get.arguments?['level'] ?? ''}",
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                    "Something went wrong! ${snapshot.error}");
                              } else if (snapshot.hasData) {
                                final questionList = snapshot.data!;
                                if (questionList.isNotEmpty) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: questionList.length,
                                    itemBuilder: (context, index) {
                                      final questionData = questionList[index];
                                      return InkWell(
                                        onTap: () =>
                                            (databaseService.userData!.type ==
                                                    'adm')
                                                ? showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Confirm Action'),
                                                        content: const Text(
                                                            'Do you want to download or delete file? '),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              databaseService
                                                                  .deletePastQuestion(
                                                                      questionData
                                                                          .id,
                                                                      questionData
                                                                          .fileName);
                                                            },
                                                            child: const Text(
                                                                'Delete'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              downloadQuestionController
                                                                  .downloadQuestionFile(
                                                                      questionData
                                                                          .id,
                                                                      questionData
                                                                          .fileName);
                                                            },
                                                            child: const Text(
                                                                'Download'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  )
                                                : downloadQuestionController
                                                    .downloadQuestionFile(
                                                        questionData.id,
                                                        questionData.fileName),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          height: size.height * .13,
                                          decoration: BoxDecoration(
                                            color: Constants.basicColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    221, 207, 203, 203),
                                                blurRadius: 2,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    DelegatedText(
                                                      text: questionData.course
                                                          .titleCase(),
                                                      fontSize: 18,
                                                      truncate: true,
                                                      fontName: "InterMed",
                                                      color:
                                                          Constants.darkColor,
                                                    ),
                                                    const Spacer(),
                                                    Image.asset(
                                                      "assets/pdf.png",
                                                      width: 50,
                                                      height: 40,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 50.0, bottom: 30),
                                          child: SvgPicture.asset(
                                            'assets/noFound.svg',
                                            width: 50,
                                            height: 200,
                                          ),
                                        ),
                                        DelegatedText(
                                          text: "No Record Found",
                                          fontSize: 20,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
