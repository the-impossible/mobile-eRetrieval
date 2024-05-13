import 'package:e_retrieval/components/delegatedForm.dart';
import 'package:e_retrieval/components/delegatedText.dart';
import 'package:e_retrieval/controller/createAccountController.dart';
import 'package:e_retrieval/controller/createAdminAccountController.dart';
import 'package:e_retrieval/utils/constant.dart';
import 'package:e_retrieval/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({
    super.key,
  });

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  CreateAdminAccount createAdminAccount = Get.put(CreateAdminAccount());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: DelegatedText(
            text: "Create User Account",
            fontSize: 20,
            color: Constants.basicColor,
            fontName: "InterBold",
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
            color: Constants.basicColor,
          ),
          elevation: 0,
          backgroundColor: Constants.primaryColor,
        ),
        backgroundColor: Constants.basicColor,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    DelegatedText(
                      text: "fill the form below to create a user account!",
                      fontSize: 15,
                      fontName: 'InterMed',
                    ),
                    const SizedBox(height: 30),
                    delegatedForm(
                      fieldName: 'Registration Number',
                      icon: Icons.abc,
                      hintText: 'Enter RegNo',
                      validator: FormValidator.validateUsername,
                      formController: createAdminAccount.usernameController,
                      isSecured: false,
                    ),
                    delegatedForm(
                      fieldName: 'Name',
                      icon: Icons.person,
                      hintText: 'Enter full name',
                      validator: FormValidator.validateName,
                      formController: createAdminAccount.nameController,
                      isSecured: false,
                    ),
                    delegatedForm(
                      fieldName: 'Password',
                      icon: Icons.password,
                      hintText: 'Enter password',
                      validator: FormValidator.validatePassword,
                      formController: createAdminAccount.passwordController,
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
                              createAdminAccount.createAccount("std");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          child:
                              DelegatedText(text: "Create User", fontSize: 18),
                        ),
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
