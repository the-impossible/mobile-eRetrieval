import 'package:e_retrieval/components/delegatedForm.dart';
import 'package:e_retrieval/components/delegatedText.dart';
import 'package:e_retrieval/controller/createAccountController.dart';
import 'package:e_retrieval/utils/constant.dart';
import 'package:e_retrieval/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  final Function onClicked;

  const SignUp({
    super.key,
    required this.onClicked,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  CreateAccountController createAccountController =
      Get.put(CreateAccountController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.basicColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.basicColor,
          leading: IconButton(
            color: Constants.darkColor,
            onPressed: () {
              widget.onClicked();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      width: 150,
                    ),
                    DelegatedText(
                      text: "eRETRIEVAL",
                      fontSize: 20,
                      fontName: 'InterBold',
                    ),
                    const SizedBox(height: 10),
                    DelegatedText(
                      text:
                          "Let's Get Started!, create an account to access all features!",
                      fontSize: 15,
                      fontName: 'InterMed',
                    ),
                    const SizedBox(height: 30),
                    delegatedForm(
                      fieldName: 'Registration Number',
                      icon: Icons.abc,
                      hintText: 'Enter regNo',
                      validator: FormValidator.validateUsername,
                      formController:
                          createAccountController.usernameController,
                      isSecured: false,
                    ),
                    delegatedForm(
                      fieldName: 'Name',
                      icon: Icons.person,
                      hintText: 'Enter full name',
                      validator: FormValidator.validateName,
                      formController: createAccountController.nameController,
                      isSecured: false,
                    ),
                    delegatedForm(
                      fieldName: 'Password',
                      icon: Icons.password,
                      hintText: 'Enter password',
                      validator: FormValidator.validatePassword,
                      formController:
                          createAccountController.passwordController,
                      isSecured: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              createAccountController.createAccount();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          child: DelegatedText(text: "Sign up", fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DelegatedText(
                            text: "Already have an account?",
                            fontSize: 15,
                            color: Constants.darkColor,
                          ),
                          TextButton(
                            onPressed: () {
                              widget.onClicked();
                            },
                            child: DelegatedText(
                              text: "Sign in?",
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
      ),
    );
  }
}
