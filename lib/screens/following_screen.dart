import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GitProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Color(0xff0D1117),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Following",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),

          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff0D1117),
                      Color(0xff1E3A5F),
                      Color(0xff141D2F),
                    ],
                  ),
                ),
              ),

              // Positioned(
              //   top: -100,
              //   left: -70,
              //   child: Container(
              //     width: 220,
              //     height: 220,
              //     decoration: BoxDecoration(
              //       color: Colors.blue.withOpacity(.15),
              //       shape: BoxShape.circle,
              //     ),
              //   ),
              // ),
              // Positioned(
              //   bottom: -80,
              //   right: -50,
              //   child: Container(
              //     width: 240,
              //     height: 240,
              //     decoration: BoxDecoration(
              //       color: Colors.cyan.withOpacity(.10),
              //       shape: BoxShape.circle,
              //     ),
              //   ),
              // ),

              SafeArea(
                child: ListView.separated(
                  padding: EdgeInsets.all(18),

                  itemCount: provider.following.length,

                  separatorBuilder: (_, __) => SizedBox(height: 16),

                  itemBuilder: (context, index) {
                    final user = provider.following[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(20),

                      onTap: () async {
                        await provider.searchUser(user["login"]);

                        Navigator.pushNamed(context, AppRoutes.user);
                      },

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),

                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

                          child: Container(
                            padding: EdgeInsets.all(15),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                              color: Colors.white.withOpacity(.08),

                              border: Border.all(
                                color: Colors.white.withOpacity(.12),
                              ),
                            ),

                            child: Row(
                              children: [
                                Hero(
                                  tag: user["login"],

                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                      user["avatar_url"],
                                    ),
                                  ),
                                ),

                                SizedBox(width: 18),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        user["login"],

                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                      SizedBox(height: 6),

                                      Text(
                                        "GitHub User",

                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Container(
                                //   padding: EdgeInsets.all(8),
                                //
                                //   decoration: BoxDecoration(
                                //     color: Colors.blue.withOpacity(.20),
                                //     borderRadius: BorderRadius.circular(12),
                                //   ),
                                //
                                //   // child: Icon(
                                //   //   Icons.arrow_forward_ios,
                                //   //   color: Colors.white,
                                //   //   size: 18,
                                //   // ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
