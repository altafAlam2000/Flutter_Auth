import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Utils/utils.dart';
import 'package:first_app/ui/Post/post_screen.dart';
import 'package:first_app/ui/auth/forgot_password.dart';
import 'package:first_app/ui/auth/login_with_phone.dart';
import 'package:first_app/ui/signup_screen.dart';
import 'package:first_app/widgets/round_btn.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
      // loading = false;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then(
      (value) {
        Utils().toastMsg("Login successfully");
        setState(() {
          loading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostScreen(),
            ));
      },
    ).onError(
      (error, stackTrace) {
        setState(() {
          loading = false;
        });
        Utils().toastMsg(error.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Login page"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Image(
                  // alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://t3.ftcdn.net/jpg/03/39/70/90/360_F_339709048_ZITR4wrVsOXCKdjHncdtabSNWpIhiaR7.jpg")),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: "Email",
                          helperText: "enter email e.g abc@gmail.com",
                          prefixIcon: Icon(Icons.email)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Password",
                          helperText: "enter password e.g 123456/abcdef",
                          prefixIcon: Icon(Icons.lock)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter password";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundBtn(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    login();
                  }
                },
                title: "Log in ",
                loading: loading,
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ));
                      },
                      child: const Text("Forgot Password"))),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("don't have an account? "),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ));
                      },
                      child: const Text("Sign Up")),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              RoundBtn(
                  loading: loading,
                  title: "Login with phone number",
                  onTap: () {
                    setState(() {
                      Timer(
                        const Duration(seconds: 1),
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LoginWithPhoneNumber(),
                            )),
                      );
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
