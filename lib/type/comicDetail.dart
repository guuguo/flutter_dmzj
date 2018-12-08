import 'dart:async';
import 'dart:convert';

import 'package:dmzj_demo/utils/db.dart';
import 'package:sqflite/src/sql_builder.dart';


class ComicDetail {

  Object uid;
  int copyright;
  int direction;
  int hit_num;
  int hot_num;
  int id;
  int is_dmzj;
  int islong;
  int last_updatetime;
  int subscribe_num;
  String cover;
  String description;
  String first_letter;
  String title;
  List<TagBean> authors;
  List<ChapterSectionBean> chapters;
  List<TagBean> status;
  List<TagBean> types;
  CommentResult comment;

  ComicDetail.noThing();

  ComicDetail(Map jsonRes) {
    uid = jsonRes['uid'];
    copyright = jsonRes['copyright'];
    direction = jsonRes['direction'];
    hit_num = jsonRes['hit_num'];
    hot_num = jsonRes['hot_num'];
    id = jsonRes['id'];
    is_dmzj = jsonRes['is_dmzj'];
    islong = jsonRes['islong'];
    last_updatetime = jsonRes['last_updatetime'];
    subscribe_num = jsonRes['subscribe_num'];
    cover = jsonRes['cover'];
    description = jsonRes['description'];
    first_letter = jsonRes['first_letter'];
    title = jsonRes['title'];
    authors = [];

    for (var authorsItem in jsonRes['authors']) {
      authors.add(new TagBean(authorsItem));
    }

    chapters = [];

    for (var chaptersItem in jsonRes['chapters']) {
      chapters.add(new ChapterSectionBean(chaptersItem));
    }

    status = [];

    for (var statusItem in jsonRes['status']) {
      status.add(new TagBean(statusItem));
    }

    types = [];

    for (var typesItem in jsonRes['types']) {
      types.add(new TagBean(typesItem));
    }

    comment = new CommentResult(jsonRes['comment']);
  }

  @override
  String toString() {
    return '{"uid": $uid,"copyright": $copyright,"direction": $direction,"hit_num": $hit_num,"hot_num": $hot_num,"id": $id,"is_dmzj": $is_dmzj,"islong": $islong,"last_updatetime": $last_updatetime,"subscribe_num": $subscribe_num,"cover": ${cover !=
        null ? '${jsonEncode(cover)}' : 'null'},"description": ${description !=
        null
        ? '${jsonEncode(description)}'
        : 'null'},"first_letter": ${first_letter != null ? '${jsonEncode(
        first_letter)}' : 'null'},"title": ${title != null
        ? '${jsonEncode(title)}'
        : 'null'},"authors": $authors,"chapters": $chapters,"status": $status,"types": $types,"comment": $comment}';
  }
}


class CommentResult {

  int comment_count;
  List<CommentBean> latest_comment;


  CommentResult(jsonRes) {
    comment_count = jsonRes['comment_count'];
    latest_comment = [];

    for (var latest_commentItem in jsonRes['latest_comment']) {
      latest_comment.add(new CommentBean(latest_commentItem));
    }
  }

  @override
  String toString() {
    return '{"comment_count": $comment_count,"latest_comment": $latest_comment}';
  }
}


class CommentBean {

  int comment_id;
  int createtime;
  int uid;
  String avatar;
  String content;
  String nickname;


  CommentBean(jsonRes) {
    comment_id = jsonRes['comment_id'];
    createtime = jsonRes['createtime'];
    uid = jsonRes['uid'];
    avatar = jsonRes['avatar'];
    content = jsonRes['content'];
    nickname = jsonRes['nickname'];
  }

  @override
  String toString() {
    return '{"comment_id": $comment_id,"createtime": $createtime,"uid": $uid,"avatar": ${avatar !=
        null ? '${jsonEncode(avatar)}' : 'null'},"content": ${content != null
        ? '${jsonEncode(content)}'
        : 'null'},"nickname": ${nickname != null
        ? '${jsonEncode(nickname)}'
        : 'null'}}';
  }
}


class TagBean {

  int tag_id;
  String tag_name;


  TagBean(jsonRes) {
    tag_id = jsonRes['tag_id'];
    tag_name = jsonRes['tag_name'];
  }

  @override
  String toString() {
    return '{"tag_id": $tag_id,"tag_name": ${tag_name != null ? '${jsonEncode(
        tag_name)}' : 'null'}}';
  }
}


class ChapterSectionBean {

  String title;
  List<ChapterBean> data;


