import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userEmail = 'janvi11@gmail.com'; // Example email (replace with actual dynamic data)
  int postCount = 25; // Example post count (replace with actual dynamic data)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              // backgroundImage: AssetImage('assets/profile_image.jpg'), // Replace with user's profile image
            ),
            SizedBox(height: 20),
            Text(
              userEmail,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Posts: $postCount',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showPostCountDialog(context);
              },
              child: Text('View Posts'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostCountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Number of Posts'),
          content: Text('You have $postCount posts.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
