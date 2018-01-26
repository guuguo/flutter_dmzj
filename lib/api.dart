import 'dart:async';
import 'dart:convert';

import 'dart:io';

typedef void ErrorCallBack(String error);

const _version = "2.7.003";
const _channel = "Android";
var imageHeader=  {"Referer": "http://www.dmzj.com/"};

class Api {
 static Future<List> searchComic(String value, page, ErrorCallBack callback) async {
    var url =
        'http://v2.api.dmzj.com/search/show/0/$value/$page.json?channel=$_channel&version=$_version';
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        List data = JSON.decode(json);
        return data;
      } else {
        callback('搜索失败:\nHttp status ${response.statusCode}');
      }
    } catch (exception) {
      callback('搜索失败');
    }

    return null;
  }

 static Future<List> getRecommend(ErrorCallBack callback) async {
    var url =
        'http://v2.api.dmzj.com/v3/recommend.json?channel=$_channel&version=$_version';
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        List data = JSON.decode(json);
        return data;
      } else {
        callback('获取失败:\nHttp status ${response.statusCode}');
      }
    } catch (exception) {
      callback('获取失败');
    }

    return null;
  }

 static Future<Map> getComicDetail(int comicID,ErrorCallBack callback) async {
   var url =
       'http://v2.api.dmzj.com/comic/$comicID.json?channel=$_channel&version=$_version';
   var httpClient = new HttpClient();
   try {
     var request = await httpClient.getUrl(Uri.parse(url));
     var response = await request.close();
     if (response.statusCode == HttpStatus.OK) {
       var json = await response.transform(UTF8.decoder).join();
       Map data = JSON.decode(json);
       return data;
     } else {
       callback('获取失败:\nHttp status ${response.statusCode}');
     }
   } catch (exception) {
     callback('获取失败');
   }

   return null;
 }

 static Future<Map> getComicContent(int comicID,int chapterID,ErrorCallBack callback) async {
   var url =
       'http://v2.api.dmzj.com/chapter/$comicID/$chapterID.json?channel=$_channel&version=$_version';
   var httpClient = new HttpClient();
   try {
     var request = await httpClient.getUrl(Uri.parse(url));
     var response = await request.close();
     if (response.statusCode == HttpStatus.OK) {
       var json = await response.transform(UTF8.decoder).join();
       Map data = JSON.decode(json);
       return data;
     } else {
       callback('获取失败:\nHttp status ${response.statusCode}');
     }
   } catch (exception) {
     callback('获取失败');
   }

   return null;
 }
}
