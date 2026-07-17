import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/git_provider.dart';
import '../routes/app_routes.dart';

class FollowersScreen extends StatelessWidget {
  const FollowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GitProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Followers",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: Stack(
            children: [
              /// Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff2193b0),
                      Color(0xff6dd5ed),
                      Color(0xffccf2ff),
                    ],
                  ),
                ),
              ),

              /// Decorative circles
              Positioned(
                top: -80,
                left: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.18),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                bottom: -100,
                right: -70,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              SafeArea(
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: 18,
                    right: 18,
                    top: 10,
                    bottom: 30,
                  ),
                  itemCount: provider.followers.length,
                  itemBuilder: (context, index) {
                    final follower = provider.followers[index];

                    return followerCard(context, follower, provider);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget followerCard(
    BuildContext context,
    Map follower,
    GitProvider provider,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () async {
          await provider.searchUser(follower["login"]);
          Navigator.pushNamed(context, AppRoutes.user);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white.withOpacity(.18),
                border: Border.all(
                  color: Colors.white.withOpacity(.35),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.12),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Hero(
                    tag: follower["login"],
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.blue.shade100],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 42,
                        backgroundImage: NetworkImage(follower["avatar_url"]),
                      ),
                    ),
                  ),

                  SizedBox(height: 18),

                  Text(
                    follower["login"],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 6),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.18),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "GitHub Developer",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),

                  SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.person),
                      label: Text("View Profile"),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xff2193b0),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        await provider.searchUser(follower["login"]);
                        Navigator.pushNamed(context, AppRoutes.user);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
