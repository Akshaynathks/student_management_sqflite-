import 'dart:io';

import 'package:db/functions/functions.dart';
import 'package:db/model.dart';
import 'package:db/sdtList.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final rollnoController = TextEditingController();
  final departmentController = TextEditingController();
  final phonenoController = TextEditingController();
  File? _selectedImage;

  void _setImage(File Image) {
    setState(() {
      _selectedImage = Image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 250, 229, 202),
      appBar: AppBar(
        title: Text(
          'Registration',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentList()),
              );
            },
            icon: Icon(Icons.list_alt_outlined),
            color: Colors.black,
          )
        ],
        backgroundColor: Color.fromARGB(255, 251, 202, 139),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 60),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Color.fromARGB(255, 251, 219, 178),
                maxRadius: 60,
                child: GestureDetector(
                  onTap: () async {
                    File? pickedImage = await _pickImageFromCamera();
                    if (pickedImage != null) {
                      _setImage(pickedImage);
                    }
                  },
                  child: _selectedImage != null
                      ? ClipOval(
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          ),
                        )
                      : const Icon(Icons.add_a_photo_rounded),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: "Student Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  if (value.length < 4) {
                    return 'Name is too short';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: rollnoController,
                decoration: InputDecoration(
                    labelText: "Roll Number",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.format_list_numbered)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Roll no is required';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  keyboardType: TextInputType.name,
                  controller: departmentController,
                  decoration: const InputDecoration(
                      labelText: "Department",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Department is required";
                    }
                    if (value.length < 2) {
                      return 'Department name must be atleast 2 charecters';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  }),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: phonenoController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone number is required';
                  }
                  final phoneRegExp = RegExp(r'^[0-9]{10}$');
                  if (!phoneRegExp.hasMatch(value)) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
              ),
              
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                    backgroundColor:Color.fromARGB(255, 251, 219, 178)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "please select an image",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                      return;
                    }
                    final student = StudentModel(
                      rollno: rollnoController.text,
                      name: nameController.text,
                      department: departmentController.text,
                      phoneno: phonenoController.text,
                      imageurl:
                          _selectedImage != null ? _selectedImage!.path : null,
                    );
                    await addStudent(student);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        "Data Added successfully",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ));
                    rollnoController.clear();
                    nameController.clear();
                    departmentController.clear();
                    phonenoController.clear();
                    setState(() {
                      _selectedImage = null;
                    });
                  }
                },
                child: Text('save'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> _pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }
}
