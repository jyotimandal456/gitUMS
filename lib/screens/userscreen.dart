import 'package:flutter/material.dart';
import 'package:git_ums/screens/followerScreen.dart';
import 'package:git_ums/screens/following_screen.dart';
import 'package:git_ums/screens/repoScreen.dart';
import 'package:provider/provider.dart';

import '../providers/git_provider.dart';
class UserDetailScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<GitProvider>(builder: (context,provider,_){
      return Scaffold(
        appBar: AppBar(
          title: Text(provider.user["login"]),
        ),
        body: Padding(
          padding:  EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                  NetworkImage(provider.user["avatar_url"]),
                ),
                SizedBox(height: 20),
                Text(provider.user["name"] ?? "No Name",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text("@${provider.user["login"]}"),
                SizedBox(height: 20),
                ListTile(
                  leading:  Icon(Icons.people),
                  title: Text("Followers: ${provider.user["followers"]}"),
                  onTap: () async {
                    await provider.getfollowers(provider.user['login']);
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> FollowersScreen()));

                  },
                ),
                ListTile(
                  leading:  Icon(Icons.person_add),
                  title: Text("Following: ${provider.user["following"]}"),
                  onTap: () async{
                    await provider.getfollowing(provider.user['login']);
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> FollowingScreen()));
                  },
                ),
                ListTile(
                  leading:  Icon(Icons.book),
                  title: Text("Repositories: ${provider.user["public_repos"]}"),
                  onTap: () async {
                    await provider. getRepo(provider.user["login"]);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => RepoScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(provider.user["location"] ?? "No Location"),
                ),
                ListTile(
                  leading: Icon(Icons.link),
                  title: Text(provider.user["html_url"]),
                ),
              ],
            ),
          ),
        ),
      );},
    );
  }
}