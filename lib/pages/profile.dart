import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fooddelieveryapp/pages/signup.dart';
import 'package:fooddelieveryapp/service/auth.dart';
import 'package:fooddelieveryapp/service/shared_pref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  // Function to pick image from gallery
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    selectedImage = File(image!.path);
    setState(() {
      uploadItem();
    });
  }

  // Upload image to Firebase Storage
  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImages").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserProfile(downloadUrl);
      setState(() {});
    }
  }

  // Get user data from Shared Preferences
  getthesharedpref() async {
    profile = await SharedPreferenceHelper().getUserProfile();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  // Initialize and load user data on screen load
  onthisload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    onthisload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null
          ? CircularProgressIndicator()
          : Container(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
                        height: MediaQuery.of(context).size.height / 4.3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.elliptical(
                                    MediaQuery.of(context).size.width, 105.0))),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 6.5),
                          child: Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(60),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: selectedImage == null
                                  ? GestureDetector(
                                      onTap: () {
                                        getImage();
                                      },
                                      child: profile == null
                                          ? Image.asset(
                                              "images/boy.jpg",
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              profile!,
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            ),
                                    )
                                  : Image.file(
                                      selectedImage!,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 70.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Name Section
                  ProfileDetailRow(icon: Icons.person, label: "Name", value: name!),
                  SizedBox(
                    height: 30.0,
                  ),
                  // Email Section
                  ProfileDetailRow(icon: Icons.email, label: "Email", value: email!),
                  SizedBox(
                    height: 30.0,
                  ),
                  // Terms and Conditions Section
                  ProfileDetailRow(
                    icon: Icons.description,
                    label: "Terms and Condition",
                    value: "",
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  // Delete Account Section
                  GestureDetector(
                    onTap: () async {
                      try {
                        await AuthMethods().deleteuser(); // Delete user logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Account Deleted!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error deleting account: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: ProfileActionRow(
                      icon: Icons.delete,
                      label: "Delete Account",
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  // Logout Section
                  GestureDetector(
                    onTap: () async {
                      try {
                        await AuthMethods().SignOut(); // Logout logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Logged out successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error logging out: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: ProfileActionRow(
                      icon: Icons.logout,
                      label: "LogOut",
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value,
                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ProfileActionRow widget for action buttons (delete/logout)
class ProfileActionRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const ProfileActionRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
