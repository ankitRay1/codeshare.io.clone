import 'dart:convert';

class Document {
  final String id;
  final String uid;

  final String title;
  final int createdAt;
  final int updatedAt;
  final List content;
  Document(
      {required this.id,
      required this.uid,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'documentId': id});
    result.addAll({'uid': uid});
    result.addAll({'title': title});
    result.addAll({'content': content});

    return result;
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['documentId'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      content: List.from(map['content']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Document.fromJson(String source) =>
      Document.fromMap(json.decode(source));
}
