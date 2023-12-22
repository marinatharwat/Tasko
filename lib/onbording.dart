// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class onbording extends StatefulWidget {
  const onbording({super.key});
  @override
  State<onbording> createState() => _onbordingState();
}

class _onbordingState extends State<onbording> {
  Widget dotpageview() {
    return (Builder(builder: ((context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < 3; i++)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: i == pagenember ? 25 : 6,
              height: 6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: i == pagenember
                      ? Colors.blue
                      : Color.fromARGB(255, 0, 1, 1)),
            ),
        ],
      );
    })));
  }

  int pagenember = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.only(left: 145, right: 120),
          onPressed: (() {}),
          icon: Icon(Icons.check_circle),
          color: Colors.blue,
          iconSize: 25,
        ),
        elevation: 0,
        title: const Text(
          "Tasko",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 253, 253),
      ),
      body: PageView(
        onPageChanged: (value) {
          setState(() {
            pagenember = value;
          });
        },
        children: [
          Wrap(
            children: [
              const SizedBox(height: 350),
              Center(child: Image.asset("images/1.gif")),
              const SizedBox(height: 300),
              Center(
                child: const Text(
                  "Manage your Task",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Center(
                child: const Text(
                  "Organize all your to - do's in projects .",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 140),
              dotpageview(),
              const SizedBox(height: 140),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("i already have an account?",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("login");
                    },
                    child: Text("Log in.",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              const SizedBox(height: 45),
              Image.asset("images/2.gif"),
              const SizedBox(height: 20),
              const Text(
                "Save the time",
                style: TextStyle(fontSize: 25),
              ),
              const Text(
                "We must complete the task  as soon as possible .",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 60),
              dotpageview(),
              const SizedBox(height: 135),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("i already have an account?",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("login");
                    },
                    child: Text("Log in.",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/5.gif"),
              const SizedBox(height: 20),
              const Text(
                "Teamwork",
                style: TextStyle(fontSize: 25),
              ),
              const Text(
                "Teamwork helps improve your work skills .",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 60),
              dotpageview(),
              const SizedBox(height: 30),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text("Get start"),
                padding: EdgeInsets.symmetric(horizontal: 50),
                onPressed: () {
                  Navigator.of(context)
                      .restorablePushReplacementNamed("Register");
                },
              ),
              const SizedBox(height: 65),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("i already have an account?",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("login");
                    },
                    child: Text("Log in.",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
