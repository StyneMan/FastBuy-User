class ZoneModel {
  List<dynamic>? area;
  bool? publish;
  double? latitude;
  String? name;
  String? id;
  double? longitude;

  ZoneModel(
      {this.area,
      this.publish,
      this.latitude,
      this.name,
      this.id,
      this.longitude});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    if (json['area'] != null) {
      area = <dynamic>[];
      json['area'].forEach((v) {
        area!.add(v);
      });
    }

    publish = json['publish'];
    latitude = json['latitude'];
    name = json['name'];
    id = json['id'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (area != null) {
      data['area'] = area!.map((v) => v).toList();
    }
    data['publish'] = publish;
    data['latitude'] = latitude;
    data['name'] = name;
    data['id'] = id;
    data['longitude'] = longitude;
    return data;
  }
}
