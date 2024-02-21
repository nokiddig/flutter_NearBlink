import 'package:blog_app/services/save_account.dart';
import 'package:blog_app/ui/screen/app/bottom_navigation_app.dart';
import 'package:blog_app/ui/screen/login/signup_screen.dart';
import 'package:blog_app/utils/constant/my_const.dart';
import 'package:flutter/material.dart';
import '../../../services/firebase_authentication.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isCheckedSave = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SaveAccount saveAccount = SaveAccount();

  @override
  void initState() {
    _emailController.text = saveAccount.email;
    _passwordController.text = saveAccount.pass;
    _isCheckedSave = saveAccount.isCheckedSave;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(STRING_CONST.IMAGE_SIGNIN), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 20),
              child: const Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            style: UI_CONST.TEXTSTYLE_BLACK,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                            )
                          ),
                          UI_CONST.SIZEDBOX30,
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                            )
                          ),
                          UI_CONST.SIZEDBOX35,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("Remember me",
                                style: UI_CONST.TEXTSTYLE_BLACK,),
                              Checkbox(
                                value: _isCheckedSave,
                                onChanged: (value) {
                                  _isCheckedSave = !_isCheckedSave;
                                  setState(() {
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      login();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          UI_CONST.SIZEDBOX35,

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Route route = MaterialPageRoute(builder: (context) => const SignUpScreen());
                                  Navigator.push(context, route);
                                },
                                //style: ButtonStyle(),
                                child: const Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    forgotPassword();                                  },
                                  child: const Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    bool checkAccount = false;
    if (_isCheckedSave){
      saveAccount.save(_emailController.text, _passwordController.text, _isCheckedSave);
    }
    else {
      saveAccount.clear();
    }

    await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Result"),
          content: FutureBuilder<bool>(
            future: signInWithEmailAndPassword(email, password),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 100,
                  child: Center(
                      child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data == true) {
                  checkAccount = true;
                  SaveAccount.currentEmail = email;
                  Navigator.pop(context);
                  return const Text('Sign in successfully!');
                } else {
                  return const Text('The email or password you entered is not correct!');
                }
              }
            },
          ),
        );
      },
    );

    if (checkAccount == true) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationApp(),));
    }
  }

  void forgotPassword() {
    String email = _emailController.text;
    sendPasswordResetEmail(email);
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Reset Password"),
        content: const Text("Reset Password sent successfully!"),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("Ok"))
        ],
      );
    },);
  }
}