import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'build.dart';

import 'fireBaseHelper.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String email = "";
  String name = "";
  String password = "";
  String conpassword = "";

  late BuildContext dialogContext;
  bool passR = true;
  bool pass = true;
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> fState = GlobalKey<FormState>();
    final TextEditingController _pass = TextEditingController();
    final TextEditingController _confirmPass = TextEditingController();

    return Scaffold(
      //  appBar: AppBar(), drawer: Drawer(),
      body: Form(
        key: _form,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* Icon(
                  Icons.arrow_back,
                  size: 50,
                ),*/
              ],
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Text("Create Your New Account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(padding: const EdgeInsets.all(20), child: const Text("Name", style: TextStyle(fontSize: 20))),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                onChanged: (text) {
                  name = text;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 20,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  hintText: "Your Name",
                  hintStyle: const TextStyle(fontSize: 20),
                  hintMaxLines: 1,
                  enabled: true,
                ),
              ),
            ),
            Container(padding: const EdgeInsets.all(20), child: const Text("Email Adress", style: TextStyle(fontSize: 20))),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                onChanged: (text) {
                  email = text;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.blue,
                    size: 20,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  hintText: " Email Adress",
                  hintStyle: const TextStyle(fontSize: 20),
                  hintMaxLines: 1,
                  enabled: true,
                ),
              ),
            ),
            Container(padding: const EdgeInsets.all(20), child: const Text("Password", style: TextStyle(fontSize: 20))),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters in length';
                  }
                  return null;
                },
                onChanged: (text) {
                  password = text;
                },
                obscureText: pass,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  hintText: " Password",
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
            Container(padding: const EdgeInsets.all(20), child: const Text(" Confirm Password", style: TextStyle(fontSize: 20))),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password';
                  } else if (password != value) {
                    final snackBar = const SnackBar(content: Text('Passwords do not match'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (text) {
                  conpassword = text;
                },
                obscureText: passR,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  hintText: "  Confirm Password",
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
                        passR = !passR;
                      });
                    },
                    icon: Icon(passR ? Icons.visibility_off : Icons.visibility),
                  ),
                  enabled: true,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  if (email.isEmpty || password.isEmpty || name.isEmpty || conpassword.isEmpty) {
                    buildShowSnackBar(context, "please check your info.");
                  } else if (password != conpassword) {
                    buildShowSnackBar(context, "Passwords do not match.");
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
                    FireBaseHelper()
                        .signUp(
                      email: email.trim().toString(),
                      password: password.trim().toString(),
                      name: name.trim().toString(),
                    )
                        .then((result) {
                      if (result == "true") {
                        Navigator.pushReplacementNamed(context, 'login');
                        FirebaseAuth.instance.currentUser!.updateDisplayName(name.trim().toString());
                        buildShowSnackBar(context, "Now you can login");
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
                  primary: Colors.blue,
                  padding: const EdgeInsets.only(right: 90, left: 90, top: 10, bottom: 10),
                  textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("signup"),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Have An Account?   ", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 158, 139, 138))),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed("login");
                      },
                      child: const Text("Sign in", style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
