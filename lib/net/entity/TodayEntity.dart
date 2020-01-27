class TodayEntity {
  String id;
  String createdAt;
  String desc;
  String publishedAt;
  String source;
  String type;
  String url;
  bool used;
  String who;
  List<String> images;

  TodayEntity(this.id, this.createdAt, this.desc, this.publishedAt, this.source,
      this.type, this.url, this.used, this.who, this.images);

  TodayEntity.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    createdAt = json['createdAt'];
    desc = json['desc'];
    publishedAt = json['publishedAt'];
    source = json['source'];
    type = json['type'];
    url = json['url'];
    used = json['used'];
    who = json['who'];
    if (json['images'] != null) {
      images = List<String>();
      (json['images'] as List).forEach((v) {
        images.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'createdAt': createdAt,
        'desc': desc,
        'publishedAt': publishedAt,
        'source': source,
        'type': type,
        'url': url,
        'used': used,
        'who': who,
        'images': images
      };

  @override
  String toString() {
    return 'TodayEntity{id: $id, createdAt: $createdAt, desc: $desc, publishedAt: $publishedAt, source: $source, type: $type, url: $url, used: $used, who: $who, images: $images}';
  }
}
