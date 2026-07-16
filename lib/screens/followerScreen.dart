import 'package:flutter/material.dart';
import 'package:git_ums/screens/userscreen.dart';
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
          backgroundColor: Color(0xff141D2F),
          appBar: AppBar(
            backgroundColor: Color(0xff0D1117),
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Repositories",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView.builder(
            itemCount: provider.followers.length,
            itemBuilder: (context, index) {
              final follower = provider.followers[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(follower["avatar_url"],),),
                  title: Text(follower["login"],
                  style: TextStyle(color: Colors.white)
                    ),
                onTap: () {
                  provider.searchUser(follower["login"]);
                  Navigator.pushNamed(context, AppRoutes.user);
                  },
                );


            },
          ),
        );
      },
    );
  }
}