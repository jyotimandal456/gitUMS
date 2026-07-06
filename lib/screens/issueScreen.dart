import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/git_provider.dart';

class Issuescreen extends StatelessWidget {
  const Issuescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GitProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title:  Text("Open Issues"),
          ),
          body: ListView.builder(
            itemCount: provider.issue.length,
            itemBuilder: (context, index) {
              final issue = provider.issue[index];
              return  ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      issue["user"]["avatar_url"],
                    ),
                  ),
                  title: Text(issue["title"] ?? "No Title"),
                  subtitle: Text("By ${issue["user"]["login"]}\n"
                      "State: ${issue["state"]}",
                  ),
                  isThreeLine: true,
              );
              },
          ),
        );
      },
    );
  }
}