import 'dart:async';

import 'package:flutter/material.dart';
import 'package:git_ums/providers/authProvider.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:git_ums/screens/userscreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

    await provider.getSavedUsernames();

    if (provider.savedUsers.isNotEmpty) {
      await provider.searchUser(provider.savedUsers.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Consumer<GitProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  IconButton(
                    icon: Icon(Icons.logout,color: Colors.blue,),
                    onPressed: () async {
                      final auth = context.read<AuthProvider>();

                      await auth.logout();

                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    },
                  ),
                ],
                expandedHeight: 180,
                pinned: true,
                centerTitle: true,
                backgroundColor: Colors.indigo,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "GitHub Explorer",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.black],
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
                              await provider.saveUsername(username);
                              await provider.getSavedUsernames();
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.user);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withOpacity(0.2),
                              Colors.black,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Hero(
                              tag: provider.user["login"],
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 34,
                                  backgroundImage: NetworkImage(
                                    provider.user["avatar_url"],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.user["name"] ??
                                        provider.user["login"] ??
                                        "",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Text(
                                    "@${provider.user["login"]}",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Recent Searches",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(width: 80),
                      Text("Clear all", style: TextStyle(fontSize: 14)),
                      IconButton(
                        onPressed: () async {
                          await provider.clearhistory();
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red.withOpacity(0.25),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: provider.savedUsers.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            "No recent searches",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: provider.savedUsers.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final user = provider.savedUsers[index];

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Slidable(
                              key: ValueKey(user),
                              endActionPane: ActionPane(
                                motion: DrawerMotion(),
                                extentRatio: 0.25,
                                children: [
                                  SlidableAction(
                                    onPressed: (_) async {
                                      await provider.deleteUsername(user);
                                    },
                                    icon: Icons.delete,
                                    label: "Delete",
                                    foregroundColor: Colors.red,
                                  ),
                                ],
                              ),
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
                                  title: Text(user),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                  ),
                                  onTap: () async {
                                    await provider.searchUser(user);
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.user,
                                    );
                                  },
                                ),
                              ),
                            ),
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
