import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  int? id;
  String? name;
  String? url;

  Category({this.id, this.name, this.url});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }

  factory Category.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return Category(id: data["id"], name: data["name"], url: data["url"]);
  }

  Future<List<Category>> getCategory() async {
    var db = FirebaseFirestore.instance;
    var snapshot = await db.collection("category").get();
    var list = snapshot.docs.map((e) => Category.fromSnapshot(e)).toList();
    return list;
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, url: $url}';
  }
}
