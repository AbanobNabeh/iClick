class ChatListModel {
  int? iduser;
  String? nameuser;
  String? imageuser;
  int? senderid;
  String? datetime;
  String? lastmsg;
  bool? seen;

  ChatListModel({
    this.iduser,
    this.nameuser,
    this.imageuser,
    this.senderid,
    this.datetime,
    this.lastmsg,
    this.seen,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    return ChatListModel(
      iduser: json['iduser'],
      nameuser: json['nameuser'],
      imageuser: json['imageuser'],
      senderid: json['senderid'],
      datetime: json['datetime'],
      lastmsg: json['lastmsg'],
      seen: json['seen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iduser': iduser,
      'nameuser': nameuser,
      'imageuser': imageuser,
      'senderid': senderid,
      'datetime': datetime,
      'lastmsg': lastmsg,
      'seen': seen,
    };
  }
}
