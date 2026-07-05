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
      backgroundColor: Color(0xff1E2A47),
      appBar: AppBar(
        backgroundColor: Color(0xFFEEEEEE),
        title: Text("Repositories"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: provider.repos.length,
        itemBuilder: (context, index) {
          final repo = provider.repos[index];
          return Card(
            color: Colors.grey  ,
            child: ListTile(
              leading:  Icon(Icons.folder),
              title: Text(repo["name"]),
              onTap: () async {
                provider.selectRepo(repo);
                await provider.getRepoCode(
                  repo["owner"]["login"],
                  repo["name"],
                );

                Navigator.push(context, MaterialPageRoute(builder: (_) =>  RepoClickScreen(),
                  ),
                );
              },
              subtitle: Text(repo["description"] ?? "No Description",
              ),
            ),
          );
        },
      ),
    );
  }
}