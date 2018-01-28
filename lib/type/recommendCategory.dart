import 'package:flutter_demo/type/comicDetail.dart';

class RecommendCategory {
  int category_id = 0;
  String title = "";
  int sort = 0;
  List<Comic> data = [];

  RecommendCategory.fromMap(Map<String, dynamic> map)
      : category_id = map['category_id'],
        title = map['title'],
        sort = map['sort'],
        data = (map['data'] as List<Map>).map((d) {
          return new Comic.fromMap(d);
        }).toList();

}

