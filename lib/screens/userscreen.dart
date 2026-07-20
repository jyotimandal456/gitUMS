import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/git_provider.dart';
import '../routes/app_routes.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> chartColors = [
      const Color(0xFF6366F1),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4),
    ];

    return Consumer<GitProvider>(
      builder: (context, provider, _) {
        if (provider.user.isEmpty) {
          return  Scaffold(
            backgroundColor: Color(0xFF0F172A),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
            ),
          );
        }

        final user = provider.user;
        final languages = provider.getLanguage().entries.toList();

        return Scaffold(
          backgroundColor: Color(0xFF0F172A),
          body: Container(
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E1E38),
                  Color(0xFF0F172A),
                  Color(0xFF020617),
                ],
              ),
            ),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.black,
                  elevation: 0,
                  floating: true,
                  pinned: true,
                  leading:  BackButton(color: Colors.white70),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.share_outlined, color: Colors.white70),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.white70),
                      onPressed: () {},
                    ),
                    SizedBox(width: 8),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color:  Color(0xFF38BDF8), width: 0.5),
                                boxShadow: [
                                  BoxShadow(
                                    color:Color(0xFF38BDF8).withOpacity(0.2),
                                  )
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 42,
                                backgroundColor:  Color(0xFF1E293B),
                                backgroundImage: NetworkImage(user['avatar_url'] ?? ""),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['name'] ?? "No Name",
                                    style:  TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                 SizedBox(height: 4),
                                  Text(
                                    "@${user['login']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: 20),
                        Row(
                          children: [
                            _buildStatItem(
                              context,
                              icon: Icons.people_outline_rounded,
                              count: "${user["followers"]}",
                              label: "followers",
                              onTap: () async {
                                await provider.getfollowers(user["login"]);
                                Navigator.pushNamed(context, AppRoutes.followers);
                              },
                            ),
                            SizedBox(width: 16),
                            _buildStatItem(
                              context,
                              icon: Icons.person_add_alt_1_outlined,
                              count: "${user["following"]}",
                              label: "following",
                              onTap: () async {
                                await provider.getfollowing(user["login"]);
                                Navigator.pushNamed(context, AppRoutes.following);
                              },
                            ),
                          ],
                        ),
                         SizedBox(height: 10),
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 2.3,
                          children: [
                            _buildInfoCard(
                              icon: Icons.book_outlined,
                              iconColor: Color(0xFF38BDF8),
                              title: "Repositories",
                              subtitle: "${user["public_repos"]}",
                              onTap: () async {
                                await provider.getRepo(user["login"]);
                                Navigator.pushNamed(context, AppRoutes.repo);
                              },
                            ),
                            _buildInfoCard(
                              icon: Icons.location_on_outlined,
                              iconColor:  Color(0xFFF87171),
                              title: "Location",
                              subtitle: user["location"] ?? "Remote",
                            ),
                            _buildInfoCard(
                              icon: Icons.apartment_rounded,
                              iconColor:  Color(0xFFFBBF24),
                              title: "Organization",
                              subtitle: user["company"] ?? "None",
                            ),
                            _buildInfoCard(
                              icon: Icons.link_rounded,
                              iconColor: Color(0xFF34D399),
                              title: "GitHub Link",
                              subtitle: "Open Bio",
                              onTap: () => provider.openWebsite(user["html_url"]),
                            ),
                          ],
                        ),
                         SizedBox(height: 28),
                        if (languages.isNotEmpty) ...[
                          Container(
                            padding:  EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.20),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.blue.withOpacity(0.5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding:  EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF38BDF8).withOpacity(0.30),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.pie_chart_outline_rounded, color: Color(0xFF38BDF8)),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Languages Used",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Center(
                                  child: SizedBox(
                                    height: 180,
                                    width: 180,
                                    child: PieChart(
                                      PieChartData(
                                        centerSpaceRadius: 50,
                                        sectionsSpace: 3,
                                        borderData: FlBorderData(show: false),
                                        sections: languages.asMap().entries.map((item) {
                                          int index = item.key;
                                          var entry = item.value;
                                          return PieChartSectionData(
                                            value: entry.value * 100,
                                            title: "${(entry.value * 100).toStringAsFixed(1)}%",
                                            titleStyle:  TextStyle(
                                              color: Colors.white.withOpacity(0.5),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                            radius: 35,
                                            color: chartColors[index % chartColors.length],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: languages.length,
                                  separatorBuilder: (context,indrx) {
                                    return SizedBox(height: 10);
                                    } ,
                                  itemBuilder: (context, index) {
                                    final entry = languages[index];
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.white.withOpacity(0.25)),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: chartColors[index % chartColors.length],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 14),
                                          Expanded(
                                            child: Text(
                                              entry.key,
                                              style:  TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${(entry.value * 100).toStringAsFixed(1)}%",
                                            style:  TextStyle(
                                              color: Color(0xFF38BDF8),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                           SizedBox(height: 24),
                        ],
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
  Widget _buildStatItem(BuildContext context, {
    required IconData icon,
    required String count,
    required String label,
    VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:  Colors.blue.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey.shade400, size: 18),
             SizedBox(width: 8),
            Text(
              count,
              style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
            ),
            Text(
              " $label",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:  Colors.blue.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.blue.withOpacity(0.32)),
        ),
        child: Row(
          children: [
            Container(
              padding:  EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.w400),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                   SizedBox(height: 2),
                  Text(
                    subtitle,
                    style:  TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}