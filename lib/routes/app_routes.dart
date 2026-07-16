import 'package:flutter/cupertino.dart';
import 'package:git_ums/screens/MainScreen.dart';
import 'package:git_ums/screens/Repo_click_screen.dart';
import 'package:git_ums/screens/followerScreen.dart';
import 'package:git_ums/screens/following_screen.dart';
import 'package:git_ums/screens/issueScreen.dart';
import 'package:git_ums/screens/repoScreen.dart';
import 'package:git_ums/screens/userscreen.dart';

class AppRoutes {
  static const home="/";
  static const user ="/user";
  static const  repo ="/repo";
  static const repoDetail='/repoDetail';
  static const followers="/followers";
  static const following="/following";
  static const issues="/issues";

  static Map<String,WidgetBuilder>routes={
    home:(context)=> Mainscreen(),
    user:(context)=>UserDetailScreen(),
    repo:(context)=>RepoScreen(),
    repoDetail:(context)=>RepoClickScreen(),
    followers:(context)=>FollowersScreen(),
    following:(context)=>FollowingScreen(),
    issues:(context)=>Issuescreen(),
  };
}