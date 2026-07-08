import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class GitProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final Dio dio = Dio();
  final String? accessToken = dotenv.env['GITHUB_TOKEN'];
  Map<String, dynamic> _user = {};
  Map<String, dynamic> get user => _user;

  List<dynamic> _repos = [];
  List<dynamic> get repos => _repos;

  Map<String, dynamic> _selectedRepo = {};
  Map<String, dynamic> get selectedRepo => _selectedRepo;

  List<dynamic> _repoCode = [];
  List<dynamic> get repoCode => _repoCode;

  List<dynamic>_followers =[];
  List<dynamic> get followers => _followers;
  
  List <dynamic>_following=[];
  List <dynamic> get following=> _following;

  List <dynamic> _issue=[];
  List <dynamic> get issue => _issue;

  Map<String, int> _repoLanguages = {};
  Map<String, int> get repoLanguages => _repoLanguages;

  Map <String ,int> LanguageCount={};

  Map<String, double> getLanguage() {
    Map<String, int> languageCount = {};
    for (var repo in repos) {
      String language = repo["language"] ?? "Unknown";
      languageCount[language] = (languageCount[language] ?? 0) + 1;
    }

    int total = repos.length;

    Map<String, double> percentage = {};

    languageCount.forEach((key, value) {
      percentage[key] = value / total;
    });
    return percentage;
  }

  Future<void> getRepoLanguages(String owner, String repoName,) async {
    try {
      Response response = await dio.get(
        "https://api.github.com/repos/$owner/$repoName/languages",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/vnd.github+json",
          },
        ),
      );
      _repoLanguages= Map<String, int>.from(response.data);
      notifyListeners();
    } on DioException catch (e) {
      print(e.response?.data);
    }
  }

  Map<String, double> getRepoPercentage() {
    int total = repoLanguages.values.fold(0, (sum, value) => sum + value);

    Map<String, double> percentage = {};

    repoLanguages.forEach((key, value) {
      percentage[key] = value / total;
    });

    return percentage;
  }
  Color getLanguageColor(String language) {
    switch (language) {
      case "Dart":
        return Color(0xff00B4AB);

      case "Java":
        return Color(0xffB07219);

      case "JavaScript":
        return Color(0xffF1E05A);

      case "TypeScript":
        return Color(0xff3178C6);

      case "Python":
        return Color(0xff3572A5);

      case "C":
        return Color(0xff555555);

      case "C++":
        return Color(0xffF34B7D);

      case "C#":
        return Color(0xff178600);

      case "Go":
        return Color(0xff00ADD8);

      case "Kotlin":
        return Color(0xffA97BFF);

      case "Swift":
        return Color(0xffFA7343);

      case "Rust":
        return Color(0xffDEA584);

      case "Ruby":
        return Color(0xffCC342D);

      case "PHP":
        return Color(0xff4F5D95);

      case "HTML":
        return Color(0xffE34C26);

      case "CSS":
        return Color(0xff563D7C);

      case "SCSS":
        return Color(0xffC6538C);

      case "Shell":
        return Color(0xff89E051);

      case "PowerShell":
        return Color(0xff012456);

      case "Objective-C":
        return Color(0xff438EFF);

      case "R":
        return Color(0xff198CE7);

      case "Lua":
        return Color(0xff000080);

      case "Perl":
        return Color(0xff0298C3);

      case "Haskell":
        return Color(0xff5E5086);

      case "Scala":
        return Color(0xffDC322F);

      case "Elixir":
        return Color(0xff6E4A7E);

      case "Clojure":
        return Color(0xffDB5855);

      case "Vue":
        return Color(0xff41B883);

      case "Svelte":
        return Color(0xffFF3E00);

      case "Assembly":
        return Color(0xff6E4C13);

      case "Jupyter Notebook":
        return Color(0xffDA5B0B);

      case "Dockerfile":
        return Color(0xff384D54);

      case "SQL":
        return Color(0xff336791);

      case "Markdown":
        return Color(0xff083FA1);

      case "YAML":
        return Color(0xffCB171E);

      case "JSON":
        return Color(0xff292929);

      default:
        return Colors.grey;
    }
  }

  Future<void> searchUser(String username) async {
    try {
      Response response = await dio.get("https://api.github.com/users/$username",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/vnd.github+json",
          },
        ),
      );
      _user = response.data;
      await getRepo(username);
     // print("user list");
     // print(_user);
      notifyListeners();
    } on DioException catch (e) {
      print(e.response?.data);
    }
  }
  Future<void> getRepo(String username) async {
    try {
      print("Fetching repos for: $username");
      Response response = await dio.get("https://api.github.com/users/$username/repos",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/vnd.github+json",
          },
        ),
      );

      _repos = response.data;

      print("Repos loaded: ${_repos.length}");

      notifyListeners();
    } on DioException catch (e) {
      print("Repo Error: ${e.response?.data}");
    }
  }
  void selectRepo(Map<String, dynamic> repo) {
    _selectedRepo = repo;
   // print(_selectedRepo);
    notifyListeners();
  }
  Future<void> getRepoList(String owner,
      String repoName) async {
    try {
      Response response = await dio.get("https://api.github.com/repos/$owner/$repoName/contents",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/vnd.github+json",
          },
        ),
      );

      _repoCode = response.data;
      print("this is the response to get all repo list");
      print(_repoCode);
      notifyListeners();
    } on DioException catch (e) {
      print(e.response?.data);
    }
  }
  Future<void> getfollowers(String username) async {
    Response response=await dio.get('https://api.github.com/users/$username/followers',
    options:  Options(
      headers: {
        "Authorization":"Bearer $accessToken",
        "Accept": "application/vnd.github+json",
      }
    )
    );
    _followers=response.data;
    notifyListeners();
  }
  
  Future<void> getfollowing (String username) async{
    Response response =await dio.get("https://api.github.com/users/$username/following",
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/vnd.github+json",
        }
      )
    );
    _following=response.data;
    notifyListeners();
  }
  
  Future<void>getissue(String owner, String repo)async{
    Response response =await dio.get("https://api.github.com/repos/$owner/$repo/issues",
    options: Options(
      headers: {
        "Authorization": "Bearer $accessToken",
        "accept": "application/vnd.github+json"
      }
    )
    );
    _issue=response.data;
    notifyListeners();
  }
  Future <void> openWebsite( String username) async {
    final Uri url= Uri.parse(_user['html_url']);
    if (await launchUrl(url)) {
      await launchUrl(url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw Exception('Could not lunch $url ');
    }
  }

  Future<void> repoWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}


//language url = https://api.github.com/repos/Nimeshis/backend/languages