import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'build.dart';

import 'fireBaseHelper.dart';

class login extends StatefulWidget {
  const login({super.key, required String myauth});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String email = "";
  String password = "";
  late BuildContext dialogContext;

  bool pass = true;
@override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(), drawer: Drawer(),
        body: Form(
      key: _form,
      child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          width: double.infinity,
          padding: const EdgeInsets.only(top: 25),
          child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start
              //  ,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Icon(
                      Icons.arrow_back,  size: 50, ),*/
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          "Welcome Back",
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                        )),
                    const Icon(
                      Icons.waving_hand,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text("Sign In To Your Account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Container(padding: const EdgeInsets.only(left: 40, bottom: 5, top: 60), child: const Text("Email Adress", style: TextStyle(fontSize: 20))),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: TextFormField(
                    onChanged: (text) {
                      email = text;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      hintText: "Email Adress",
                      hintStyle: const TextStyle(fontSize: 20),
                      hintMaxLines: 1,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.blue,
                        size: 20,
                      ),
                      enabled: true,
                    ),
                  ),
                ),
                Container(padding: const EdgeInsets.only(left: 40, bottom: 5, top: 50), child: const Text("Password", style: TextStyle(fontSize: 20))),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: TextFormField(
                    obscureText: pass,
                    onChanged: (text) {
                      password = text;
                    },
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      hintText: "Your Password",
                      hintStyle: const TextStyle(fontSize: 20),
                      hintMaxLines: 1,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.blue,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            pass = !pass;
                          });
                        },
                        icon: Icon(pass ? Icons.visibility_off : Icons.visibility),
                      ),
                      enabled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 200),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("forgetpass");
                    },
                    child: const Text(
                      "Forget Password?",
                      style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      if (email.isEmpty || password.isEmpty) {
                        buildShowSnackBar(context, "please check your info.");
                      } else {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              dialogContext = context;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        FireBaseHelper().signIn(email: email.trim().toString(), password: password.trim().toString()).then((result) {
                          if (result == "Welcome") {
                            Navigator.pushReplacementNamed(context, 'home_Page');
                            buildShowSnackBar(context, result + " " + FirebaseAuth.instance.currentUser!.displayName);
                          } else if (result != null) {
                            buildShowSnackBar(context, result);
                            Navigator.pop(dialogContext);
                          } else {
                            Navigator.pop(dialogContext);
                            buildShowSnackBar(context, "Try again.");
                          }
                        }).catchError((e) {
                          Navigator.pop(dialogContext);
                          buildShowSnackBar(context, e.toString());
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.only(right: 90, left: 90, top: 10, bottom: 10),
                      textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Sign in"),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't Have An Account?   ", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 158, 139, 138))),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed("Register");
                          },
                          child: const Text("Sign Up", style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ))
              ])),
    ));
  }
}
