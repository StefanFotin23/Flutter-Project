// home_page.dart
import 'package:flutter/material.dart';
import 'unsplash_api.dart';
import 'image_details_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _colorFilter = '';

  Future<List<Map<String, dynamic>>> _fetchImages() async {
    try {
      return await UnsplashApi.searchImages(_searchQuery, _colorFilter);
    } catch (e) {
      // Handle error
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unsplash App'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _searchQuery = _searchController.text;
          });
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _searchQuery = _searchController.text;
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchImages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No results found.'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final imageData = snapshot.data![index];
                        return ListTile(
                          title: Text(imageData['title']),
                          subtitle: Text(imageData['description']),
                          leading: Image.network(imageData['url']),
                          onTap: () {
                            // TODO: Navigate to image details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageDetailsPage(imageData: imageData),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}