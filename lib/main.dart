import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:git_ums/providers/git_provider.dart';
import 'package:git_ums/routes/app_routes.dart';
import 'package:git_ums/screens/MainScreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (_) => GitProvider(),
      child:  MyApp(),
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