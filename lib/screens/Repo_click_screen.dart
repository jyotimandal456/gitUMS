import 'package:flutter/material.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:git_ums/screens/issueScreen.dart';
import 'package:provider/provider.dart';

class RepoClickScreen extends StatelessWidget {
  const RepoClickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GitProvider>(context);
    final repo = provider.selectedRepo;
    Map<String, double> percentage =
    provider.getRepoPercentage();
      if (repo.isEmpty) {
       return Scaffold(
       body: Center(
       child: Text("No Repository Selected"),
       ),
      );
       } else {
  return Scaffold(
    backgroundColor: Color(0xff141D2F),
    appBar: AppBar(
      backgroundColor: Colors.grey,
      title: Text(repo["name"]),
    ),
    body: Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        color: Color(0xff1E2A47),
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
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Stars",
                        style: TextStyle(color: Colors.white70),),
                      Text("${repo["stargazers_count"]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [Text("Forks",
                      style: TextStyle(color: Colors.white70),
                    ),
                      Text("${repo["forks_count"]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Watchers",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "${repo["watchers_count"]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20),

              // ListTile(
              //   leading: Icon(Icons.code, color: Colors.white),
              //   title: Text(repo["language"] ?? "Unknown",
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),

              ListTile(
                leading: Icon(Icons.bug_report, color: Colors.white),
                title: Text("Open Issues: ${repo["open_issues_count"]}",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  provider.getissue(repo['owner']['login'],repo['name']);
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> Issuescreen()));
                },
              ),

              ListTile(
                leading: Icon(Icons.link, color: Colors.white),
                title: Text(repo["html_url"],
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(height: 20),

              Text(
                "Languages",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  height: 8,
                  width: double.infinity,
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

              SizedBox(height: 15),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: percentage.entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
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
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        Text("${(entry.value * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            ],
          ),
        ),
      ),
    ),
  );
}}
}