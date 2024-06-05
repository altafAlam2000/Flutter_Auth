import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Utils/utils.dart';
import 'package:first_app/ui/auth/verify_code.dart';
import 'package:first_app/widgets/round_btn.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final verificationCodeNumber = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text("Log in with phone number"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            TextFormField(
              controller: verificationCodeNumber,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: "+1234 5678 99"),
            ),
            const SizedBox(
              height: 80,
            ),
            RoundBtn(
                title: "Send code",
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  if (verificationCodeNumber.text.isEmpty) {
                    setState(() {
                      loading = false;
                      
                    });
                    // const Text("Enter Phone Number");
                    Utils().toastMsg("Enter phone Number");
                    // return null;
                  } else {
                    auth.verifyPhoneNumber(
                        phoneNumber: verificationCodeNumber.text,
                        verificationCompleted: (_) {
                          setState(() {
                            loading = false;
                          });
                        },
                        verificationFailed: (e) {
                          setState(() {
                            loading = false;
                          });
                          Utils().toastMsg(e.toString());
                        },
                        codeSent: (String verificationId, int? token) {
                          setState(() {
                            loading = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyCodeSscreen(
                                  verificationId: verificationId,
                                ),
                              ));
                        },
                        codeAutoRetrievalTimeout: (e) {
                          setState(() {
                            loading = false;
                          });
                          Utils().toastMsg(e.toString());
                        });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
