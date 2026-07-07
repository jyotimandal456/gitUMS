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
        return Colors.blue;
      case "JavaScript":
        return Colors.yellow;
      case "HTML":
        return Colors.orange;
      case "CSS":
        return Colors.purple;
      case "Java":
        return Colors.red;
      case "Python":
        return Colors.green;
      case "PHP":
        return Colors.indigo;
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
      Response response = await dio.get(
        "https://api.github.com/users/$username/repos",
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
}

//language url = https://api.github.com/repos/Nimeshis/backend/languages