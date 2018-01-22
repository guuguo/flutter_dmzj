import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
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
}
