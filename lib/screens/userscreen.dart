import 'package:flutter/material.dart';
import 'package:git_ums/screens/Repo_click_screen.dart';
import 'package:git_ums/screens/followerScreen.dart';
import 'package:git_ums/screens/following_screen.dart';
import 'package:git_ums/screens/repoScreen.dart';
import 'package:provider/provider.dart';
import '../providers/git_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];
    return Consumer<GitProvider>(
      builder: (context, provider, _) {
        print(provider.getLanguage().entries.length);
        print("Repo Length: ${provider.repos.length}");
        print("Languages: ${provider.getLanguage()}");
        if (provider.user.isEmpty) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Color(0xff0D1117),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Color(0xff0D1117),
                  expandedHeight: 160,
                  pinned: true,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(
                                  provider.user["avatar_url"],
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Text(provider.user["login"],
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xff8B949E),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        // SizedBox(height: 10),
                        // Text("@${provider.user["login"]}",
                        //   style: TextStyle(
                        //     color: Color(0xff8B949E),
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.people_alt_outlined,
                            color: Colors.white,
                            size: 17,),
                            SizedBox(width: 6,),
                            InkWell(
                              onTap: () async {
                                await provider.getfollowers(provider.user["login"]);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => FollowersScreen(),));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "${provider.user["followers"]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    " followers",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                await provider.getfollowing(provider.user["login"]);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => FollowingScreen(),));
                              },
                              child: Row(
                                children: [
                                  Text("${provider.user["following"]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(" followings",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),

                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        ListTile(leading: Icon(Icons.book,
                        color:Colors.white,),
                          title: Text("Repositories: ${provider.user["public_repos"]}",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () async {
                            await provider.getRepo(provider.user["login"]);
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>RepoScreen()));
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.location_on,
                            color: Colors.white,
                          ),
                          title: Text(
                            provider.user["location"] ?? "No Location",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.link,color: Colors.white,),
                          title: Text(
                            provider.user["html_url"],
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            provider.openWebsite(provider.user["html_url"],);
                          },
                        ),
                        Divider(),
                        Padding(
                            padding:EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Languages",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 30,),
                              // SizedBox(
                              //   height: 250,
                              //   width: 250,
                              //   child: PieChart(
                              //     PieChartData(
                              //       sections: [
                              //         PieChartSectionData(
                              //           value: 40,
                              //           color: Colors.blue,
                              //           title: "40%",
                              //         ),
                              //         PieChartSectionData(
                              //           value: 30,
                              //           color: Colors.green,
                              //           title: "30%",
                              //         ),
                              //         PieChartSectionData(
                              //           value: 30,
                              //           color: Colors.orange,
                              //           title: "30%",
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // )

                              Row(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 180,
                                    width: 180,
                                    child: PieChart(
                                      PieChartData(
                                        centerSpaceRadius: 40,
                                        sectionsSpace: 2,
                                        borderData: FlBorderData(show: false),
                                        sections: provider.getLanguage().entries.toList().asMap().entries.map((item) {
                                          int index = item.key;
                                          var entry = item.value;
                                          return PieChartSectionData(
                                            value: entry.value * 100,
                                            title: "",
                                            color: colors[index % colors.length],
                                            radius: 40,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: provider.getLanguage().entries.toList().asMap().entries.map((item) {
                                        int index = item.key;
                                        var entry = item.value;
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  color: colors[index % colors.length],
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  entry.key,
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              Text("${(entry.value * 100).toStringAsFixed(0)}%",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
       );
      },
    );
  }
  }


















