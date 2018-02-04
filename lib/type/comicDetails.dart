import 'dart:convert';


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


  ComicDetail(jsonStr) {
    var jsonRes = JSON.decode(jsonStr);

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

    for (var authorsItem in jsonRes['authors']){

      authors.add(new TagBean(authorsItem));
    }

    chapters = [];

    for (var chaptersItem in jsonRes['chapters']){

      chapters.add(new ChapterSectionBean(chaptersItem));
    }

    status = [];

    for (var statusItem in jsonRes['status']){

      status.add(new TagBean(statusItem));
    }

    types = [];

    for (var typesItem in jsonRes['types']){

      types.add(new TagBean(typesItem));
    }

    comment = new CommentResult(jsonRes['comment']);

  }

  @override
  String toString() {
    return '{"uid": $uid,"copyright": $copyright,"direction": $direction,"hit_num": $hit_num,"hot_num": $hot_num,"id": $id,"is_dmzj": $is_dmzj,"islong": $islong,"last_updatetime": $last_updatetime,"subscribe_num": $subscribe_num,"cover": ${cover != null?'${JSON.encode(cover)}':'null'},"description": ${description != null?'${JSON.encode(description)}':'null'},"first_letter": ${first_letter != null?'${JSON.encode(first_letter)}':'null'},"title": ${title != null?'${JSON.encode(title)}':'null'},"authors": $authors,"chapters": $chapters,"status": $status,"types": $types,"comment": $comment}';
  }
}



class CommentResult {

  int comment_count;
  List<CommentBean> latest_comment;


  CommentResult(jsonRes) {
    comment_count = jsonRes['comment_count'];
    latest_comment = [];

    for (var latest_commentItem in jsonRes['latest_comment']){

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
    return '{"comment_id": $comment_id,"createtime": $createtime,"uid": $uid,"avatar": ${avatar != null?'${JSON.encode(avatar)}':'null'},"content": ${content != null?'${JSON.encode(content)}':'null'},"nickname": ${nickname != null?'${JSON.encode(nickname)}':'null'}}';
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
    return '{"tag_id": $tag_id,"tag_name": ${tag_name != null?'${JSON.encode(tag_name)}':'null'}}';
  }
}


class ChapterSectionBean {

  String title;
  List<ChapterBean> data;


  ChapterSectionBean(jsonRes) {
    title = jsonRes['title'];
    data = [];

    for (var dataItem in jsonRes['data']){

      data.add(new ChapterBean(dataItem));
    }


  }

  @override
  String toString() {
    return '{"title": ${title != null?'${JSON.encode(title)}':'null'},"data": $data}';
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
    return '{"chapter_id": $chapter_id,"chapter_order": $chapter_order,"filesize": $filesize,"updatetime": $updatetime,"chapter_title": ${chapter_title != null?'${JSON.encode(chapter_title)}':'null'}}';
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
    return '{"tag_id": $tag_id,"tag_name": ${tag_name != null?'${JSON.encode(tag_name)}':'null'}}';
  }
}

