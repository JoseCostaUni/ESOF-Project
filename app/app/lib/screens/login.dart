import 'package:app/firebase/firebase_auth_services.dart';
import 'package:app/screens/homepage.dart';
import 'package:app/screens/signuppage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUp()),
                      );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  const SizedBox(width: 20.0),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                bottom: 20.0,
                top: 20.0,
              ),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 224, 196, 188),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    labelText: 'Email',
                    hintText: 'Enter valid email',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                bottom: 20,
              ),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 224, 196, 188),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    labelText: 'Password',
                    hintText: 'put your password',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 19),
            GestureDetector(
              onTap: () {
                // Implemente aqui a ação para o esquecimento de senha
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            SizedBox(
              width: 360,
              child: ElevatedButton(
                onPressed: _signIn,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 224, 167, 153))),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 15.0),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.facebook),
                  onPressed: () {
                    // Ação quando o ícone do Facebook for pressionado
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.aod),
                  onPressed: () {
                    // Ação quando o ícone do Instagram for pressionado
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.aod),
                  onPressed: () {
                    // Ação quando o ícone do Google for pressionado
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print("User is successfully signedIn");
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const HomePage(title: "home")));
    }
  }
}
