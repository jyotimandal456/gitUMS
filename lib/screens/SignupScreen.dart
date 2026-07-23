import 'package:flutter/material.dart';
import 'package:git_ums/routes/app_routes.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.blue,
              Colors.black,
              Colors.blue,
              Colors.white,
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),

              child: Container(
                padding: EdgeInsets.all(25),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      spreadRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Icon(
                      Icons.person_add_alt_1,
                      size: 70,
                      color: Color(0xff667eea),
                    ),

                    SizedBox(height: 15),

                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Sign up to get started",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),

                    SizedBox(height: 30),

                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email",

                        prefixIcon: Icon(Icons.email_outlined),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    TextField(
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        labelText: "Password",

                        prefixIcon: Icon(Icons.lock_outline),

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,

                      height: 50,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.main);
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff667eea),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),

                        child: Text(
                          "Create Account",

                          style: TextStyle(
                            fontSize: 17,

                            color: Colors.white,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //
                    //   children: [
                    //     Text(
                    //       "Already have an account? ",
                    //       style: TextStyle(color: Colors.grey),
                    //     ),
                    //
                    //     // GestureDetector(
                    //     //   onTap: () {
                    //     //    Navigator.pushNamed(context,AppRoutes.login);
                    //     //   },
                    //     //
                    //     //   child: Text(
                    //     //     "Login",
                    //     //
                    //     //     style: TextStyle(
                    //     //       color: Color(0xff667eea),
                    //     //
                    //     //       fontWeight: FontWeight.bold,
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
