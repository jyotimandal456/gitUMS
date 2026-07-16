import 'package:flutter/material.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:git_ums/screens/issueScreen.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../routes/app_routes.dart';

class RepoClickScreen extends StatelessWidget {
  const RepoClickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GitProvider>(context);
    final repo = provider.selectedRepo;
    Map<String, double> percentage = provider.getRepoPercentage();
    if (repo.isEmpty) {
      return SingleChildScrollView(
        child: Scaffold(body: Center(child: Text("No Repository Selected"))),
      );
    } else {
      return Scaffold(
        backgroundColor: Color(0xff141D2F),
        appBar: AppBar(backgroundColor: Colors.grey, title: Text(repo["name"])),
        body: ListView(
          padding: EdgeInsets.all(13),
          children: [
            Card(
              elevation: 5,
              color: Color(0xff1E2A47),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      repo["name"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      repo["description"] ?? "No Description",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),

                    SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.amber,
                              size: 16,
                            ),
                            SizedBox(height: 5,width: 5,),
                            Text(
                              "${repo["stargazers_count"]}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text("Stars", style: TextStyle(color: Colors.grey,
                            fontSize: 16)),
                          ],
                        ),

                        Row(
                          children: [
                            Icon(Icons.call_split, color: Colors.green),
                            SizedBox(height: 5),
                            Text(
                              "${repo["forks_count"]}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text("Forks", style: TextStyle(color: Colors.grey)),
                          ],
                        ),

                        Row(
                          children: [
                            Icon(Icons.remove_red_eye,
                                color: Colors.lightBlue,
                            size: 16,),
                            SizedBox(height: 5,width: 5,),
                            Text(
                              "${repo["watchers_count"]}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              "Watchers",
                              style: TextStyle(color: Colors.grey,
                              fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.white24, height: 40),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.bug_report, color: Colors.redAccent),
                      title: Text(
                        "Open Issues",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${repo["open_issues_count"]}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                      onTap: () async {
                        await provider.getissue(
                          repo["owner"]["login"],
                          repo["name"],
                        );
                        Navigator.pushNamed(context, AppRoutes.issues);
                      },
                    ),

                    Divider(color: Colors.white24),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.link, color: Colors.blue),
                      title: Text(
                        repo["html_url"],
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                      trailing: Icon(Icons.open_in_new, color: Colors.white),
                      onTap: () {
                        provider.repoWebsite(repo["html_url"]);
                      },
                    ),

                    Divider(color: Colors.white24),

                    SizedBox(height: 10),

                    Text(
                      "Languages",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 15),


                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 10,
                        child: Row(
                          children: percentage.entries.map((entry) {
                            return Expanded(
                              flex: (entry.value * 100).round(),
                              child: Container(
                                color: provider.getLanguageColor(entry.key),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    ...percentage.entries.map((entry) => Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: provider.getLanguageColor(entry.key),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Text(
                              "${(entry.value * 100).toStringAsFixed(1)}%",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
