import 'package:flutter/material.dart';
import 'package:git_ums/screens/userscreen.dart';
import 'package:provider/provider.dart';
import '../providers/git_provider.dart';

class FollowersScreen extends StatelessWidget {
  const FollowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GitProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title:  Text("Followers"),
          ),
          body: ListView.builder(
            itemCount: provider.followers.length,
            itemBuilder: (context, index) {
              final follower = provider.followers[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(follower["avatar_url"],),),
                  title: Text(follower["login"]),
                onTap: () {
                  provider.searchUser(follower["login"]);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => UserDetailScreen ()));
                  },
                );


            },
          ),
        );
      },
    );
  }
}