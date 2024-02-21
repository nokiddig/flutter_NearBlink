import 'package:blog_app/services/firebase_authentication.dart';
import 'package:blog_app/utils/constant/my_const.dart';
import 'package:flutter/material.dart';

import '../../../model/account.dart';
import '../../../repository/account_repository.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(STRING_CONST.IMAGE_SIGNUP), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: COLOR_CONST.WHITE,
          toolbarHeight: 40,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Create\nAccount",
                    style: TextStyle(color: Colors.white, fontSize: 33),
                  ),
                ),
                UI_CONST.SIZEDBOX35,
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: UI_CONST.TEXTSTYLE_WHITE,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: COLOR_CONST.WHITE,
                        ),
                      )),
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{2,32}$');
                    if(regex.hasMatch(value ?? "")){
                      return null;
                    }
                    else {
                      return "Between 8-32 characters.";
                    }
                  },
                ),
                UI_CONST.SIZEDBOX25,
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: UI_CONST.TEXTSTYLE_WHITE,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: COLOR_CONST.WHITE,
                        ),
                      )),
                  validator: (value) {
                    RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if(regex.hasMatch(value ?? "")){
                      return null;
                    }
                    else {
                      return "Input your email.";
                    }
                  },
                ),
                UI_CONST.SIZEDBOX25,
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: UI_CONST.TEXTSTYLE_WHITE,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: COLOR_CONST.WHITE,
                        ),
                      )),
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{8,}$');
                    if(regex.hasMatch(value ?? "")){
                      return null;
                    }
                    else {
                      return "At least 8 characters.";
                    }
                  },
                ),
                UI_CONST.SIZEDBOX35,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                            singup(context);
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style:
                              TextStyle(color: COLOR_CONST.WHITE, fontSize: 30),
                        )),
                    CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xff4c505b),
                        child: IconButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Processing Data')),
                                );
                                singup(context);
                              }
                            },
                            icon: Icon(Icons.arrow_forward,
                              color: COLOR_CONST.WHITE,)))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> singup(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Result"),
          content: FutureBuilder<bool>(
            future: registerWithEmail(email, password),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data == true) {
                  registerAccount(email, password, name);
                  return const Text('Sign up successfully!');
                } else {
                  return const Text('Failed to sign up, please try again!');
                }
              }
            },
          ),
        );
      },
    );
  }

  void registerAccount(String email, String password, String name) {
    AccountRepository viewModel = AccountRepository();
    viewModel.add(Account.clone(email, name));
  }
}
