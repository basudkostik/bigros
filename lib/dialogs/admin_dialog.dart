import 'package:bigross/views/admin_screen.dart';
import 'package:flutter/material.dart';

Future<void> showAdminLoginDialog(BuildContext context) async {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final bool isAuthenticated = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Admin Login'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Close dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (usernameController.text == 'admin' &&
                      passwordController.text == 'admin123') {
                    Navigator.of(context).pop(true);  
                  } else {
                    Navigator.of(context).pop(false);  
                  }
                },
                child: const Text('Login'),
              ),
            ],
          );
        },
      ) ??
      false;

  if (isAuthenticated) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminPage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Incorrect username or password.'),
      ),
    );
  }
}
