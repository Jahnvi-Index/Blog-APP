import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:untitled1/components/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.ref().child('posts/post List');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  File? _image;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future getImageGallery() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('No Image selected');
      }
    });
  }

  Future getImageCamera() async {
    final PickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('No Image selected');
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getImageCamera();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Upload Post'),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width * 2,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: InkWell(
                    onTap: () {
                      dialog(context);
                    },
                    child: Center(
                      child: _image != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _image!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: titleController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            hintText: 'Enter Post Title',
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                            labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: descriptionController,
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText: 'Description about Post',
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                            labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(height: 25),
                        RoundButton(
                          title: 'Upload',
                          onPress: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              // Generate the current timestamp as human-readable date
                              String formattedDate = DateFormat('MMMM d, yyyy').format(DateTime.now());
                              int timestamp = DateTime.now().microsecondsSinceEpoch;

                              // Upload the image to Firebase Storage
                              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/untitled1$timestamp');
                              UploadTask uploadTask = ref.putFile(_image!.absolute);
                              await Future.value(uploadTask);
                              var newUrl = await ref.getDownloadURL();

                              final User? user = _auth.currentUser;

                              // Store post data in Firebase Realtime Database
                              postRef.child(timestamp.toString()).set({
                                'pId': timestamp.toString(),
                                'pImage': newUrl.toString(),
                                'pTime': formattedDate, // Store formatted date string
                                'pTitle': titleController.text.toString(),
                                'pDescription': descriptionController.text.toString(),
                                'uEmail': user!.email.toString(),
                                'uId': user!.uid.toString(),
                              }).then((value) {
                                toastMessage('Post Published');
                                setState(() {
                                  showSpinner = false;
                                });
                              }).onError((error, stackTrace) {
                                toastMessage(error.toString());
                                setState(() {
                                  showSpinner = false;
                                });
                              });
                            } catch (e) {
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage(e.toString());
                            }
                          },
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
