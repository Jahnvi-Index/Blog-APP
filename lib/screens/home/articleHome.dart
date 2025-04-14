import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'write.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final DatabaseReference _articlesRef = FirebaseDatabase.instance.ref().child('articles');
  List<Map<String, String>> articles = [];
  bool _isLoading = true;
  Set<String> _clappedArticles = {}; // To track which articles have been clapped

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  // Fetch articles from Firebase Realtime Database
  Future<void> _fetchArticles() async {
    try {
      final DataSnapshot snapshot = await _articlesRef.get();
      final Map<Object?, Object?>? data = snapshot.value as Map<Object?, Object?>?;

      if (data != null) {
        final List<Map<String, String>> fetchedArticles = [];
        data.forEach((key, value) {
          final article = value as Map<Object?, Object?>;
          fetchedArticles.add({
            "title": article["aTitle"]?.toString() ?? "Untitled",
            "description": article["aDescription"]?.toString() ?? "No description available",
            "time": article["aTime"]?.toString() ?? "Unknown date",
            "userName": article["userName"]?.toString() ?? "Anonymous",
          });
        });

        setState(() {
          articles = fetchedArticles;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch articles: $e")),
      );
    }
  }

  // Function to handle the clap button toggle
  void _toggleClap(String articleId) {
    setState(() {
      if (_clappedArticles.contains(articleId)) {
        _clappedArticles.remove(articleId); // Remove if already clapped
      } else {
        _clappedArticles.add(articleId); // Add to clapped set
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current authenticated user
    final user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName ?? user?.email ?? "jahnvi";  // Use FirebaseAuth user name

    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : articles.isEmpty
          ? const Center(
        child: Text(
          "No articles available. Add some!",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          String articleId = article['title']!; // You can use a unique identifier
          bool isClapped = _clappedArticles.contains(articleId);

          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              title: Text(
                article['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['description']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Posted by: jahnvi",
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _toggleClap(articleId),
                            child: Icon(
                              Icons.favorite,
                              color: isClapped ? Colors.red : Colors.grey,
                            ),
                          ),
                          Text(
                            article['time']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Ensure the correct userName is passed when navigating to Write screen
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Write(userName: userName), // Pass authenticated user's name
            ),
          );
          _fetchArticles();
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
    );
  }
}
