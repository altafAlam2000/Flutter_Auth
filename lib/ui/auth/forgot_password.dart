// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:first_app/Utils/utils.dart';
import 'package:first_app/ui/auth/login_screen.dart';
import 'package:first_app/widgets/round_btn.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailContoroller = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailContoroller,
              decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundBtn(
                title: "Forgot password",
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  var forgotEmail = emailContoroller.text.trim();

                  try {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: forgotEmail)
                        .then(
                      (value) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMsg(
                            "we have sent email for recover password please check email");
                        Timer(
                          const Duration(seconds: 2),
                          () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              )),
                        );
                        
                      },
                    ).onError(
                      (error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMsg(error.toString());
                      },
                    );
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMsg(e.toString());
                    print("ERROR $e");
                  }
                  setState(() {
                    emailContoroller.clear();
                  });
                }),
          ],
        ),
      ),
    );
  }
}
