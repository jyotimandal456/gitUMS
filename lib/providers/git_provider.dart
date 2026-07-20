import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:git_ums/config/dio_client.dart';

class GitProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final Dio dio = DioClient.dio;
  Map<String, dynamic> _user = {};
  Map<String, dynamic> get user => _user;
  String _username = "";
  List<dynamic> _allRepos = [];

  List<dynamic> get allRepos => _allRepos;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  final int perPage = 4;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasNextPage = true;
  bool get hasNextPage => _hasNextPage;

  List<dynamic> _repos = [];
  List<dynamic> get repos => _repos;

  Map<String, dynamic> _selectedRepo = {};
  Map<String, dynamic> get selectedRepo => _selectedRepo;

  List<dynamic> _repoCode = [];
  List<dynamic> get repoCode => _repoCode;

  List<dynamic> _followers = [];
  List<dynamic> get followers => _followers;

  List<dynamic> _following = [];
  List<dynamic> get following => _following;

  List<dynamic> _issue = [];
  List<dynamic> get issue => _issue;

  Map<String, int> _repoLanguages = {};
  Map<String, int> get repoLanguages => _repoLanguages;

  Map<String, int> LanguageCount = {};

  Map<String, double> getLanguage() {
    Map<String, int> languageCount = {};

    for (var repo in allRepos) {
      String? language = repo["language"];

      if (language != null) {
        languageCount[language] = (languageCount[language] ?? 0) + 1;
      }
    }

    int total = languageCount.values.fold(0, (sum, value) => sum + value);

    Map<String, double> percentage = {};

    if (total == 0) {
      return percentage;
    }

    languageCount.forEach((key, value) {
      percentage[key] = value / total;
    });

    return percentage;
  }

  Future<void> getAllRepo(String username) async {
    try {
      Response response = await dio.get(
        "users/$username/repos",
        queryParameters: {"per_page": 100},
      );

      print("GET ALL REPO RESPONSE:");
      print(response.data);
      _allRepos = response.data;
      print("ALL REPOS COUNT: ${_allRepos.length}");

      notifyListeners();
    } on DioException catch (e) {
      print("GET ALL REPO ERROR");
      print(e.response?.data);
    }
  }

  Future<void> getRepoLanguages(String owner, String repoName) async {
    try {
      Response response = await dio.get("repos/$owner/$repoName/languages");
      _repoLanguages = Map<String, int>.from(response.data);
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
      _username = username;
      final prefs = await SharedPreferences.getInstance();
      await saveUsername(username);
      Response response = await dio.get("users/$username");
      _user = response.data;
      _currentPage = 1;

      await getAllRepo(username);
      await getRepo(username);

      notifyListeners();
    } on DioException catch (e) {
      print(e.response?.data);
    }
  }

  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> usernames = prefs.getStringList("searched_users") ?? [];

    if (!usernames.contains(username)) {
      usernames.add(username);
    }
    await prefs.setStringList("searched_users", usernames);
  }

  Future<List<String>> getSavedUsernames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("searched_users") ?? [];
  }

  Future<void> deleteUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> users = prefs.getStringList("usernames") ?? [];

    users.remove(username);

    await prefs.setStringList("usernames", users);

    notifyListeners();
  }

  Future<void> getRepo(String username) async {
    try {
      _isLoading = true;
      notifyListeners();

      Response response = await dio.get(
        "users/$username/repos",
        queryParameters: {"page": _currentPage, "per_page": perPage},
      );

      _repos = response.data;

      _hasNextPage = _repos.length == perPage;
      print("Current Page: $_currentPage");
      print("Repos Loaded: ${_repos.length}");
      if (_repos.isNotEmpty) {
        print("First Repo: ${_repos.first["name"]}");
      }
      _isLoading = false;
      notifyListeners();
    } on DioException catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.response?.data);
    }
  }

  Future<void> nextPage() async {
    if (!_hasNextPage) return;
    _currentPage++;
    await getRepo(_username);
  }

  Future<void> previousPage() async {
    if (_currentPage == 1) return;
    _currentPage--;
    await getRepo(_username);
  }

  Future<void> goToPage(int page) async {
    if (page < 1) return;

    _currentPage = page;

    await getRepo(_username);
  }

  void selectRepo(Map<String, dynamic> repo) {
    _selectedRepo = repo;
    // print(_selectedRepo);
    notifyListeners();
  }

  Future<void> getRepoList(String owner, String repoName) async {
    try {
      Response response = await dio.get("repos/$owner/$repoName/contents");

      _repoCode = response.data;
      print("this is the response to get all repo list");
      print(_repoCode);
      notifyListeners();
    } on DioException catch (e) {
      print(e.response?.data);
    }
  }

  Future<void> getfollowers(String username) async {
    Response response = await dio.get('users/$username/followers');
    _followers = response.data;
    notifyListeners();
  }

  Future<void> getfollowing(String username) async {
    Response response = await dio.get("users/$username/following");
    _following = response.data;
    notifyListeners();
  }

  Future<void> getissue(String owner, String repo) async {
    Response response = await dio.get("repos/$owner/$repo/issues");
    _issue = response.data;
    notifyListeners();
  }

  Future<void> openWebsite(String username) async {
    final Uri url = Uri.parse(_user['html_url']);
    if (await launchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not lunch $url ');
    }
  }

  Future<void> repoWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
