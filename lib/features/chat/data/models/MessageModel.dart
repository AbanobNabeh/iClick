class MessageModel {
  String? datetime;
  String? document;
  String? image;
  String? message;
  String? receiverid;
  bool? seen;
  String? senderid;
  String? video;

  MessageModel({
    required this.datetime,
    required this.document,
    required this.image,
    required this.message,
    required this.receiverid,
    required this.seen,
    required this.senderid,
    required this.video,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      datetime: json['datetime'],
      document: json['document'],
      image: json['image'],
      message: json['message'],
      receiverid: json['receiverid'],
      seen: json['seen'],
      senderid: json['senderid'],
      video: json['video'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'datetime': datetime,
      'document': document,
      'image': image,
      'message': message,
      'receiverid': receiverid,
      'seen': seen,
      'senderid': senderid,
      'video': video,
    };
  }
}
