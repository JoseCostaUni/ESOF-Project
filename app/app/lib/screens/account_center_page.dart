import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/features/bottomappnavigator.dart';
import 'package:app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountCenterPage extends StatefulWidget {
  const AccountCenterPage({Key? key}) : super(key: key);

  @override
  State<AccountCenterPage> createState() => _AccountCenterPageState();
}

class _AccountCenterPageState extends State<AccountCenterPage> {
  int _currentIndex = 3;

  Future<void> _removeLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_password');
  }

  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _deletePasswordController = TextEditingController();

  Future<void> _deleteUser(String delpassword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: delpassword);
        await user.reauthenticateWithCredential(credential);
        await user.delete();
        final userEmail = user.email;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.email)
            .delete();
        await _removeLogIn();
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child("user_profile")
            .child('$userEmail.jpg');
        await ref.delete();
        print("Document successfully deleted");
      } catch (e) {
        print("Error deleting document: $e");
      }
    }
  }

  Future<void> _changePassword(String oldPassword, String new_password) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: oldPassword);
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(new_password);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_password', new_password);
      }
    } catch (e) {
      print("Error deleting document: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 255, 228, 225),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.only(top: 20.0),
                  iconSize: 40,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Account Center',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('Log out'),
            leading: const Icon(Icons.logout),
            onTap: () {
              FirebaseAuth.instance.signOut();
              _removeLogIn();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          ),
          ListTile(
            title: const Text('Change Password'),
            leading: const Icon(Icons.change_circle),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Change Password'),
                    actions: <Widget>[
                      TextFormField(
                        controller: _oldPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Old Password',
                        ),
                        obscureText: true,
                      ),
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                        ),
                        obscureText: true,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          String newPassword = _newPasswordController.text;
                          String oldPassword = _oldPasswordController.text;
                          _changePassword(oldPassword, newPassword);
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('Delete Account'),
            leading: const Icon(Icons.delete),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text(
                        "Deleting your account is permanent and your can't get it back"),
                    actions: <Widget>[
                      TextFormField(
                        controller: _deletePasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Insert Password',
                        ),
                        obscureText: true,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          String password = _deletePasswordController.text;
                          _deleteUser(password);
                          _removeLogIn();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
