import 'package:flutter/material.dart';
import 'contmodel.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  List<ContactModel> contacts = [
    ContactModel("Marina Tharwat", false),
    ContactModel("Kerolos Tharwat ", false),
    ContactModel("Danial Emad ", false),
    ContactModel("Ramy Tharwat", false),
    ContactModel("Maria Nasser ", false),
    ContactModel("Hifzy Atef", false),
    ContactModel("Yousam Yakoub", false),
  ];
  List<ContactModel> SelectedContent = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (BuildContext context, int index) {
                        // return item
                        return ContactItem(
                          contacts[index].name,
                          contacts[index].isSelected,
                          index,
                        );
                      }),
                ),
                SelectedContent.length > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              "select member (${SelectedContent.length})",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed("taskadd");
                            },
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ContactItem(String name, bool isSelected, int index) {
    return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[700],
          child: const Icon(
            Icons.person_outline_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: Color.fromARGB(255, 76, 211, 76),
              )
            : const Icon(
                Icons.check_circle_outline,
                color: Colors.grey,
              ),
        onTap: () {
          setState(() {
            contacts[index].isSelected = !contacts[index].isSelected;
            if (contacts[index].isSelected == true) {
              SelectedContent.add(ContactModel(name, true));
            } else if (contacts[index].isSelected == false) {
              SelectedContent.removeWhere((element) => element.name == contacts[index].name);
            }
          });
        });
  }
}
