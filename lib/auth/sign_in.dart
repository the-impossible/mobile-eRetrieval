import 'package:e_retrieval/components/delegatedText.dart';
import 'package:e_retrieval/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  final Function onClicked;

  const SignIn({
    super.key,
    required this.onClicked,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 20,
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: 150,
                  ),
                  DelegatedText(
                    text: 'Welcome back, to eRetrieval, where managing event is made easy!',
                    fontSize: 20,
                    fontName: 'InterBold',
                  ),
                  const SizedBox(height: 5),
                  DelegatedText(
                    text: 'login to your existing account!',
                    fontSize: 15,
                    fontName: 'InterMed',
                  ),
                  const SizedBox(height: 40),

                  // DelegatedForm(
                  //   isVisible: false,
                  //   fieldName: 'Email',
                  //   icon: Icons.mail,
                  //   hintText: 'Enter email address',
                  //   validator: FormValidator.validateEmail,
                  //   formController: loginController.emailController,
                  //   isSecured: false,
                  // ),
                  // DelegatedForm(
                  //   isVisible: true,
                  //   fieldName: 'Password',
                  //   icon: Icons.password,
                  //   hintText: 'Enter password',
                  //   formController: loginController.passwordController,
                  //   isSecured: true,
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          //loginController.signIn()
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.secondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        child: DelegatedText(text: "Sign in", fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DelegatedText(
                          text: "Don't have an account?",
                          fontSize: 15,
                          color: Constants.darkColor,
                        ),
                        TextButton(
                          onPressed: () {
                            widget.onClicked();
                          },
                          child: DelegatedText(
                            text: "Sign up?",
                            fontSize: 15,
                            color: Constants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
