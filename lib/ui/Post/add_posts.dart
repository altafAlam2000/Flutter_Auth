import 'package:firebase_database/firebase_database.dart';
import 'package:first_app/Utils/utils.dart';
import 'package:first_app/widgets/round_btn.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref("post");
  final postController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add posts"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      // maxLines: 5,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: 5,
                      controller: postController,
                      decoration: InputDecoration(
                        hintText: "What is in your mind?",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 30,
            ),
            RoundBtn(
                title: "Add Post",
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().millisecondsSinceEpoch.toString();

                  databaseRef
                      .child(
                          id) // DateTime.now().millisecondsSinceEpoch use for ID;
                      .set({
                    "id": id,
                    "name": nameController.text.toString(),
                    "title": postController.text.toString(),
                  }).then(
                    (value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMsg("Post added");
                    },
                  ).onError(
                    (error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMsg(error.toString());
                    },
                  );
                  setState(() {
                    // loading = true;
                    postController.clear();
                    nameController.clear();
                  });
                }),
          ],
        ),
      ),
    );
  }
}
