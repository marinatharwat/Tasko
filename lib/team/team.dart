import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class team extends StatefulWidget {
  const team({Key? key}) : super(key: key);

  @override
  State<team> createState() => _teamState();
}

class _teamState extends State<team> {
  List<String> selectedUsers = [];

  @override
  final usersref = FirebaseFirestore.instance.collection("users").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("taskadd");
            },
          ),
          title: const Text("Select Member Team", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: usersref,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Connection Error');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading ...');
            }
            var docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  activeColor: Colors.green,
                  title: Text(docs[index]['name']),
                  subtitle: Text(docs[index]['email']),
                  secondary: CircleAvatar(
                    backgroundColor: Colors.blue[700],
                    child: const Icon(
                      Icons.person_outline_outlined,
                      color: Colors.white,
                    ),
                  ),
                  value: selectedUsers.contains(docs[index].id),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selectedUsers.add(docs[index].id);
                      } else {
                        selectedUsers.remove(docs[index].id);
                      }
                    });
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed("taskadd");
          },
          child: Text('Selected members : ${selectedUsers.length}'),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ));
  }
}
