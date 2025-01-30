import 'package:bigross/constants/routers.dart';
import 'package:bigross/services/user/auth_service.dart';
import 'package:flutter/material.dart';

class VerifiyEmailView extends StatefulWidget {
  const VerifiyEmailView({super.key});

  @override
  State<VerifiyEmailView> createState() => _VerifiyEmailViewState();
}

class _VerifiyEmailViewState extends State<VerifiyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Column(
        children: [
          const Text("We have sent you an email. Please verify your email."),
          const Text(
              "If you haven't received the email, please click the button below."),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Send email verification')),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (context) => false);
            },
            child: const Text('Already verified? Go to login'),
          ),
        ],
      ),
    );
  }
}
