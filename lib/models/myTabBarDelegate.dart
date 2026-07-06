import 'package:flutter/material.dart';
class MyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  MyTabBarDelegate(this.tabBar);
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(MyTabBarDelegate oldDelegate) {
    return false;
  }
}




// ListTile(leading: Icon(Icons.book),
//   title: Text("Repositories: ${provider.user["public_repos"]}",
//   ),
//   onTap: () async {
//     await provider.getRepo(provider.user["login"]);
//     Navigator.push(context, MaterialPageRoute(builder: (_)=>RepoScreen()));
//   },
// ),
// ListTile(
//   leading: Icon(Icons.location_on),
//   title: Text(
//     provider.user["location"] ?? "No Location",
//   ),
// ),
// ListTile(
// leading: Icon(Icons.link),
// title: Text(
// provider.user["html_url"],
// ),
// onTap: () {
// provider.openWebsite(provider.user["html_url"],);