import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hivep/db/functions/db_functions.dart';
import 'package:hivep/db/model/data_model.dart';

import 'package:hivep/widget/list_student_widget.dart';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  const EditScreen(
      {super.key,
      required this.name,
      required this.age,
      required this.number,
      required this.clas,
      required this.image,
      required this.index});
  final String name;
  final String age;
  final String number;

  final String clas;
  final dynamic image;
  final int index;

  @override
  State<EditScreen> createState() => _EditScreen();
}

class _EditScreen extends State<EditScreen> {
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController agecontroller = TextEditingController();
  final TextEditingController clasController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  File? selectedimage;

  @override
  void initState() {
    namecontroller.text = widget.name;
    agecontroller.text = widget.age;
    clasController.text = widget.clas;
    numberController.text = widget.number;

    selectedimage = widget.image != null ? File(widget.image) : null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 80, 0, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'S T U D E N T',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                              radius: 100,
                              backgroundImage: selectedimage != null
                                  ? FileImage(selectedimage!)
                                  : const AssetImage(
                                          "assets/images/profile.png")
                                      as ImageProvider),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.black)),
                                  onPressed: () {
                                    fromgallery();
                                  },
                                  child: const Text(
                                    'G A L L E R Y',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.black)),
                                  onPressed: () {
                                    fromcam();
                                  },
                                  child: const Text(
                                    'C A M E R A',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: namecontroller,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'N A M E',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: agecontroller,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'A G E',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: clasController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'C L A S S',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: numberController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'N U M B E R',
                              ),
                              maxLength: 10,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.black)),
                                onPressed: () {
                                  update();
                                },
                                child: const Text(
                                  'U P D A T E',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  update() async {
    final edited_name = namecontroller.text.trim();
    final edited_age = agecontroller.text.trim();
    final edited_clas = clasController.text.trim();
    final edited_number = numberController.text.trim();

    final edited_image = selectedimage?.path;

    if (edited_name.isEmpty ||
        edited_age.isEmpty ||
        edited_clas.isEmpty ||
        edited_number.isEmpty) {
      return;
    }
    final updated = StudentModel(
        name: edited_name,
        age: edited_age,
        clas: edited_clas,
        number: edited_number,
        image: edited_image!);

    editstudent(widget.index, updated);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Updated Successfully'),
      behavior: SnackBarBehavior.floating,
    ));
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ListStudent(),
    ));
  }

  fromgallery() async {
    final returnedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedimage = File(returnedimage!.path);
    });
  }

  fromcam() async {
    final returnedimage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      selectedimage = File(returnedimage!.path);
    });
  }
}
