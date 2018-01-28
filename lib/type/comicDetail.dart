class Comic {
  var cover = "";
  var sub_title = "";
  var type = 0;
  var url = "";
  var title = "";
  var status = "";
  var obj_id = 40552;

  @override
  String toString() => 'Comic($title)';

  Comic.fromMap(Map<String, dynamic> map)
      : obj_id = map['obj_id'],
        status = map['status'],
        title = map['title'],
        url = map['url'],
        cover = map['cover'],
        sub_title = map['sub_title'],
        type = map['type'];

}

class ComicDetail {
  var id = 0;
  var status = "";
  var title = "";
  var last_name = "";
  var cover = "";
  var authors = "";
  String types ;
  int hot_hits;

  var description;
  int last_updatetime;
  int copyright = 0;
  String first_letter;
  int hot_num = 0;
  int hit_num = 0;

  @override
  String toString() => 'ComicDetail($title)';

  ComicDetail.fromComic(Comic comic)
      :id=comic.obj_id,
        status=comic.status,
        title=comic.title,
        cover=comic.cover;

  ComicDetail.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        status = map['status'],
        title = map['title'],
        last_name = map['last_name'],
        cover = map['cover'],
        authors = map['authors'],
        types = map['types'],
        hot_hits = map['hot_hits'];

  ComicDetail.fromDetailMap(Map<String, dynamic> map)
      : id = map['id'],
        status = map['status'],
        title = map['title'],
        cover = map['cover'],
        authors = (map['authors'] as List<String>).join('/'),
        types = (map['types'] as List<String>).join('/'),

        description = map['description'],
        last_updatetime = map['last_updatetime'],
        hot_num = map['hot_num'],
        hit_num = map['hit_num'];


}
