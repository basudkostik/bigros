import 'package:bigross/constants/routers.dart';
import 'package:bigross/dialogs/error_dialog.dart';
import 'package:bigross/services/user/auth_exceptions.dart';
import 'package:bigross/services/user/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.amber[800],
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(email, password);
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(anasayfaRoute, (context) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute, (context) => false);
                }
              } on UserNotFoundException {
                await showErrorDialog(context, 'User not found');
              } on WrongPasswordException {
                await showErrorDialog(context, 'Wrong password');
              } on WeakPasswordException {
                await showErrorDialog(context, 'Weak password');
              } on EmailAlreadyInUseException {
                await showErrorDialog(context, 'Email already in use');
              } on InvalidEmailException {
                await showErrorDialog(context, 'Invalid email');
              } on GenericAuthException {
                await showErrorDialog(context, 'Authentication failed');
              } on UsernotLoggedInAuthException {
                await showErrorDialog(context, 'User not logged in');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not register yet? Register here!'),
          )
        ],
      ),
    );
  }
}
