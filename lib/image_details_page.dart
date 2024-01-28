import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';  // Import for date formatting

class ImageDetailsPage extends StatefulWidget {
  final Map<String, dynamic> imageData;

  const ImageDetailsPage({Key? key, required this.imageData}) : super(key: key);

  @override
  _ImageDetailsPageState createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  final TextEditingController _commentController = TextEditingController();

  Future<void> _addComment() async {
    String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Comment comment = Comment(
          author: user.displayName ?? user.email!,
          createdDate: Timestamp.now(),
          text: commentText,
        );

        await FirebaseFirestore.instance
            .collection('comments')
            .doc(widget.imageData['id'])
            .collection('comments')
            .add(comment.toMap());

        _commentController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PhotoView(
              imageProvider: NetworkImage(widget.imageData['url'] ?? 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.imageData['description'] ?? 'No description available',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
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
                  return const Center(
                    child: Text('No comments yet.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final commentData = snapshot.data!.docs[index].data()
                      as Map<String, dynamic>;

                      // Format the created date
                      DateTime createdDate = (commentData['createdDate'] as Timestamp).toDate();
                      String formattedDate = DateFormat.yMd().add_Hm().format(createdDate);

                      return ListTile(
                        title: Text(commentData['text']),
                        subtitle: Text('${commentData['author']} - $formattedDate'),
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
