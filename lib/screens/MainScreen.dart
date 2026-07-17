import 'dart:async';

import 'package:flutter/material.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:git_ums/screens/userscreen.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final provider = context.read<GitProvider>();

    final usernames = await provider.getSavedUsernames();

    if (usernames.isNotEmpty) {
      await provider.searchUser(usernames.last);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Consumer<GitProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                centerTitle: true,
                backgroundColor: Colors.indigo,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "GitHub Explorer",
                    style: TextStyle(
                      color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(18),
                    child: TextFormField(
                      controller: provider.controller,
                      decoration: InputDecoration(
                        hintText: "Search GitHub username",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () async {
                            String username = provider.controller.text.trim();

                            if (username.isNotEmpty) {
                              await provider.searchUser(username);
                            }
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              if (provider.user.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.user);
                      },
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Hero(
                                tag: provider.user["login"],
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                    provider.user["avatar_url"],
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      provider.user["login"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      provider.user["name"] ?? "No Name",
                                      style: TextStyle(color: Colors.grey),
                                    ),

                                    SizedBox(height: 10),

                                    Text(
                                      "Tap to view profile",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),

                              // Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Text(
                    "Recent Searches",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: FutureBuilder<List<String>>(
                  future: provider.getSavedUsernames(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            "No recent searches",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }
                    final users = snapshot.data!;
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigo.shade100,
                                child: Icon(
                                  Icons.history,
                                  color: Colors.indigo,
                                ),
                              ),
                              title: Text(users[index]),
                             // trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () async {
                                await provider.searchUser(users[index]);

                                Navigator.pushNamed(context, AppRoutes.user);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
