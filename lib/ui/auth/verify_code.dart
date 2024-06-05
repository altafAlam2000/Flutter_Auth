import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Utils/utils.dart';
import 'package:first_app/ui/Post/post_screen.dart';
import 'package:first_app/widgets/round_btn.dart';
import 'package:flutter/material.dart';

class VerifyCodeSscreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeSscreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeSscreen> createState() => _VerifyCodeSscreenState();
}

class _VerifyCodeSscreenState extends State<VerifyCodeSscreen> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Verify"),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: "6Digits Code"),
            ),
            const SizedBox(
              height: 80,
            ),
            RoundBtn(
                title: "verify code",
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: phoneNumberController.text.toString());

                  try {
                    await auth.signInWithCredential(credential);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostScreen(),
                        ));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMsg(e.toString());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
