import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hivep/db/functions/db_functions.dart';
import 'package:hivep/db/model/data_model.dart';
import 'package:hivep/widget/list_student_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddStudentWidget extends StatefulWidget {
  const AddStudentWidget({Key? key});

  @override
  State<AddStudentWidget> createState() => _AddStudentWidgetState();
}

class _AddStudentWidgetState extends State<AddStudentWidget> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _classController = TextEditingController();
  final _numberController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  File? pickedimage;

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Welcome',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                GestureDetector(
                  onTap: () {
                    getimage(ImageSource.camera);
                  },
                  child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color.fromARGB(255, 255, 87, 15),
                      child: pickedimage == null
                          ? const Icon(Icons.camera)
                          : ClipOval(
                              child: Image.file(
                                pickedimage!,
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                              ),
                            )),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Name',
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Age',
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _classController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Class',
                    labelText: 'Class',
                    prefixIcon: Icon(Icons.school),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _numberController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Number',
                    labelText: 'Number',
                    prefixIcon: Icon(Icons.phone),
                    prefixText: '+91',
                  ),
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]')), // Allow only numeric characters
                  ],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      onAddStudentButtonClicked(context);
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onAddStudentButtonClicked(BuildContext context) async {
    final _name = _nameController.text.trim();
    final _age = _ageController.text.trim();
    final _class = _classController.text.trim();
    final _number = _numberController.text.trim();

    if (_name.isEmpty || _age.isEmpty || _class.isEmpty || _number.isEmpty) {
      return;
    }

    final _student = StudentModel(
      name: _name,
      age: _age,
      clas: _class,
      number: _number,
      image: pickedimage?.path ?? '',
    );
    addStudent(_student);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListStudent()),
    );
  }

  getimage(ImageSource source) async {
    var img = await imagePicker.pickImage(source: source);
    setState(() {
      pickedimage = File(img!.path);
    });
  }
}
