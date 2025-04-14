import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/screens/home/add_post.dart';
import 'package:untitled1/screens/home/profile.dart'; // Import the user profile page
import 'package:untitled1/screens/home/write.dart';
import 'package:untitled1/screens/home/articleHome.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.ref().child('posts');
  List<dynamic> posts = []; // List to hold all posts
  String searchQuery = '';
  bool isSearching = false;
  bool isLiked = false; // Track if post is liked or not

  @override
  void initState() {
    super.initState();

    // Listen for changes in the Firebase Database
    dbRef
        .child('post List')
        .orderByChild('pTime')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          posts.clear();
          // Safely cast the snapshot value to Map<dynamic, dynamic>
          Map<dynamic, dynamic> values = Map.from(
              event.snapshot.value as Map<dynamic, dynamic>);
          values.forEach((key, value) {
            posts.add(value);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey,
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('images/avtar.jpeg'),
              ),
            ),
          ),
          title: isSearching
              ? TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search posts...',
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          )
              : Text('Blog Posts'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPost()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.edit_note), // Small write icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArticlesPage()),
                );
              },
            ),
            SizedBox(width: 16),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: dbRef.child('post List').orderByChild('pTime'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  if (snapshot.value != null) {
                    dynamic post = snapshot.value;
                    if (post != null &&
                        post['pImage'] != null &&
                        post['pTitle'] != null &&
                        post['pDescription'] != null) {
                      if (searchQuery.isEmpty ||
                          post['pTitle']
                              .toLowerCase()
                              .contains(searchQuery) ||
                          post['pDescription']
                              .toLowerCase()
                              .contains(searchQuery)) {
                        return _buildPostCard(post);
                      } else {
                        return Container(); // Post doesn't match search query
                      }
                    } else {
                      return Container(); // Handle if data structure is incomplete
                    }
                  } else {
                    return Container(); // Handle if snapshot is null
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<dynamic, dynamic> post) {
    // Retrieve and handle the timestamp (pTime) stored in Firebase
    dynamic pTime = post['pTime']; // Firebase timestamp or string date

    DateTime postDate;

    // If pTime is a string date (e.g., "July 27, 2024"), parse it
    if (pTime is String) {
      try {
        postDate = DateFormat('MMMM d, yyyy').parse(pTime); // Parse string like "July 27, 2024"
      } catch (e) {
        postDate = DateTime(1970); // Fallback in case of parsing error
      }
    } else if (pTime is int) {
      // If pTime is already in milliseconds, use it directly
      postDate = DateTime.fromMillisecondsSinceEpoch(pTime);
    } else {
      postDate = DateTime(1970); // Fallback if pTime is neither string nor int
    }

    String displayDate = DateFormat.yMMMd().format(postDate); // Format for display

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display user's name and profile icon above the image
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage(
                        'images/avtar.jpeg'), // Profile picture
                  ),
                  SizedBox(width: 8),
                  Text(
                    post['uEmail'], // Display user's name
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    displayDate, // Display formatted date
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: FadeInImage.assetNetwork(
                placeholder: 'images/logo1.jpeg',
                image: post['pImage'],
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['pTitle'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    post['pDescription'],
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.thumb_up : Icons
                                  .thumb_up_alt_outlined,
                              color: isLiked ? Colors.red : Colors.blueGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked; // Toggle the like status
                              });
                            },
                          ),
                          Text(
                            'Like',
                            style: TextStyle(
                              color: isLiked ? Colors.red : Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.comment_outlined,
                                color: Colors.blueGrey),
                            onPressed: () {
                              // TODO: Add functionality for commenting on a post
                            },
                          ),
                          Text(
                            'Comment',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
