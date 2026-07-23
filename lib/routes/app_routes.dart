import 'package:flutter/cupertino.dart';
import 'package:git_ums/screens/MainScreen.dart';
import 'package:git_ums/screens/Repo_click_screen.dart';
import 'package:git_ums/screens/SignupScreen.dart';
import 'package:git_ums/screens/followerScreen.dart';
import 'package:git_ums/screens/following_screen.dart';
import 'package:git_ums/screens/issueScreen.dart';
import 'package:git_ums/screens/loginScreen.dart';
import 'package:git_ums/screens/repoScreen.dart';
import 'package:git_ums/screens/userscreen.dart';

class AppRoutes {
  static const home = "/";
  static const login = "/login";
  static const main = "/main";
  static const user = "/user";
  static const repo = "/repo";
  static const repoDetail = "/repoDetail";
  static const followers = "/followers";
  static const following = "/following";
  static const issues = "/issues";
  static const signup="/signup";

  static Map<String, WidgetBuilder> routes = {
    home: (context) =>LoginScreen() ,
    login: (context) => LoginScreen(),
    main: (context) => Mainscreen(),
    user: (context) => UserDetailScreen(),
    repo: (context) => RepoScreen(),
    repoDetail: (context) => RepoClickScreen(),
    followers: (context) => FollowersScreen(),
    following: (context) => FollowingScreen(),
    issues: (context) => Issuescreen(),
    signup:(context)=>Signupscreen(),
  };
}