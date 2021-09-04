import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

final String _baseURL = "http://20.204.50.144/";
final String users = "9bc65c2abec141778ffaa729489f3e87/";
final String api = "87d2a024b2ae5674f2c091064a0c8cf2/";
final String home = "c9027a676580cc6d5b4594afba86d126/";
final String flashcard = "cd20e024128919bb3ef854f53a4f7e89/";

Future _getCsrf() async {
  try {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));

    await dio.get(_baseURL + users + 'get/');

    var cookies = await cookieJar.loadForRequest(Uri.parse(_baseURL));

    var csrfToken = (cookies[0]);

    return csrfToken.value;
  } catch (e) {
    print(e);
  }
}

Future _getSessionId() async {
  try {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    var cookies = await cookieJar.loadForRequest(Uri.parse(_baseURL));
    var csrfToken = (cookies[0].value);
    if (cookies.length == 2) {
      String ssnID = cookies[1].value;

      return {'sessionid': ssnID, 'csrftoken': csrfToken};
    }
    return {"sessionid": "not_found", 'csrftoken': csrfToken};
  } catch (e) {
    print(e);
  }
}

Future getClassList() async {
  try {
    Dio dio = Dio();

    final response = await dio.get(_baseURL + users + "getclasslist/",
        options: Options(
          headers: {"Referer": "$_baseURL"},
        ));
    final respMap = response.data;
    return respMap["classDList"];
  } on DioError catch (e) {
    // print(e.response!.data);
    // // print(e.response!.headers);
  }
}

Future checkLoggedIn() async {
  Map mappedTokens = (await _getSessionId());
  return mappedTokens;
}

