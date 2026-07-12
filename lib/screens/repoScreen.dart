import 'package:flutter/material.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:git_ums/screens/Repo_click_screen.dart';
import 'package:provider/provider.dart';

class RepoScreen extends StatelessWidget {
  const RepoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GitProvider>(context);
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];
    return Scaffold(
      backgroundColor: Color(0xff141D2F),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Repositories",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
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

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () async {
                            provider.selectRepo(repo);

                            await provider.getRepoList(
                              repo["owner"]["login"],
                              repo["name"],
                            );

                            await provider.getRepoLanguages(
                              repo["owner"]["login"],
                              repo["name"],
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RepoClickScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xff1E2A47),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.book,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        repo["name"],
                                        style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  repo["description"] ??
                                      "No description available",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: provider.getLanguageColor(
                                          repo["language"] ?? "",
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      repo["language"] ?? "",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "${repo["visibility"]}",
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Color(0xff1E2A47),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: provider.currentPage == 1
                      ? null
                      : () async {
                    await provider.previousPage();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: provider.currentPage == 1
                        ? Colors.grey
                        : Colors.white,
                  ),
                ),

                Text(
                  "Page ${provider.currentPage}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                IconButton(
                  onPressed: provider.hasNextPage
                      ? () async {
                    await provider.nextPage();
                  }
                      : null,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: provider.hasNextPage
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
