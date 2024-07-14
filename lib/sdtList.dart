import 'dart:io';

import 'package:db/functions/functions.dart';
import 'package:db/model.dart';
import 'package:db/profile.dart';
import 'package:db/refresh_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  late List<Map<String, dynamic>> _studentsData = [];
  TextEditingController searchController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _fetchStudentsData();
  }

  Future<void> _fetchStudentsData() async {
    List<Map<String, dynamic>> students = await getAllStudent();
    if (searchController.text.isNotEmpty) {
      students = students
          .where((student) => student['name']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      _studentsData = students;
    });
  }

  Future<void> _showEditDialog(int index) async {
    final student = _studentsData[index];
    final TextEditingController nameController =
        TextEditingController(text: student['name']);
    final TextEditingController rollnoController =
        TextEditingController(text: student['rollno'].toString());
    final TextEditingController departmentController =
        TextEditingController(text: student['department']);
    final TextEditingController phonenoController =
        TextEditingController(text: student['phoneno'].toString());
    showDialog(
      context: context,
      builder: (BuildContext) => AlertDialog(
        title: Text("Edit student "),
        content: SingleChildScrollView(
          child: Column(children: [
            GestureDetector(
              onTap: () async {
                final pickedImage = await _pickImageFromCamera();
                if (pickedImage != null) {
                  setState(() {
                    _selectedImage = pickedImage;
                  });
                }
              },
              child: CircleAvatar(
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : student['imageurl'] != null
                        ? FileImage(File(student['imageurl']))
                        : null,
                child: _selectedImage == null && student['imageurl'] == null
                    ? Icon(Icons.person)
                    : null,
              ),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextFormField(
              controller: rollnoController,
              decoration: InputDecoration(labelText: "Roll No"),
            ),
            TextFormField(
              controller: departmentController,
              decoration: InputDecoration(labelText: "Department"),
            ),
            TextFormField(
              controller: phonenoController,
              decoration: InputDecoration(labelText: "Phone Number"),
            ),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await updateStudent(
                StudentModel(
                  id: student['id'],
                  rollno: rollnoController.text,
                  name: nameController.text,
                  department: departmentController.text,
                  phoneno: phonenoController.text,
                  imageurl: _selectedImage != null
                      ? _selectedImage!.path
                      : student['imageurl'],
                ),
              );

              // Navigator.of(context).pop();
              await _fetchStudentsData();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => refreshScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text("Changes saved successfully"),
              ));
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 229, 202),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 251, 202, 139),
        title: Text('Student Information'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            color: Color.fromARGB(255, 251, 219, 178),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    _fetchStudentsData();
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: "Search by Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _studentsData.isEmpty
          ? Center(child: Text('No students available.'))
          : ListView.separated(
              itemBuilder: (context, index) {
                final student = _studentsData[index];
                final id = student['id'];
                final imageUrl = student['imageurl'];

                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudentProfile(
                            student: StudentModel.fromMap(student)),
                      ),
                    );
                  },
                  leading: GestureDetector(
                    onTap: () {
                      if (imageUrl != null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.file(File(imageUrl)),
                                  ],
                                ),
                              );
                            });
                      }
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          imageUrl != null ? FileImage(File(imageUrl)) : null,
                      child: imageUrl == null ? Icon(Icons.person) : null,
                    ),
                  ),
                  title: Text(student['name']),
                  subtitle: Text(student['department']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showEditDialog(index);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext) => AlertDialog(
                                    title: Text("DeleteStudent"),
                                    content: Text(
                                        "Are you sure you want to delete?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await deleteStudent(id);
                                          _fetchStudentsData();
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content:
                                                Text("delete successfully"),
                                          ));
                                        },
                                        child: Text("ok"),
                                      )
                                    ],
                                  ));
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: _studentsData.length,
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
