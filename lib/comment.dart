// comment.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String author;
  final Timestamp createdDate;
  final String text;

  Comment({
    required this.author,
    required this.createdDate,
    required this.text,
  });

  // Convert Comment to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'createdDate': createdDate,
      'text': text,
    };
  }
}