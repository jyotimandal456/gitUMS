import 'package:flutter/material.dart';
import 'package:git_ums/providers/authProvider.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24,),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 ElevatedButton(
                  onPressed: () async {
                    final auth =context.read<AuthProvider>();
                    final error =await auth.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    if (error == null){
                      Navigator.pushNamed(context, AppRoutes.main);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                    }
                  },
                  child: Text("Login"),
                ),
                SizedBox(width: 20,),
                ElevatedButton(
                  onPressed: () async {
                    final auth =context.read<AuthProvider>();
                    final error =await auth.signUp(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error?? 'Account created successfully')),
                    );
                  },
                  child: Text("Sign up"),
                ),
              ],

            ),

          ],
        ),
      ),
    );
  }
}