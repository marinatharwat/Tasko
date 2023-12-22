import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Auth/login.dart';

class forget extends StatefulWidget {
  const forget({super.key});

  @override
  State<forget> createState() => _forgetState();
}

String email = "";

class _forgetState extends State<forget> {
  @override
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final emailController = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: const Text(
            'Password Reset Email has been sent !',
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No user found for that email.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 50,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("login");
            }),
      ),
      body: Form(
        key: _form,
        child: ListView(
          children: [
            Container(
                padding: EdgeInsets.all(2.0),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "Forget Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, color: Color.fromARGB(255, 20, 20, 20), fontWeight: FontWeight.bold),
                )),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                "Please Enter Your Email Address To Recive a Verification cord. ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 121, 119, 119), height: 1.5),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Column(
              children: [
                Center(child: Image.asset("images/3.gif")),
                Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [Text("Email Address", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 10, 10, 10)))],
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.blue,
                        size: 20,
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      hintText: " Email Adress",
                      hintStyle: TextStyle(fontSize: 20),
                      hintMaxLines: 1,
                      enabled: true,
                    ),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Email';
                      } else if (!value.contains('@')) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_form.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                            });
                            resetPassword();
                          }
                        },
                        child: const Text(
                          'Send Email',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      TextButton(
                        onPressed: () => {
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, a, b) => const login(
                                  myauth: '',
                                ),
                                transitionDuration: const Duration(seconds: 0),
                              ),
                              (route) => false)
                        },
                        child: const Text(
                          'Login',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