Future createUser(dataMap) async {
  String cToken = await _getCsrf();

  try {
    Dio dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    dio.interceptors.add(CookieManager(cookieJar));

    print(dataMap);

    FormData formData = new FormData.fromMap(dataMap);

    var cookies =
        await cookieJar.loadForRequest(Uri.parse(_baseURL + 'create/'));

    final response = await dio.post(_baseURL + users + "create/",
        data: formData,
        options: Options(
          headers: {
            "Cookie": "csrftoken=$cToken",
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = jsonDecode(response.toString());

    if (cookies.length == 2) {}
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future login(dataMap) async {
  String cToken = await _getCsrf();

  try {
    Dio dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    dio.interceptors.add(CookieManager(cookieJar));

    FormData formData = new FormData.fromMap(dataMap);

    var cookies = await cookieJar.loadForRequest(Uri.parse(_baseURL));

    final response = await dio.post(_baseURL + users + "login/",
        data: formData,
        options: Options(
          headers: {
            "Cookie": "csrftoken=$cToken",
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future logout() async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    Dio dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));
    dio.interceptors.add(CookieManager(cookieJar));

    final response = await dio.post(_baseURL + users + "logout/",
        options: Options(
          headers: {
            "Cookie": cookies,
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future checkInternet() async {
  try {
    BaseOptions options = new BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: 10 * 1000, // 10 seconds
        receiveTimeout: 10 * 1000 // 10 seconds
        );
    var dio = Dio(options);
    await dio.get(_baseURL + users + 'get/');
    return true;
  } on DioError catch (e) {
    if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.other) {
      return false;
    }
  }
}

Future classesQuery() async {
  try {
    Dio dio = Dio();

    final response = await dio.get(_baseURL + users + "getclasslist/",
        options: Options(
          headers: {"Referer": "$_baseURL"},
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future subQuery(className, {hashMode = "false"}) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    FormData formData =
        new FormData.fromMap({'class': className, "hashmode": hashMode});

    Dio dio = Dio();

    final response = await dio.post(_baseURL + users + "getcategory/",
        data: formData,
        options: Options(
          headers: {
            "Cookie": cookies,
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future profileQuery() async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    Dio dio = Dio();

    final response = await dio.get(_baseURL + users + "profileQuery/",
        options: Options(
          headers: {
            "Cookie": cookies,
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future accountDelApi() async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    Dio dio = Dio();

    final response = await dio.get(_baseURL + users + "deleteSAcc/",
        options: Options(
          headers: {
            "Cookie": cookies,
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future profileUpdate(profileData) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    FormData formData = new FormData.fromMap({
      'email': profileData["email"],
      "fullname": profileData["fullName"],
      "standard": profileData["standard"],
    });

    Dio dio = Dio();

    final response = await dio.post(_baseURL + users + "profileupdate/",
        data: formData,
        options: Options(
          headers: {
            "Cookie": cookies,
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future checkHashes() async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    Dio dio = Dio();

    final response = await dio.get(_baseURL + users + "getHashes/",
        options: Options(
          headers: {
            "Cookie": cookies,
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future getQuizSets(subjectSlug) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    Dio dio = Dio();

    final response =
        await dio.get(_baseURL + api + "categoryinfo/" + subjectSlug,
            options: Options(
              headers: {
                "Cookie": cookies,
                "X-CSRFTOKEN": cToken,
                "Referer": "$_baseURL"
              },
            ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future getQuizData(quizSlug) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    Dio dio = Dio();

    final response = await dio.get(_baseURL + api + "quizapi/" + quizSlug,
        options: Options(
          headers: {
            "Cookie": cookies,
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future submitQuiz(quizSlug, totalMarksScored) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    FormData formData = new FormData.fromMap({
      'quizSlug': quizSlug,
      "marks": totalMarksScored,
    });

    Dio dio = Dio();

    final response = await dio.post(_baseURL + users + "savequizattempt/",
        data: formData,
        options: Options(
          headers: {
            "Cookie": cookies,
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future getMarksList(String quizSlug) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    Dio dio = Dio();

    final response = await dio.get(_baseURL + api + "marksinfo/" + quizSlug,
        options: Options(
          headers: {
            "Cookie": cookies,
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

// home api services

Future getBannersList() async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";
    Dio dio = Dio();

    final response = await dio.get(_baseURL + home + "banners/",
        options: Options(
          headers: {
            "Cookie": cookies,
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future getLinkList() async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";
    Dio dio = Dio();

    final response = await dio.get(_baseURL + home + "link/",
        options: Options(
          headers: {
            "Cookie": cookies,
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future getInfoTabList() async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";
    Dio dio = Dio();

    final response = await dio.get(_baseURL + home + "infotab/",
        options: Options(
          headers: {
            "Cookie": cookies,
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

//  flashcard api calls

Future flashsubunits(subslug) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    FormData formData = new FormData.fromMap({
      'cateslug': subslug,
    });

    Dio dio = Dio();

    final response = await dio.post(_baseURL + flashcard + "getflashunit/",
        data: formData,
        options: Options(
          headers: {
            "Cookie": cookies,
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future flashunittopics(id) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    FormData formData = new FormData.fromMap({
      'unitid': id,
    });

    Dio dio = Dio();

    final response = await dio.post(_baseURL + flashcard + "getflashtopic/",
        data: formData,
        options: Options(
          headers: {
            "Cookie": cookies,
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future flashcards(id) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    FormData formData = new FormData.fromMap({
      'topicid': id,
    });
    Dio dio = Dio();

    final response = await dio.post(_baseURL + flashcard + "getflashcard/",
        data: formData,
        options: Options(
          headers: {
            "Cookie": cookies,
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future flashlike(id, mode) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    FormData formData = new FormData.fromMap({'flashid': id, 'mode': mode});
    Dio dio = Dio();

    final response = await dio.post(_baseURL + flashcard + "likeflashfunc/",
        data: formData,
        options: Options(
          headers: {
            "Cookie": cookies,
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future flashpost(data, update) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    FormData formData = new FormData.fromMap(data);
    Dio dio = Dio();

    final endpoint = update ? "updateflashcard/" : "postflashcard/";

    final response = await dio.post(_baseURL + flashcard + endpoint,
        data: formData,
        options: Options(
          headers: {
            "Cookie": cookies,
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}

Future flashdelete(data) async {
  try {
    Map mappedTokens = (await _getSessionId());

    String ssnid = mappedTokens['sessionid'];
    String cToken = mappedTokens['csrftoken'];

    String cookies = "sessionid=$ssnid;csrftoken=$cToken";

    FormData formData = new FormData.fromMap(data);
    Dio dio = Dio();

    final endpoint = "deleteflashcard/";

    final response = await dio.post(_baseURL + flashcard + endpoint,
        data: formData,
        options: Options(
          headers: {
            "Cookie": cookies,
            "Content-Type": "application/x-www-form-urlencoded",
            "X-CSRFTOKEN": cToken,
            "Referer": "$_baseURL"
          },
        ));
    final respMap = response.data;
    return respMap;
  } on DioError catch (e) {
    print(e.response!.data);
    print(e.response!.headers);
  }
}
