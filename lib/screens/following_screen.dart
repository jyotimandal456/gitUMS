import 'package:flutter/material.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:git_ums/screens/userscreen.dart';
import 'package:provider/provider.dart';
class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GitProvider>(builder: (context,provider,_){
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
          itemCount: provider.following.length,
          itemBuilder: (context, index) {
            final follower = provider.following[index];
            return ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(follower["avatar_url"],),),
                title: Text(follower["login"],
                style: TextStyle(color: Colors.white),),
                onTap: () {provider.searchUser(follower['login'],
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> UserDetailScreen()));
                  },
            );
          },
        ),
      );
    },
    );
  }
}
