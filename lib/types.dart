class Comic {
  var id = 0;
  var status = "";
  var title = "";
  var last_name = "";
  var cover = "";
  var authors = "";
  var types = "";
  var hot_hits = "";

  Comic();

  @override
  String toString() => 'Comic($title)';

  Comic.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        status = map['id'],
        title = map['id'],
        last_name = map['id'],
        cover = map['id'],
        authors = map['id'],
        types = map['id'],
        hot_hits = map['id'];
}
