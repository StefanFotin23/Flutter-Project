// image_details_page.dart
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment.dart'; // Import the Comment class

class ImageDetailsPage extends StatefulWidget {
  final Map<String, dynamic> imageData;

  ImageDetailsPage({required this.imageData});

  @override
  _ImageDetailsPageState createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  TextEditingController _commentController = TextEditingController();

  Future<void> _addComment() async {
    String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      // Create a new Comment instance
      Comment comment = Comment(
        author: 'User123', // Replace with actual user information
        createdDate: Timestamp.now(),
        text: commentText,
      );

      // Add the comment to Firestore
      await FirebaseFirestore.instance
          .collection('comments')
          .doc(widget.imageData['id']) // Use the image ID as the document ID
          .collection('comments')
          .add(comment.toMap());

      // Clear the comment text field
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PhotoView(
              imageProvider: NetworkImage(widget.imageData['url']),
              backgroundDecoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.imageData['description'] ?? 'No description available',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('comments')
                  .doc(widget.imageData['id'])
                  .collection('comments')
                  .orderBy('createdDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No comments yet.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final commentData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(commentData['text']),
                        subtitle: Text('${commentData['author']} - ${commentData['createdDate']}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}