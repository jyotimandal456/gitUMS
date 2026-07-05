import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GitProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();

  final Dio dio = Dio();
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

  final String? accessToken = dotenv.env['GITHUB_TOKEN'];

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
      notifyListeners();
    } on DioException catch (e) {
      print(e.response?.data);
    }
  }

  Future<void> getRepo(String username) async {
    try {
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
      notifyListeners();
    } on DioException catch (e) {
     // print(e.response?.data);
    }
  }
  void selectRepo(Map<String, dynamic> repo) {
    _selectedRepo = repo;
    notifyListeners();
  }

  Future<void> getRepoCode(String owner,
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
}