import 'dart:async';

import 'package:flutter/material.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:git_ums/screens/userscreen.dart';
import 'package:provider/provider.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GitProvider>(builder: (context,provider,_){
        return CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverAppBar(
              leading: Icon(Icons.more_horiz),
              title: Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              expandedHeight: 100,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.yellow.shade100,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:  EdgeInsets.all(10),
                child: TextFormField(
                  controller: provider.controller,
                  decoration: InputDecoration(
                    hintText: 'Search by name',
                    suffixIcon: IconButton(
                      onPressed: () {
                        provider.searchUser(provider.controller.text.trim());
                      },
                      icon: Icon(Icons.search_rounded),
                    ),
                    filled: true,
                    fillColor: Colors.blueGrey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: provider.user.isEmpty
                  ?  SizedBox()
                  : InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen()));
                },
                child: Card(
                  margin:  EdgeInsets.all(16),
                  child: ListTile(
                    leading: CircleAvatar(backgroundImage:
                      NetworkImage(provider.user["avatar_url"]),
                    ),
                    title: Text(provider.user["login"]),
                    subtitle: Text(provider.user["name"] ?? "No Name"),
                  ),
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: Container(
            //     height: 300,
            //     width: 300,
            //     child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: 10,
            //       itemBuilder: (context, index) {
            //         return Container(
            //           width: 300,
            //           margin:  EdgeInsets.all(8),
            //           decoration: BoxDecoration(
            //             color: Colors.blueGrey.shade100,
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           child: Center(
            //             child: Text(
            //               "Item ${index + 1}",
            //               style:  TextStyle(color: Colors.white),
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
          ],

        );
      },

      ),
    );
  }
}