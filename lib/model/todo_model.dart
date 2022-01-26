const String tableName = 'todoDB';
class TodoModel {
  final int? id;
  final String title;
  final String? subtitle;
  final String desc;

  const TodoModel({this.id, required this.title, this.subtitle, required this.desc});

  TodoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        subtitle = json['subtitle'],
        desc = json['desc'];

  Map<String, Object?> toJson() {
    return {'id': id, 'title': title, 'subtitle': subtitle, 'desc': desc};
  }
}
