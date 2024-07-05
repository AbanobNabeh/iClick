class Stories {
  int? id;
  String? iduser;
  String? image;
  String? video;
  String? date;
  bool? seen;
  bool? like;
  int? view;

  Stories({
    this.id,
    this.iduser,
    this.image,
    this.video,
    this.date,
    this.seen,
    this.like,
    this.view,
  });

  Stories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iduser = json['iduser'];
    image = json['image'];
    video = json['video'];
    date = json['date'];
    seen = json['seen'];
    like = json['like'];
    view = json['view'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iduser'] = this.iduser;
    data['image'] = this.image;
    data['video'] = this.video;
    data['date'] = this.date;
    data['seen'] = this.seen;
    data['like'] = this.like;

    data['view'] = this.view;
    return data;
  }
}
