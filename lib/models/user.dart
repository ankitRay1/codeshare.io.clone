import 'dart:convert';

class User {
  final String name;
  final String email;
  final String profilePic;
  final String uid;
  final String token;

  User(
      {required this.name,
      required this.email,
      required this.profilePic,
      required this.uid,
      required this.token});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'profilePic': profilePic});
    result.addAll({'uid': uid});
    result.addAll({'token': token});

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
      uid: map['uid'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? name,
    String? email,
    String? profilePic,
    String? uid,
    String? token,
  }) {
    return User(
      email: name ?? this.email,
      name: email ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      token: token ?? this.token,
    );
  }
}
