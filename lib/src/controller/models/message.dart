import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  FieldValue timestamp;
  String photoUrl;

  Message(
      {this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.timestamp});

  //Will be only called when you wish to send an image
  Message.imageMessage(
      {this.senderId,
      this.receiverId,
      this.message,
      this.type,
      this.timestamp,
      this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['timestamp'] = this.timestamp;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

   factory Message.fromFirebase(Map<String, dynamic> map) {
    return Message(
        senderId: map['senderId'],
        receiverId: map['receiverId'],
        type: map['type'],
        message: map['message'],
        timestamp: map['timestamp']);
  }
}
