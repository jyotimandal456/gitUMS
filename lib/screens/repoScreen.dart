import 'package:flutter/material.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:git_ums/screens/Repo_click_screen.dart';
import 'package:provider/provider.dart';

class RepoScreen extends StatelessWidget {
  const RepoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GitProvider>(context);

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
      body: ListView.separated(
        padding: EdgeInsets.all(1),
        itemCount: provider.repos.length,
        separatorBuilder: (context, index) {
          return Divider(
            color: Color(0xff30363D),
            thickness: 0.8,
            indent: 16,
            endIndent: 16,
          );
        },
        itemBuilder: (context, index) {
          final repo = provider.repos[index];
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  repo["name"],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                    SizedBox(width: 3),
                    Text("${repo["stargazers_count"]}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 25),
                    Text(repo["language"] ?? "Unknown",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("Public",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () async {
              provider.selectRepo(repo);
              await provider.getRepoList(
                repo["owner"]["login"],
                repo["name"],
              );
              Navigator.push(context, MaterialPageRoute(builder: (_) => RepoClickScreen(),),
              );
            },
          );
        },
      ),
    );
  }
}