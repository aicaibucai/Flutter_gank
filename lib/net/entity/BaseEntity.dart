import 'TodayEntity.dart';

class BaseEntity<T> {
  List<String> category;
  T results;
  bool error;
  int count;
  BaseEntity(this.category, this.results, this.error);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['category'] != null) {
      category = new List<String>();
      (json['category'] as List).forEach((v) {
        category.add(v);
      });
    }
    if (json['results'] != null) {
      results = generateOBJ(json['results']);
    }
    if(json['count']!=null){
      count=json['count'];
    }
  }

  static T generateOBJ<T>(json) {
    print("Type:${T.toString()}");
    if (T == null) {
      return null;
    } else if (T.toString() == 'TodayEntity') {
      return TodayEntity.fromJson(json) as T;
    } else if (T.toString() == 'Map<String, TodayEntity>') {
      Map<String, TodayEntity> temp = Map<String, TodayEntity>();
      (json as Map<String, dynamic>).forEach((key, value) {
        temp[key] = TodayEntity.fromJson(value);
      });
      return temp as T;
    } else if (T.toString() == 'Map<String, List<TodayEntity>>') {
      Map<String, List<TodayEntity>> temp = Map<String, List<TodayEntity>>();
      (json as Map<String, dynamic>).forEach((key, value) {
        temp[key] = List();
        (value as List).forEach((f) {
          temp[key].add(TodayEntity.fromJson(f));
        });
      });
      return temp as T;
    } else if (T.toString() == "List<TodayEntity>") {
      List<TodayEntity> temp = List();
      (json as List).forEach((value) {
        temp.add(TodayEntity.fromJson(value));
      });
      return temp as T;
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() =>
      {'results': results, 'error': error, 'category': category};

  @override
  String toString() {
    return 'BaseEntity{category: $category, results: $results, error: $error}';
  }
}
