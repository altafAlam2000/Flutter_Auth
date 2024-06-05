// ignore_for_file: avoid_unnecessary_containers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:first_app/Utils/utils.dart';
import 'package:first_app/ui/Post/add_posts.dart';
import 'package:first_app/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("post");
  final searchFilterContorller = TextEditingController();
  final editContorller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Post Page"),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Utils().toastMsg("Log Out successfully");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                }).onError((error, stackTrace) {
                  Utils().toastMsg(error.toString());
                });
              },
              icon: const Icon(Icons.logout)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPostScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      drawer: const Drawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: searchFilterContorller,
              decoration: InputDecoration(
                hintText: "Serach",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FirebaseAnimatedList(
                  //FirebaseAnimatedList se data ko fatch krke frontend pr show kr skte hai but y ek widget hai. isliye stream builder ko user krke data fatch krenge
                  query: ref,
                  defaultChild: const Text("Loading"),
                  itemBuilder: (context, snapshot, animation, index) {
                    final id = snapshot.child("id").value.toString();
                    final name = snapshot.child("name").value.toString();
                    final title = snapshot.child("title").value.toString();

                    if (searchFilterContorller.text.isEmpty) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(snapshot.child("name").value.toString()),
                        subtitle:
                            Text(snapshot.child("title").value.toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(id, title);
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text("Edit"),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  ref.child(id).remove();
                                },
                                leading: const Icon(Icons.delete),
                                title: const Text("Delete"),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (title.toLowerCase().contains(
                            searchFilterContorller.text.toLowerCase()) ||
                        name.toLowerCase().contains(
                            searchFilterContorller.text.toLowerCase())) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(snapshot.child("name").value.toString()),
                        subtitle:
                            Text(snapshot.child("title").value.toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(id, title);
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text("Edit"),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  ref.child(id).remove();
                                },
                                leading: const Icon(Icons.delete),
                                title: const Text("Delete"),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ),
          // const SizedBox(
          //   // height: 10,
          //   child: Text(
          //     "StreamBuilder for fatch data from fire base",
          //     style:
          //         TextStyle(fontSize: 17, decoration: TextDecoration.underline),
          //   ),
          // ),
          // Expanded(
          //   child: StreamBuilder(
          //     stream: ref.onValue,
          //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //       if (!snapshot.hasData) {
          //         return const CircularProgressIndicator();
          //       } else {
          //         Map<dynamic, dynamic> map =
          //             snapshot.data!.snapshot.value as dynamic;
          //         List<dynamic> list = [];
          //         list.clear();
          //         list = map.values.toList();
          //         return ListView.builder(
          //           itemCount: snapshot.data?.snapshot.children.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(list[index]["name"]),
          //               subtitle: Text(list[index]["title"]),
          //             );
          //           },
          //         );
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> showMyDialog(String id, String title) async {
    editContorller.text = id;
    editContorller.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update"),
          content: Container(
            child: TextField(
              controller: editContorller,
              decoration: const InputDecoration(
                hintText: "Edit",
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancle")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update({
                    "title": editContorller.text.toLowerCase(),
                  }).then(
                    (value) {
                      Utils().toastMsg("Post Updated");
                    },
                  ).onError(
                    (error, stackTrace) {
                      Utils().toastMsg(error.toString());
                    },
                  );
                },
                child: const Text("Update"))
          ],
        );
      },
    );
  }
}
