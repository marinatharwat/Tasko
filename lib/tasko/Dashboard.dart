// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:untitled4/tasko/project.dart';

import '../Auth/fireBaseHelper.dart';
import '../home/task.dart';

class Dachboard extends StatefulWidget {
  const Dachboard({super.key});

  @override
  State<Dachboard> createState() => _DachboardState();
}

class _DachboardState extends State<Dachboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Tasko",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 30),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  FireBaseHelper().signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
                },
                icon: const Icon(Icons.logout_sharp, color: Colors.black))
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.add),
        //   onPressed: () {
        //     Navigator.of(context).pushNamed("add");
        //   },
        // ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(children: <Widget>[
                  Container(
                    width: 340,
                    height: 160,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 255, 253, 155)),
                    padding: const EdgeInsets.only(left: 110),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Projects()));
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.home),
                          Text(
                            "Project",
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(207, 232, 248, 1),
                          ),
                          padding: const EdgeInsets.only(left: 30),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Tasks()));
                            },
                            child: Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Icon(
                                  Icons.rocket,
                                  color: Color.fromARGB(255, 7, 68, 237),
                                  size: 30,
                                ),
                                const Text("Tasks", style: TextStyle(fontSize: 25)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(179, 248, 208, 1),
                          ),
                          padding: const EdgeInsets.only(left: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("completed");
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.domain_verification,
                                  color: Color.fromARGB(255, 8, 111, 11),
                                  size: 30,
                                ),
                                Text(
                                  "Complete",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromRGBO(248, 168, 168, 1)),
                          padding: const EdgeInsets.only(left: 1),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("notcompleted");
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.error_outline, color: Color.fromARGB(255, 250, 49, 9), size: 25),
                                  Text("Not Complete", style: TextStyle(fontSize: 23), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromRGBO(215, 224, 219, 1)),
                            padding: const EdgeInsets.only(left: 25),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed("rate");
                                },
                                child: Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    const Icon(Icons.stars_rounded, color: Color.fromARGB(255, 255, 157, 0), size: 30),
                                    const Text("Rate", style: TextStyle(fontSize: 25)),
                                  ],
                                ),
                              ),
                            )),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ]))));
  }
}
