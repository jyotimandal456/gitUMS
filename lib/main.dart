import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:git_ums/providers/authProvider.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:git_ums/routes/app_routes.dart';
import 'package:git_ums/screens/MainScreen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANONY_KEY']!,
  );
  runApp(
    MultiProvider(
        providers:[
          ChangeNotifierProvider(create: (_)=>GitProvider()),
          ChangeNotifierProvider(create: (_)=> AuthProvider()),
        ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Git UMS',
      theme: ThemeData(),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}