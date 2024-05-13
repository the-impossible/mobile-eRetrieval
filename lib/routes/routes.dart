import 'package:e_retrieval/splashScreen.dart';
import 'package:e_retrieval/views/admin/createAdmin.dart';
import 'package:e_retrieval/views/admin/createUsers.dart';
import 'package:e_retrieval/views/admin/student_details.dart';
import 'package:e_retrieval/views/admin/upload_past_question.dart';
import 'package:e_retrieval/views/questionList.dart';
import 'package:e_retrieval/views/reset_password.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = '/';
  static String signIn = '/signIn';
  static String signUp = '/signUp';
  static String studHome = '/studHome';
  static String profilePage = '/profilePage';
  static String resetPassword = '/resetPassword';

  // Admin Pages
  static String adminHome = '/adminHome';
  static String uploadQuestion = '/uploadQuestion';
  static String questionList = '/questionList';
  static String createAdmin = '/createAdmin';
  static String createUser = '/createUser';
  static String studentDetails = '/studentDetails';
}

bool isLogin = true;

final getPages = [
  GetPage(
    name: Routes.splash,
    page: () => const Splash(),
  ),
  GetPage(
    name: Routes.uploadQuestion,
    page: () => const UploadPastQuestion(),
  ),
  GetPage(
    name: Routes.questionList,
    page: () => const GetPastQuestionList(),
  ),
    GetPage(
    name: Routes.resetPassword,
    page: () => const ResetPassword(),
  ),
  GetPage(
    name: Routes.createUser,
    page: () => const CreateUser(),
  ),
  GetPage(
    name: Routes.studentDetails,
    page: () => const StudentDetailsPage(),
  ),
  GetPage(
    name: Routes.createAdmin,
    page: () => const CreateAdmin(),
  ),
];
