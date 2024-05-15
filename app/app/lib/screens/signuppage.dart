import 'package:app/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'verifyemail.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  var deactivatedButton = const Color.fromRGBO(155, 117, 108, 1);
  var activatedButton = const Color.fromARGB(255, 224, 167, 153);
  var buttonColor = const Color.fromRGBO(155, 117, 108, 1);
  bool? acceptedTerms = false;
  bool showTerms = false;
  double passwordStrength = 0;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  void registeredUser() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      CreateuserDocument(userCredential);
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const VerifyEmailPage()));
        } on FirebaseAuthException {
      Navigator.pop(context);
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> CreateuserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'name': _nameController.text,
        'username': _usernameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showTerms) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 213, 177, 168),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 60.0, right: 180.0),
                child: Text(
                  'Help Buddies',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
                child: Center(
                  child: Text(
                    'Eu declaro que tenho mais de 18 anos de idade e estou legalmente autorizado a acessar este serviço/aplicativo. Confirmo que compreendo e aceito plenamente os termos de uso e políticas de privacidade desta aplicação.',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    title: const Text("Aceitar Termos"),
                    value: acceptedTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        acceptedTerms = value;
                        value!
                            ? buttonColor = activatedButton
                            : buttonColor = deactivatedButton;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showTerms = false;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 30, bottom: 30),
                      child: Text(
                        'Rejeitar Termos',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 360,
                child: ElevatedButton(
                  key: const ValueKey('Sign-up'),
                  onPressed: acceptedTerms! ? registeredUser : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      buttonColor,
                    ),
                  ),
                  child: const Text(
                    'Sign-up',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 177, 168),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 60.0, right: 180.0),
              child: Text(
                'Help Buddies',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 60.0,
              width: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                key: const ValueKey('Signin'),
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  const SizedBox(width: 20.0),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, bottom: 20.0, top: 20.0),
              child: TextField(
                key: const ValueKey('Name'),
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  fillColor: Color.fromARGB(255, 217, 194, 191),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Name',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
              child: TextField(
                key: const ValueKey('Surname'),
                controller: _surnameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  fillColor: Color.fromARGB(255, 217, 194, 191),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Surname',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, bottom: 20.0, top: 20.0),
              child: TextField(
                key: const ValueKey('Userame'),
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  fillColor: Color.fromARGB(255, 217, 194, 191),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Userame',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
              child: TextField(
                key: const ValueKey('Email'),
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  fillColor: Color.fromARGB(255, 217, 194, 191),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 20.0),
                child: Column(
                  children: [
                    TextField(
                      key: const ValueKey<String>('Password'),
                      controller: _passwordController,
                      onChanged: (value) => {
                        if (value.isEmpty)
                          {
                            setState(() {
                              passwordStrength = 0;
                            })
                          }
                        else if (value.length < 8)
                          {
                            setState(() {
                              passwordStrength = 1 / 3;
                            })
                          }
                        else if (value.length < 12)
                          {
                            setState(() {
                              passwordStrength = 2 / 3;
                            })
                          }
                        else
                          {
                            setState(() {
                              passwordStrength = 1;
                            })
                          }
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        fillColor: Color.fromARGB(255, 217, 194, 191),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                    LinearProgressIndicator(
                      backgroundColor: const Color.fromARGB(255, 213, 177, 168),
                      value: passwordStrength,
                      color: passwordStrength == 0
                          ? Colors.red
                          : passwordStrength == 1 / 3
                              ? Colors.orange
                              : passwordStrength == 2 / 3
                                  ? Colors.yellow
                                  : Colors.green,
                    ),
                  ],
                )),
            SizedBox(
              width: 360,
              child: ElevatedButton(
                key: const ValueKey('Next'),
                onPressed: () {
                  setState(() {
                    showTerms = true;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 224, 167, 153)),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