  ChapterSectionBean(jsonRes) {
    title = jsonRes['title'];
    data = [];

    for (var dataItem in jsonRes['data']) {
      data.add(new ChapterBean(dataItem));
    }
  }

  @override
  String toString() {
    return '{"title": ${title != null
        ? '${jsonEncode(title)}'
        : 'null'},"data": $data}';
  }
}


class ChapterBean {

  int chapter_id;
  int chapter_order;
  int filesize;
  int updatetime;
  String chapter_title;


  ChapterBean(jsonRes) {
    chapter_id = jsonRes['chapter_id'];
    chapter_order = jsonRes['chapter_order'];
    filesize = jsonRes['filesize'];
    updatetime = jsonRes['updatetime'];
    chapter_title = jsonRes['chapter_title'];
  }

  @override
  String toString() {
    return '{"chapter_id": $chapter_id,"chapter_order": $chapter_order,"filesize": $filesize,"updatetime": $updatetime,"chapter_title": ${chapter_title !=
        null ? '${jsonEncode(chapter_title)}' : 'null'}}';
  }
}

class ComicStore {
  int id;
  String cover;
  String title;
  String authors;
  String types = "";
  int lastReadTime = 0;
  int isFavorite = 0;
  String tag="";

  static const createSQL = '''
create table comicStore (
  id integer primary key,
  title text not null,
  authors text not null,
  cover text not null,
  isFavorite integer not null,
  lastReadTime integer not null,
  types text)
''';

  ComicStore.fromComicDetail(ComicDetail detail){
    id = detail.id;
    cover = detail.cover;
    title = detail.title;
    authors = detail.authors
        .map((it) => it.tag_name)
        .join('/')
        .toString();
    types = detail.types
        .map((tag) => tag.tag_name)
        .join(' ');
  }

  ComicStore.fromMap(Map detail){
    fromMapData(detail);
  }

  fromMapData(Map detail) {
    id = detail['id'];
    cover = detail['cover'];
    title = detail['title'];
    authors = detail['authors'];
    types = detail['types'] ?? '';
    lastReadTime = detail['lastReadTime']??0;
    isFavorite = detail['isFavorite'] ?? 0;
  }

  static Future<List<ComicStore>> getFavoriteComics() async{
    var maps =  await DB.db.query(
        "comicStore", where: "isFavorite = ?", whereArgs: [1]);
    return maps.map((map){
      return new ComicStore.fromMap(map);
    }).toList();
  }
  static Future<List<ComicStore>> getHistoryComics() async{
    var maps =  await DB.db.query(
        "comicStore", where: "lastReadTime != ?", whereArgs: [0],orderBy: 'lastReadTime ASC',limit: 50);
    return maps.map((map){
      return new ComicStore.fromMap(map);
    }).toList();
  }

  saveInfo() {
    getComic(id).then((res) {
      if (res != null) {
        lastReadTime = res.lastReadTime;
        isFavorite = res.isFavorite;
      }
      insert(this);
    });
  }

  changeFavorite() async {
    var batch = DB.db.batch();
    isFavorite = isFavorite == 0 ? 1 : 0;
    batch.update("comicStore", {"isFavorite": isFavorite}, where: "id = ?",
        whereArgs: [id]);
    await batch.commit(noResult: true);
  }

 static read(int id) async {
    var batch = DB.db.batch();
    var lastReadTime = new DateTime.now().millisecond;
    batch.update("comicStore", {"lastReadTime": lastReadTime}, where: "id = ?",
        whereArgs: [id]);
    await batch.commit(noResult: true);
  }

  static Future insert(ComicStore comic) async {
    var batch = DB.db.batch();
    batch.insert(
        "comicStore",
        {
          "id": comic.id,
          "cover": comic.cover,
          "title": comic.title,
          "authors": comic.authors,
          "types": comic.types,
          "lastReadTime": comic.lastReadTime,
          "isFavorite": comic.isFavorite,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true);
  }

  static Future<ComicStore> getComic(int id) async {
    List<Map> maps =
    await DB.db.query("comicStore", where: "id = ?", whereArgs: [id]);
    if (maps.length > 0) {
      return new ComicStore.fromMap(maps.first);
    }
    return null;
  }

  Future<ComicStore> getMyComicInfo() async {
    var maps = await DB.db.query(
        "comicStore", where: "id = ?", whereArgs: [id]);
    if (maps.length > 0) {
      fromMapData(maps.first);
    }
    return this;
  }

  @override
  String toString() {
    return 'ComicStore{id: $id, cover: $cover, title: $title, authors: $authors, types: $types, lastReadTime: $lastReadTime, isFavorite: $isFavorite}';
  }

}
