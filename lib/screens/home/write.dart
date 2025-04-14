import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Write extends StatefulWidget {
  final String userName;
  const Write({Key? key, required this.userName}) : super(key: key);

  @override
  State<Write> createState() => _WriteState();
}

class _WriteState extends State<Write> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
 // final postRef = FirebaseDatabase.instance.ref().child('articles');
  //final DatabaseReference _articlesRef = FirebaseDatabase.instance.ref().child('articles');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  // Function to upload the article to Firebase
  Future<void> _uploadArticle() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      DatabaseReference articlesRef = FirebaseDatabase.instance.ref().child('articles');
      String articleId = DateTime.now().millisecondsSinceEpoch.toString();
      String currentDate = DateFormat('MMMM d, yyyy').format(DateTime.now());
      final User? user = _auth.currentUser;
      await articlesRef.child(articleId).set({
        'aTitle': _titleController.text,
        'aDescription': _descriptionController.text,
        'aTime': currentDate,
        'author': user!.email.toString(),  // Store the author's name here
      });

      Fluttertoast.showToast(msg: "Article uploaded successfully.");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to upload article. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Article"),
        backgroundColor: Colors.blueGrey, // Keeping the consistent theme
        centerTitle: true,
        elevation: 0,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title input field with modern styling
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: "Enter article title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[20], // Soft background color
                ),
                maxLength: 50,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Description input field with more space
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: "Enter article description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[20], // Soft background color
                ),
                maxLines: 5,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Upload button with improved style
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _uploadArticle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey, // Consistent theme color
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Upload Article',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
