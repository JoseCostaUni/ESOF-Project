import 'package:flutter/material.dart';


class LoginDemo extends StatefulWidget {
  const LoginDemo({super.key});

  @override
  State<LoginDemo> createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 177, 168),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 60.0,
              width: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginDemo()),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: () {
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                bottom: 20.0,
                top: 20.0,
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                bottom: 20,
              ),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'put you password',
                ),
              ),
            ),
            SizedBox(
              width: 360,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.blue, fontSize: 15.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
